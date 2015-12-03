//
//  AW_ActiveDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/18.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ActiveDataSource.h"
#import "SVProgressHUD.h"
#import "AW_SimilaryCommodityModal.h"//模型类
#import "AW_ProduceCollectionCell.h"//cell类
#import "WaterFLayout.h"
#import "IMB_AlertView.h"
#import "AW_ActiveHeadView.h"
#import "AW_ProduceFilterView.h"
#import "DeliveryAlertView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "DeliveryAlertView.h"
#import "AW_DeleteAlertMessage.h"
#import "AFNetworking.h"
#import "AW_Constants.h"

@interface AW_ActiveDataSource()<UICollectionViewDelegateFlowLayout>
/**
 *  @author cao, 15-11-11 11:11:56
 *
 *  用来计算高度的cell
 */
@property(nonatomic,strong)AW_ProduceCollectionCell * SizeCell;
/**
 *  @author cao, 15-10-27 15:10:55
 *
 *  记录总页数
 */
@property(nonatomic,copy)NSString * totolPage;
/**
 *  @author cao, 15-10-27 15:10:08
 *
 *  当前的页数
 */
@property(nonatomic,copy)NSString * currentPage;
@end

@implementation AW_ActiveDataSource

@synthesize isNotFirstLoading = _isNotFirstLoading;
@synthesize isLoadingData = _isLoadingData;
@synthesize hasLoadMoreFooter = _hasLoadMoreFooter;
@synthesize hasRefreshHeader = _hasRefreshHeader;


-(AW_ProduceCollectionCell *)SizeCell{
    if (!_SizeCell) {
        _SizeCell = BundleToObj(@"AW_ProduceCollectionCell");
    }
    return _SizeCell;
}

#pragma mark - Release method


- (void)dealloc{
    [self releaseResources];
    NSLog(@"%@ dealloc ...",NSStringFromClass([self class]));
}

#pragma mark - Life Cycle method

- (id)initWithDidSelectObjectBlock:(DidSelectObjectBlock)didSelectObjectBlock{
    if (self = [super init]) {
        self.didSelectObjectBlock = didSelectObjectBlock;
    }
    return self;
}

#pragma mark - Propery method

