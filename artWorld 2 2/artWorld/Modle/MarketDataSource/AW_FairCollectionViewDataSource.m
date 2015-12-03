//
//  AW_FairCollectionViewDataSource.m
//  artWorld
//
//  Created by 张亚哲 on 15/7/9.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//
#import "AW_FairCollectionViewDataSource.h"
#import "SVProgressHUD.h"
#import "AW_MarketModal.h"//市集modal
#import "IMB_AlertView.h" //测试
#import "WaterFLayout.h" //瀑布流
#import "UIImageView+WebCache.h"
#import "AW_DeleteAlertMessage.h"
#import "DeliveryAlertView.h"
#import "AFNetworking.h"
#import "AW_Constants.h"

@interface AW_FairCollectionViewDataSource()

/**
 *  @author cao, 15-10-23 10:10:37
 *
 *  上部轮播图数组
 */
@property(nonatomic,strong)NSMutableArray * topArray;
/**
 *  @author cao, 15-10-23 10:10:54
 *
 *  热门分类数组
 */
@property(nonatomic,strong)NSMutableArray * hotArray;

@end

@implementation AW_FairCollectionViewDataSource

@synthesize isNotFirstLoading = _isNotFirstLoading;
@synthesize isLoadingData = _isLoadingData;
@synthesize hasLoadMoreFooter = _hasLoadMoreFooter;
@synthesize hasRefreshHeader = _hasRefreshHeader;

#pragma mark - Private Menthod

-(AW_MarketModal*)modal{
    if (!_modal) {
        _modal = [[AW_MarketModal alloc]init];
    }
    return _modal;
}

-(NSMutableArray*)topArray{
    if (!_topArray) {
        _topArray = [[NSMutableArray alloc]init];
    }
    return _topArray;
}

-(NSMutableArray*)hotArray{
    if (!_hotArray) {
        _hotArray = [[NSMutableArray alloc]init];
    }
    return _hotArray;
}

#pragma mark SizeForCell Method

-(AW_ProduceCollectionCell *)SizeCell{
    if (!_SizeCell) {
        _SizeCell = BundleToObj(@"AW_ProduceCollectionCell");
    }
    return _SizeCell;
}

#pragma mark - Life Cycle method

/**
 *  初始化
 *
 *  @param didSelectObjectBlock 选中对象块
 *
 *  @return 数据源对象
 */
