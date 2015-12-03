//
//  AW_PaymentSucessDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_PaymentSucessDataSource.h"
#import "AW_MarketModal.h"//模型类
#import "AW_ProduceCollectionCell.h"//cell类
#import "WaterFLayout.h"
#import "AW_PaymentSucessHeadView.h" //支付成功头视图
#import "IMB_AlertView.h"
#import "SVProgressHUD.h"
#import "AW_ConnectStoreView.h" //联系卖家弹出视图
#import "DeliveryAlertView.h"
#import "UIImageView+WebCache.h"
#import "AW_DeleteAlertMessage.h"
#import "AFNetworking.h"
#import "AW_CommodityModal.h"
#import "AW_Constants.h"

@interface AW_PaymentSucessDataSource()<UICollectionViewDelegateFlowLayout>
/**
 *  @author cao, 15-11-11 15:11:02
 *
 *  用来计算高度的cell
 */
@property(nonatomic,strong)AW_ProduceCollectionCell * SizeCell;

@end

@implementation AW_PaymentSucessDataSource

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

-(NSMutableArray*)storeModalArray{
    if (!_storeModalArray) {
        _storeModalArray = [[NSMutableArray alloc]init];
    }
    return _storeModalArray;
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
    self.currentPage = @"1";
    if (self.dataArr.count > 0) {
         [self.dataArr removeAllObjects];
    }
    [self performSelector:@selector(getTestData) withObject:nil afterDelay:1];
}

-(void)getTestData{
    __weak typeof(self) weakSelf = self;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{
                            @"userId":user_id,
                            @"pageSize":@"10",
                            @"pageNumber":self.currentPage,
                            @"keyword":@"",
                            @"classId":@"",
                            @"location":@"",
                            @"sort":@"",
                            };
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * searchDict = @{@"param":@"getCommodityList",@"jsonParam":string};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:searchDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"message"]);
        if ([responseObject[@"code"] intValue] == 0) {
            //对modal进行赋值
            //将页码总数记录下来
            weakSelf.totolPage = [responseObject[@"info"] valueForKey:@"totalNumber"];
            //请求成功就在这赋值
            NSArray * artArray = [responseObject[@"info"] valueForKey:@"data"];
            NSLog(@"%@",artArray);
            [artArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
                NSDictionary * artDict = obj;
                AW_MarketModal * modal = [[AW_MarketModal alloc]init];
                AW_CommodityModal * artModal = [[AW_CommodityModal alloc]init];
                modal.commidityModal = artModal;
                //在这判断是否有图片(没有图片就展示占位图片)
                if (![artDict[@"clear_img"]isEqualToString:@""]) {
                    artModal.clearImageURL = artDict[@"clear_img"];
                    artModal.fuzzyImageURL = artDict[@"fuzzy_img"];
                    artModal.commidity_height = [artDict[@"height"]intValue];
                    artModal.commidity_width = [artDict[@"width"]intValue];
                }
                artModal.commodity_Id = artDict[@"id"];
                artModal.commodity_Name = artDict[@"name"];
                artModal.commodityPrice = artDict[@"price"];
                artModal.isCollected = [artDict[@"isCollected"]boolValue];
                modal.size = [self sizeOfArtCellWith:modal];
                [weakSelf.dataArr addObject:modal];
            }];
            //判断是否显示下拉刷新
            if (([weakSelf.currentPage intValue]*10 < [weakSelf.totolPage intValue]) && [weakSelf.totolPage intValue] > 10) {
                _collectionView.footerHidden = NO;
            }else{
                _collectionView.footerHidden = YES;
            }
            [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
}