- (NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setHasRefreshHeader:(BOOL)hasRefreshHeader{
    if (_hasRefreshHeader != hasRefreshHeader) {
        _hasRefreshHeader = hasRefreshHeader;
        __block typeof(self) weakSelf = self;
        if (hasRefreshHeader) {
            [_collectionView addHeaderWithCallback:^{
                // 判断是否正在上提分页加载数据
                if (!weakSelf.isLoadingData) {
                    weakSelf.collectionView.footerHidden = YES;
                    [weakSelf refreshData];
                }else{
                    [_collectionView headerEndRefreshing];
                }
            }];
            [_collectionView headerBeginRefreshing];
        }
    }
}


- (void)setHasLoadMoreFooter:(BOOL)hasLoadMoreFooter{
    if (self.hasLoadMoreFooter != hasLoadMoreFooter) {
        _hasLoadMoreFooter = hasLoadMoreFooter;
        __block typeof(self) weakSelf = self;
        [_collectionView addFooterWithCallback:^{
            if (_isNotFirstLoading) {
                [weakSelf nextPageData];
                _isLoadingData = YES;
            }
        }];
        if (_hasLoadMoreFooter) {
            
            [_collectionView setFooterHidden:YES];
            [_collectionView footerBeginRefreshing];
        }
    }
}


- (void)dataDidLoad{
    [_collectionView reloadData];
    if (_hasRefreshHeader) {
        [_collectionView headerEndRefreshing];
    }
    if (_hasLoadMoreFooter) {
        [_collectionView footerEndRefreshing];
        self.isLoadingData = NO;
    }
    if (!_isNotFirstLoading) {
        _isNotFirstLoading = YES;
    }
} // 数据已经加载完毕

#pragma mark - Public method

/**
 *  @author cao, 15-08-17 19:08:36
 *
 *  刷新数据
 */
- (void)refreshData{
    if (self.dataArr.count > 0) {
        [self.dataArr removeAllObjects];
    }
    [self performSelector:@selector(getTestData) withObject:nil afterDelay:1];
}

-(void)getTestData{
    __weak typeof(self) weakSelf = self;
    //在这进行活动请求
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    if (!user_id) {
       user_id = @"";
    }
    NSDictionary * dict = @{@"userId":user_id,@"id":self.active_id};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * activeDict = @{@"jsonParam":str,@"token":@"",@"param":@"getHuodongComList"};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:activeDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
         NSArray * artArray = [responseObject[@"info"] valueForKey:@"data"];
        if ([responseObject[@"code"]intValue] == 0) {
            //将页码总数记录下来
            weakSelf.totolPage = [responseObject[@"info"] valueForKey:@"totalNumber"];
            //记录活动名称
            weakSelf.activeName = [responseObject[@"info"] valueForKey:@"name"];
            //插入商品modal
            [artArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * artDict =obj;
                AW_SimilaryCommodityModal * ArtModal = [[AW_SimilaryCommodityModal alloc]init];
                AW_CommodityModal * commidityModal = [[AW_CommodityModal alloc]init];
                ArtModal.commidityModal = commidityModal;
                commidityModal.commodity_Id = artDict[@"id"];
                commidityModal.commodity_Name = artDict[@"name"];
                commidityModal.commodityPrice = artDict[@"price"];
                commidityModal.commidity_width = [artDict[@"width"]intValue];
                commidityModal.commidity_height = [artDict[@"height"]intValue];
                commidityModal.isCollected = [artDict[@"isCollected"]boolValue];
                commidityModal.clearImageURL = artDict[@"clear_img"];
                commidityModal.fuzzyImageURL = artDict[@"fuzzy_img"];
                ArtModal.size = [weakSelf sizeOfArtCellWith:ArtModal];
                [weakSelf.dataArr addObject:ArtModal];
            }];
            _collectionView.footerHidden = YES;
            [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

-(CGSize)sizeOfArtCellWith:(AW_SimilaryCommodityModal*)art{
    //计算图片高度
    float imageHeight;
    if (art.commidityModal.clearImageURL) {
        imageHeight = ((kSCREEN_WIDTH - 30)/ 2) / art.commidityModal.commidity_width  * art.commidityModal.commidity_height;
        art.commidityModal.commidity_height = imageHeight;
    }else{
        imageHeight = ((kSCREEN_WIDTH - 30)/ 2) ;
        art.commidityModal.commidity_height = imageHeight;
    }
    self.SizeCell.imageConstant.constant = imageHeight;
    NSLog(@"%@",art.commidityModal.commodity_Name);
    self.SizeCell.describeLabel.preferredMaxLayoutWidth = ((kSCREEN_WIDTH - 30)/ 2) - 16;
    self.SizeCell.describeLabel.text = art.commidityModal.commodity_Name;
    //计算文字高度
    NSDictionary * fontAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    //使用字体大小来计算每一行的高度，每一行片段的起点，而不是base line的起点
    CGSize LabelSize = [art.commidityModal.commodity_Name boundingRectWithSize:CGSizeMake(((kSCREEN_WIDTH - 30)/ 2) - 16, CGFLOAT_MAX) options:
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading attributes:fontAttributes context:nil].size;
    [self.SizeCell.describeLabel sizeToFit];
    [self.SizeCell layoutIfNeeded];
    [self.SizeCell.contentView layoutIfNeeded];
    CGSize size = CGSizeMake((kSCREEN_WIDTH - 30)/2, imageHeight + LabelSize.height + 36 + 8);
    return size;
}

//释放资源
-(void)releaseResources{
    self.collectionView = nil;
    _didSelectObjectBlock = nil;
    [_dataArr removeAllObjects];
    _dataArr = nil;
}

#pragma mark - UICollectionViewDataSource Menthod

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%ld",self.dataArr.count);
    return self.dataArr.count;

}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AW_ProduceCollectionCell * cell;
    static NSString * CellIdentifier = @"ActiveCell";
    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.index = indexPath.item;
    if (self.dataArr.count!=0) {
        AW_SimilaryCommodityModal * art = self.dataArr[indexPath.item];
        //获取cell的索引
        cell.index = indexPath.item;
        cell.describeLabel.text = [NSString stringWithFormat:@"%@",art.commidityModal.commodity_Name];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",art.commidityModal.commodityPrice.floatValue];
        //判断网络状态和是否开启了省流量模式
        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
        if ([[user objectForKey:@"patternState"]isEqualToString:@"yes"]&&[[user objectForKey:@"NetState"]isEqualToString:@"切换到WWAN网络"]) {
         [cell.artImage sd_setImageWithURL:[NSURL URLWithString:art.commidityModal.fuzzyImageURL]placeholderImage:PLACE_HOLDERIMAGE];
        }else{
        [cell.artImage sd_setImageWithURL:[NSURL URLWithString:art.commidityModal.clearImageURL]placeholderImage:PLACE_HOLDERIMAGE];
        
        }
        cell.imageConstant.constant = art.commidityModal.commidity_height;
        if (art.commidityModal.isCollected == YES) {
            cell.praiseImageView.image = [UIImage imageNamed:@"赞1"];
            [cell.storeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            cell.praiseImageView.image = [UIImage imageNamed:@"赞-空"];
            [cell.storeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
    cell.layer.cornerRadius = 5.0f;
    cell.contentView.layer.cornerRadius = 5.0f;
    [cell.contentView layoutIfNeeded];
    [cell layoutIfNeeded];
    __weak typeof(self) weakSelf= self;
    //点击收藏按钮后的回调
    __weak typeof(cell) weakCell = cell;
    cell.didClickedStoreBtn = ^(NSInteger index){
        //判断用户是否已经登陆(判断用户的登录状态)
        //获取UserDefault
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *name = [userDefault objectForKey:@"name"];
        if (!name) {
            //如果没有登陆走这个方法
            DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
            AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:self options:nil][1];
            contentView.bounds = Rect(0, 0, 272, 130);
            alertView.contentView = contentView;
            [alertView showWithoutAnimation];
            //点击确定或取消按钮的回调(弹出视图)
            contentView.didClickedBtn = ^(NSInteger index){
                _index = index;
                if (_didclickedBtn) {
                    _didclickedBtn(_index);
                }
            };
       }else{
           //如果已经登陆
           AW_SimilaryCommodityModal * tmpModal = weakSelf.dataArr[index];
           if (tmpModal.commidityModal.isCollected == YES) {
               //在这请求取消收藏艺术品
               NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
               NSString * IdString = [userDefault objectForKey:@"user_id"];
               NSLog(@"用户id==%@==",IdString);
               NSLog(@"艺术品id==%@==",tmpModal.commidityModal.commodity_Id);
               NSError * error = nil;
               NSDictionary * dict = @{
                                       @"userId":IdString,
                                       @"id":tmpModal.commidityModal.commodity_Id,
                                       };
               NSData * Data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
               NSString * string = [[NSString alloc]initWithData:Data encoding:NSUTF8StringEncoding];
               NSDictionary * cancleDict = @{@"param":@"cancelCollectionCommodity",@"jsonParam":string};
               AFHTTPSessionManager * httpManager = [AFHTTPSessionManager manager];
               [httpManager POST:ARTSCOME_INT parameters:cancleDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                   NSLog(@"%@",responseObject);
                   NSLog(@"%@",responseObject[@"message"]);
                   if ([responseObject[@"code"]intValue] == 0) {
                       //请求成功后改变图片颜色
                       weakCell.praiseImageView.image = [UIImage imageNamed:@"赞-空"];
                       [weakCell.storeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                       tmpModal.commidityModal.isCollected = NO;
                   }
               } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                   NSLog(@"错误信息：%@",[error localizedDescription]);
               }];
           }else if (tmpModal.commidityModal.isCollected == NO){
               //在这请求收藏艺术品
               NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
               NSString * IdString = [userDefault objectForKey:@"user_id"];
               NSError * error = nil;
               NSDictionary * dict = @{
                                       @"userId":IdString,
                                       @"id":tmpModal.commidityModal.commodity_Id,
                                       };
               NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
               NSString * collectionString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
               NSDictionary * collectionDict = @{@"param":@"collectionCommodity",@"jsonParam":collectionString};
               AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
               NSLog(@"用户id:==%@==",IdString);
               NSLog(@"艺术品id==%@==",tmpModal.commidityModal.commodity_Id);
               [manager POST:ARTSCOME_INT parameters:collectionDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                   NSLog(@"%@",responseObject);
                   if ([responseObject[@"code"]intValue] == 0) {
                       //请求成功后改变图片颜色
                       weakCell.praiseImageView.image = [UIImage imageNamed:@"赞1"];
                       [weakCell.storeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                       tmpModal.commidityModal.isCollected = YES;
                   }
               } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                   NSLog(@"错误信息：%@",[error localizedDescription]);
               }];   
           }
        }
    };
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout Menthod

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    AW_SimilaryCommodityModal * art = self.dataArr[indexPath.item];
    return art.size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//左右cell的最小间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

//上下cell的最小间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}


#pragma mark - UICollectionViewHead Menthod

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == WaterFallSectionHeader) {
        UICollectionReusableView * reusableView = nil;
        UICollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"ActiveHeadView" forIndexPath:indexPath];
        
        AW_ActiveHeadView * showHeader =(AW_ActiveHeadView*)[headView viewWithTag:1];
        if (!showHeader) {
            showHeader = BundleToObj(@"AW_ActiveHeadView");
            showHeader.frame = Rect(0, 0, kSCREEN_WIDTH, 110);
            showHeader.tag = 1;
#warning 在这添加collectionView头视图信息
            [headView addSubview:showHeader];
        }
        [showHeader.topImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.activeImageURL] forState:UIControlStateNormal];
        reusableView = headView;
        return reusableView;
    }else{
        return nil;
    }
    return nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    return 110;
}

#pragma mark - UICollectionViewDelegate Menthod

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    // 已选中某个列表对象后的回调
    if (_didSelectObjectBlock){
        if (self.dataArr.count > 0) {
            _didSelectObjectBlock(indexPath.item,self.dataArr[indexPath.item]);
        }
    }
    //点击艺术品cell的回调
    AW_SimilaryCommodityModal * modal = self.dataArr[indexPath.item];
    self.modal = modal;
    if (_didClickedIterm) {
        _didClickedIterm(modal);
    }
}

@end