- (id)initWithDidSelectObjectBlock:(DidSelectObjectBlock)didSelectObjectBlock{
    if (self = [super init]) {
        if (!_didSelectObjectBlock) {
            _didSelectObjectBlock = didSelectObjectBlock;
        }
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

// 设置有刷新头
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

// 刷新数据
- (void)refreshData{
    
        if (self.dataArr.count > 0) {
            [self.dataArr removeAllObjects];
        }
        if (self.topArray.count > 0) {
            [self.topArray removeAllObjects];
        }
        if (self.hotArray.count > 0) {
            [self.hotArray removeAllObjects];
        }
        self.currentPage = @"1";
        [self performSelector:@selector(GetCarouselAndClassModal) withObject:nil afterDelay:1];
        [self performSelector:@selector(getTestData) withObject:nil afterDelay:1];
}

/**
 *  @author cao, 15-10-23 13:10:23
 *
 *  获得轮播图数据和热门分类数据
 */
-(void)GetCarouselAndClassModal{
    __weak typeof(self) weakSelf = self;
    //判断用户的登录状态
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [defaults objectForKey:@"user_id"];
    NSLog(@"user_id:===%@===",user_id);
    if (user_id) {
        //如果是登录状态(传user_id)******(请求轮播图和热门分类只要请求第一页进行)*****
        NSDictionary * dict = @{
                                @"userId":user_id,
                                @"pageSize":@"10",
                                @"pageNumber":@"1",
                                };
        NSError * error = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary * markrt = @{@"param":@"getHomePage",@"jsonParam":string};
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:markrt success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"%d",[responseObject[@"code"]intValue]);
            if ([responseObject[@"code"]intValue] == 0) {
                //为轮播图赋值
                NSLog(@"%@",[responseObject[@"info"]valueForKey:@"topPictures"]);
                [[responseObject[@"info"]valueForKey:@"topPictures"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary * dict = obj;
                    AW_MarketModal * modal = [[AW_MarketModal alloc]init];
                    AW_CarouselModal * carouselModal = [[AW_CarouselModal alloc]init];
                    modal.carouselModal = carouselModal;
                    carouselModal.artwork_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
                    carouselModal.artwork_clearImage = [NSString stringWithFormat:@"%@",dict[@"img"]];
                    carouselModal.artwork_fuzzyImage = [NSString stringWithFormat:@"%@",dict[@"url"]];
                    [weakSelf.topArray addObject:modal];
                }];
               //为热门分类赋值
                NSLog(@"%@",[responseObject[@"info"] valueForKey:@"hotClass"]);
               [[responseObject[@"info"] valueForKey:@"hotClass"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   NSDictionary * hotDict = obj;
                   AW_MarketModal * modal = [[AW_MarketModal alloc]init];
                   AW_HotClassModal * hotModal = [[AW_HotClassModal alloc]init];
                   modal.hotClassModal = hotModal;
                   hotModal.class_id = [NSString stringWithFormat:@"%@",hotDict[@"id"]];
                   hotModal.class_image = [NSString stringWithFormat:@"%@",hotDict[@"img"]];
                   hotModal.class_name = [NSString stringWithFormat:@"%@",hotDict[@"name"]];
                   [weakSelf.hotArray addObject:modal];
               }];
                [self.collectionView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@",[error localizedDescription]);
        }];
    }else{
        NSDictionary * dict = @{
                                @"pageSize":@"10",
                                @"pageNumber":@"1",
                                };
        NSError * error = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary * topDict = @{@"param":@"getHomePage",@"jsonParam":string};
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager POST:ARTSCOME_INT parameters:topDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
             NSLog(@"%@",[responseObject[@"info"]valueForKey:@"topPictures"]);
            NSLog(@"%@",responseObject);
            if ([responseObject[@"code"]intValue] == 0) {
                //为轮播图赋值
                [[responseObject[@"info"]valueForKey:@"topPictures"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary * dict = obj;
                    AW_MarketModal * modal = [[AW_MarketModal alloc]init];
                    AW_CarouselModal * carouselModal = [[AW_CarouselModal alloc]init];
                    modal.carouselModal = carouselModal;
                    carouselModal.artwork_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
                    carouselModal.artwork_clearImage = [NSString stringWithFormat:@"%@",dict[@"img"]];
                    carouselModal.artwork_fuzzyImage = [NSString stringWithFormat:@"%@",dict[@"url"]];
                    [weakSelf.topArray addObject:modal];
                }];
                //为热门分类赋值
                NSLog(@"%@",[responseObject[@"info"] valueForKey:@"hotClass"]);
                [[responseObject[@"info"] valueForKey:@"hotClass"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary * hotDict = obj;
                    AW_MarketModal * modal = [[AW_MarketModal alloc]init];
                    AW_HotClassModal * hotModal = [[AW_HotClassModal alloc]init];
                    modal.hotClassModal = hotModal;
                    hotModal.class_id = [NSString stringWithFormat:@"%@",hotDict[@"id"]];
                    hotModal.class_image = [NSString stringWithFormat:@"%@",hotDict[@"img"]];
                    hotModal.class_name = [NSString stringWithFormat:@"%@",hotDict[@"name"]];
                    [weakSelf.hotArray addObject:modal];
                }];
                [self.collectionView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"错误信息:==%@==",[error localizedDescription]);
        }];
    }
}