-(CGSize)sizeOfArtCellWith:(AW_MarketModal *)art{
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
//    NSMutableParagraphStyle * paragrafStyle = [[NSMutableParagraphStyle alloc]init];
//    paragrafStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    self.SizeCell.describeLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.SizeCell.describeLabel.numberOfLines = 0;
    NSDictionary * fontAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    //使用字体大小来计算每一行的高度，每一行片段的起点，而不是base line的起点
    CGSize LabelSize = [art.commidityModal.commodity_Name boundingRectWithSize:CGSizeMake(((kSCREEN_WIDTH - 30)/ 2) - 16, CGFLOAT_MAX) options:
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading attributes:fontAttributes context:nil].size;
    [self.SizeCell.describeLabel sizeToFit];
    [self.SizeCell layoutIfNeeded];
    [self.SizeCell.contentView layoutIfNeeded];
    CGSize size = CGSizeMake((kSCREEN_WIDTH - 30)/2, imageHeight + LabelSize.height + 36 +8);
    return size;
}

// 加载下一页数据
- (void)nextPageData{
    
    NSLog(@"当前的页数:%@",self.currentPage);
    if ([self.totolPage intValue] > 10 && ([self.currentPage intValue]*10 < [self.totolPage intValue])){
        //只有页数大于1时才进行上提分页(将当前页码加上1)
        self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] + 1];
        [self performSelector:@selector(getTestData) withObject:nil afterDelay:1];
    }
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
    static NSString * CellIdentifier = @"paymentSucessCell";
    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.dataArr.count!=0) {
        AW_MarketModal * art = self.dataArr[indexPath.item];
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
        NSLog(@"%ld",index);
        //如果已经登陆
        AW_MarketModal * tmpModal = weakSelf.dataArr[index];
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
                    tmpModal.commidityModal.isCollected = NO;                }
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
    };
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout Menthod

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    AW_MarketModal * art = self.dataArr[indexPath.item];
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
#pragma mark - UICollectionViewDelegate Menthod

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    // 已选中某个列表对象后的回调
    if (_didSelectObjectBlock) {
        if (self.dataArr.count > 0) {
            _didSelectObjectBlock(indexPath.item,self.dataArr[indexPath.item]);
        }
    }
    AW_MarketModal * modal = self.dataArr[indexPath.item];
    self.modal = modal;
    if (_didClickedCell) {
        _didClickedCell(_modal);
    }
    
}

#pragma mark - UICollectionViewHead Menthod

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == WaterFallSectionHeader) {
        UICollectionReusableView * reusableView = nil;
        UICollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"paymentSucessHeadView" forIndexPath:indexPath];
        
        AW_PaymentSucessHeadView * showHeader =(AW_PaymentSucessHeadView*)[headView viewWithTag:1];
        if (!showHeader) {
            showHeader = BundleToObj(@"AW_PaymentSucessHeadView");
            showHeader.frame = Rect(0, 0, kSCREEN_WIDTH, 280);
            showHeader.tag = 1;
#warning 在这添加collectionView头视图信息
            [headView addSubview:showHeader];
        }
        //将确认订单界面传过来的收货地址赋值给collectionView头视图
        NSLog(@"%@",self.currentAdressModal.deliveryName);
        showHeader.deliveryName.text = self.currentAdressModal.deliveryName;
        showHeader.deliveryPhone.text = self.currentAdressModal.deliveryPhoneNumber;
        showHeader.deliveryAdress.text = self.currentAdressModal.deliveryAdress;
        showHeader.PostagePrice.text = [NSString stringWithFormat:@"￥%.2f",self.postagePrice.floatValue];
        showHeader.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice.floatValue];
        //点击联系卖家按钮的回调
        showHeader.didClickedConectBtn = ^(NSString * string){
            DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
            AW_ConnectStoreView * contentView = BundleToObj(@"AW_ConnectStoreView");
            contentView.bounds = Rect(0, 0, 280, 215);
            alertView.contentView = contentView;
            //将商铺modal传过去
            contentView.storeNameArray = [self.storeModalArray copy];
            [alertView show];
            //点击cell单元格的回调
            contentView.didClickedCell = ^(AW_MyShopCartModal *storeModal){
                NSLog(@"%@",storeModal.storeModal.shop_Name);
                if (_didClickedStoreCell) {
                    _didClickedStoreCell(storeModal);
                }
            };
        };
        reusableView = headView;
        return reusableView;
    }else{
        return nil;
    }
    return nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    return 280;
}

@end