-(void)getTestData{
    __weak typeof(self) weakSelf = self;
        //判断用户的登录状态
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * user_id = [defaults objectForKey:@"user_id"];
        NSLog(@"user_id:===%@===",user_id);
        if (user_id) {
            //如果是登录状态(传user_id)
            NSDictionary * dict = @{
                                    @"userId":user_id,
                                    @"pageSize":@"10",
                                    @"pageNumber":self.currentPage,
                                    };
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * markrt = @{@"param":@"getHomePage",@"jsonParam":string};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:markrt success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]integerValue] == 0) {
                    //将页码总数记录下来
                    if ([self.currentPage intValue] == 1) {
                        NSString * totalNum = [responseObject[@"info"] valueForKey:@"totalNumber"];
                        weakSelf.totolPage = [NSString stringWithFormat:@"%d",[totalNum intValue] - 2];
                        NSLog(@"%@",[responseObject[@"info"] valueForKey:@"totalNumber"]);
                    }
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
                        NSLog(@"%@",modal.commidityModal.commodity_Name);
                        [weakSelf.dataArr addObject:modal];
                    }];
                    //判断是否显示下拉刷新
                    if (([weakSelf.currentPage intValue]*10 < [weakSelf.totolPage intValue]) && [weakSelf.totolPage intValue] > 10){
                        _collectionView.footerHidden = NO;
                    }else{
                        _collectionView.footerHidden = YES;
                    }
                    [self dataDidLoad];
                }
            }failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error){
                NSLog(@"错误信息:%@",[error localizedDescription]);
            }];
        }else{
            //如果是非登录状态(不传user_id)
            NSDictionary * dict = @{
                                    @"pageSize":@"10",
                                    @"pageNumber":self.currentPage,
                                    };
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * markrt = @{@"param":@"getHomePage",@"jsonParam":string};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:markrt success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"] intValue] == 0) {
                    //对modal进行赋值
                    //将页码总数记录下来
                    if ([self.currentPage intValue] == 1) {
                        NSString * totalNum = [responseObject[@"info"] valueForKey:@"totalNumber"];
                        weakSelf.totolPage = [NSString stringWithFormat:@"%d",[totalNum intValue] - 2];
                        NSLog(@"%@",[responseObject[@"info"] valueForKey:@"totalNumber"]);
                    }
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
                        NSLog(@"%@",modal.commidityModal.commodity_Name);
                        [weakSelf.dataArr addObject:modal];
                    }];
                    NSLog(@"当前页数%@",self.currentPage);
                    NSLog(@"总页数：%@",self.totolPage);
                    //判断是否显示下拉刷新
                    if (([weakSelf.currentPage intValue]*10 < [weakSelf.totolPage intValue]) && [weakSelf.totolPage intValue] > 10) {
                        _collectionView.footerHidden = NO;
                    }else{
                        _collectionView.footerHidden = YES;
                    }
                    [self dataDidLoad];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息:%@",[error localizedDescription]);
            }];
    }
}
/**
 *  @author zhe, 15-07-10 11:07:07
 *
 *  计算collectionview的每个item大小
 *
 *  @param art 艺术品信息
 *
 *  @return 每个item大小
 */
-(CGSize)sizeOfArtCellWith:(AW_MarketModal *)art{
    //计算图片高度
    float imageHeight;
    if (art.commidityModal.clearImageURL) {
         imageHeight = ((kSCREEN_WIDTH - 30)/ 2) / art.commidityModal.commidity_width  * art.commidityModal.commidity_height;
        art.commidityModal.commidity_height = imageHeight;
    }else{
        imageHeight = ((kSCREEN_WIDTH - 30)/ 2);
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
    NSLog(@"%f",LabelSize.height);
    return size;
}

// 加载下一页数据
- (void)nextPageData{
  
    NSLog(@"当前的页数:%@",self.currentPage);
    NSLog(@"艺术品总个数：%@",self.totolPage);
    if ([self.totolPage intValue] > 10 && ([self.currentPage intValue]*10 < [self.totolPage intValue])){
        //只有页数大于1时才进行上提分页(将当前页码加上1)
        self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] + 1];
        [self performSelector:@selector(getTestData) withObject:nil afterDelay:1];
    }
}

// 释放资源
- (void)releaseResources{
    self.collectionView = nil;
    _didSelectObjectBlock = nil;
    [_dataArr removeAllObjects];
    _dataArr = nil;
}

#pragma mark Collection Delegate Method

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AW_ProduceCollectionCell * cell;
    static NSString *cellId = @"MarketCell";
    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (self.dataArr.count > 0) {
        AW_MarketModal * art = self.dataArr[indexPath.item];
        //获取cell的索引
        cell.index = indexPath.item;
        cell.describeLabel.text = [NSString stringWithFormat:@"%@",art.commidityModal.commodity_Name];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",art.commidityModal.commodityPrice.floatValue];
        NSLog(@"%@",art.commidityModal.clearImageURL);
        
        //判断网络状态和是否开启了省流量模式
        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
        if ([[user objectForKey:@"patternState"]isEqualToString:@"yes"]&&[[user objectForKey:@"NetState"]isEqualToString:@"切换到WWAN网络"]) {
            [cell.artImage sd_setImageWithURL:[NSURL URLWithString:art.commidityModal.fuzzyImageURL] placeholderImage:PLACE_HOLDERIMAGE];
        }else{
            [cell.artImage sd_setImageWithURL:[NSURL URLWithString:art.commidityModal.clearImageURL] placeholderImage:PLACE_HOLDERIMAGE];
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
        //判断用户是否已经登陆(如果没有登陆就跳转到登陆界面)
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSString * nameString = [userDefault objectForKey:@"name"];
        if (!nameString) {
            //如果没有登陆走这个方法
            DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
            AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:self options:nil][1];
            contentView.bounds = Rect(0, 0, 272, 130);
            alertView.contentView = contentView;
            [alertView showWithoutAnimation];
            //点击确定或取消按钮的回调(弹出视图)
            contentView.didClickedBtn = ^(NSInteger index){
                _index = index;
                if (_didClickedConfirmBtn) {
                    _didClickedConfirmBtn(_index);
                }
            };
        }else{
            //如果已经登陆
            AW_MarketModal * tmpModal = weakSelf.dataArr[index];
            if (tmpModal.commidityModal.isCollected == NO) {
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

            }else if (tmpModal.commidityModal.isCollected == YES){
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
            }
        }
    };
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AW_MarketModal *artifact = self.dataArr[indexPath.item];
    return artifact.size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(10, 10, 10,10);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    self.modal = self.dataArr[indexPath.row];
    if (_didClickedCell) {
        _didClickedCell(self.modal);
    }

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark UICollectionView Header

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == WaterFallSectionHeader){
        //获取轮播图数据和热门分类数据
   // [self performSelector:@selector(GetCarouselAndClassModal) withObject:nil afterDelay:0];
        
        UICollectionReusableView *reusableHeaderView = nil;
        UICollectionReusableView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        AW_FairHeaderView *showHeader = (AW_FairHeaderView*)[headerview viewWithTag:1];
        if (!showHeader) {
            showHeader = BundleToObj(@"AW_FairHeaderView");
            showHeader.frame = Rect(0, 0, kSCREEN_WIDTH, 300);
            showHeader.tag = 1;
            [headerview addSubview:showHeader];
        }
        //为轮播图数据赋值
        if (![self.topArray isKindOfClass:[NSNull class]]) {
            if (self.topArray.count > 0) {
                [showHeader setAdImageArr:self.topArray];
            }
        }
        
        //为热门分类赋值
        NSLog(@"%ld",self.hotArray.count);
        if (![self.hotArray isKindOfClass:[NSNull class]]) {
            if (self.hotArray.count > 0) {
                [showHeader setKindArr:self.hotArray];
            }
        }
 
        // 点击轮播头视图回调
        showHeader.didSelectFair = ^(NSInteger index) {
            AW_MarketModal * modal = self.topArray[index];
            _art_URL = modal.carouselModal.artwork_fuzzyImage;
            if (_didSelectFairView) {
                _didSelectFairView(_art_URL);
            }
        };
        // 点击热门分类回调
        showHeader.didSelect = ^(NSInteger idx){
            AW_MarketModal * modal = self.hotArray[idx];
            _class_id = modal.hotClassModal.class_id;
            if (_didSelectKind) {
                _didSelectKind(_class_id);
            }
        };
        // 设置市集头视图颜色
        showHeader.backgroundColor = HexRGB(0XF2F2F2);
        reusableHeaderView = headerview;
        return reusableHeaderView;
    }else{
        return nil;
    }
}


// 定义headview的size
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    if (self.whetherNeedHeaderView == YES) {
        return 289;
    } else {
        return 0;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kSCREEN_WIDTH, 300);
}

@end
