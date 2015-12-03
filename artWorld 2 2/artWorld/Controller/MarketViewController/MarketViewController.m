//
//  MarketViewController.m
//  artWorld
//
//  Created by a on 15/8/8.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "MarketViewController.h"
#import "WaterFLayout.h" //瀑布流
#import "AW_ProduceCollectionCell.h"//collectionViewCell
#import "AW_FairCollectionViewDataSource.h" //数据源
#import "AW_Constants.h"
#import "UIImage+IMB.h"
#import "AW_MyShopCarViewController.h"
#import "DeliveryAlertView.h"
#import "AW_DeleteAlertMessage.h"
#import "AW_LoginInViewController.h"//登陆界面
#import "AW_ArtDetailController.h"//艺术品详情
#import "AFNetworking.h"
#import "AW_BigClassModal.h"
#import "AW_SmallClassModal.h"
#import "AW_ClassContainerView.h"//分类列表容器视图
#import "AW_BigClassCell.h"
#import "AW_SmallClassCell.h"
#import "UIImageView+WebCache.h"
#import "AW_SearchReaultController.h"//搜索结果控制器
#import "AW_KeyWordSearchController.h"//搜索关键字控制器
#import "AW_CarouselDetailController.h"//轮播图详情控制器

@interface MarketViewController () <UITableViewDataSource,UITableViewDelegate>

// 市集主界面视图
@property (strong, nonatomic) UICollectionView *mainCollectionView;

// 市集主界面数据源
@property (nonatomic,strong)AW_FairCollectionViewDataSource *dataSource;

/**
 *  @author cao, 15-10-26 16:10:26
 *
 *  大分类数组
 */
@property(nonatomic,strong)NSMutableArray * bigClassArray;
/**
 *  @author cao, 15-10-26 16:10:30
 *
 *  小分类数组
 */
@property(nonatomic,strong)NSMutableArray * smallClassArray;
/**
 *  @author cao, 15-10-26 17:10:54
 *
 *  容器视图
 */
@property(nonatomic,strong)AW_ClassContainerView * containerView;
/**
 *  @author cao, 15-10-26 17:10:33
 *
 *  背景视图
 */
@property(nonatomic,strong)UIView * backgroundView;
/**
 *  @author cao, 15-10-26 17:10:30
 *
 *  大分类列表
 */
@property(nonatomic,strong)UITableView * bigClassTable;
/**
 *  @author cao, 15-10-26 17:10:33
 *
 *  小分类列表
 */
@property(nonatomic,strong)UITableView * smallClassTable;
/**
 *  @author cao, 15-10-26 18:10:41
 *
 *  图标数组
 */
@property(nonatomic,strong)NSArray * iconArray;
/**
 *  @author cao, 15-10-26 21:10:38
 *
 *  左侧按钮
 */
@property(nonatomic,strong)UIBarButtonItem *leftButton;
/**
 *  @author cao, 15-10-26 21:10:46
 *
 *  搜索按钮
 */
@property(nonatomic,strong)UIBarButtonItem * searchBtn;
/**
 *  @author cao, 15-10-26 21:10:55
 *
 *  商店按钮
 */
@property(nonatomic,strong)UIBarButtonItem * shopBtn;
/**
 *  @author cao, 15-11-13 14:11:12
 *
 *  不需要进行请求的分类
 */
@property(nonatomic,strong)NSArray * tmpArray;

@end

@implementation MarketViewController

-(NSArray*)tmpArray{
    if (!_tmpArray) {
        _tmpArray = @[
                      @{@"收礼人":@[@"民间特色",@"送师长",@"送爱人",@"送朋友",@"商务礼物",@"小礼品",@"送小孩",@"纯手工",]},
                      ];
    }
    return _tmpArray;
}

-(UIView*)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.alpha = 0.4;
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.hidden = YES;
    }
    return _backgroundView;
}

-(UITableView*)bigClassTable{
    if (!_bigClassTable) {
        _bigClassTable = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH/2 - 20, 270)];
        _bigClassTable.delegate = self;
        _bigClassTable.dataSource = self;
        _bigClassTable.tableFooterView = [[UIView alloc]init];
    }
    return _bigClassTable;
}

-(UITableView*)smallClassTable{
    if (!_smallClassTable) {
        _smallClassTable = [[UITableView alloc]initWithFrame:Rect(kSCREEN_WIDTH/2 - 20, 0, kSCREEN_WIDTH/2 + 20, 270)];
        _smallClassTable.delegate = self;
        _smallClassTable.dataSource = self;
        _smallClassTable.tableFooterView = [[UIView alloc]init];
    }
    return _smallClassTable;
}

-(NSMutableArray*)bigClassArray{
    if (!_bigClassArray) {
        _bigClassArray = [[NSMutableArray alloc]init];
    }
    return _bigClassArray;
}

-(NSMutableArray*)smallClassArray{
    if (!_smallClassArray) {
        _smallClassArray = [[NSMutableArray alloc]init];
    }
    return _smallClassArray;
}

-(AW_ClassContainerView*)containerView{
    if (!_containerView) {
        _containerView = BundleToObj(@"AW_ClassContainerView");
    }
    return _containerView;
}

-(NSArray*)iconArray{
    if (!_iconArray) {
        _iconArray = @[@"市集-分类-分类图标",@"市集-分类-材料图标",@"市集-分类-用途图标",@"市集-分类-品牌图标",@"市集-分类-特色图标",@"市集-分类-节日图标",@"市集-分类-材料图标",@"市集-分类-用途图标",@"市集-分类-品牌图标",@"市集-分类-特色图标",@"市集-分类-节日图标",@"市集-分类-材料图标",@"市集-分类-用途图标",@"市集-分类-品牌图标",@"市集-分类-特色图标",@"市集-分类-节日图标"];
    }
    return _iconArray;
}

#pragma mark - Property Method

// 加载数据源
-(AW_FairCollectionViewDataSource *)dataSource{
    if (!_dataSource) {
        _dataSource = [[AW_FairCollectionViewDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            NSLog(@"----->>>>>>>%ld",index);
        }];
        _dataSource.whetherNeedHeaderView = YES;
        
        // 点击轮播头视图回调
        __weak typeof(self) weakSelf = self;
        _dataSource.didSelectFairView = ^(NSString *art_URL){
            NSLog(@"轮播视图id：%@",art_URL);
            AW_CarouselDetailController * controller = [[AW_CarouselDetailController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.URLString = art_URL;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        };
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.leftButton.enabled = YES;
    self.searchBtn.enabled = YES;
    self.shopBtn.enabled = YES;
}

- (void)viewDidLoad {
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    [self configCollectionView];
    [self navItem];
    [self configBackGroundView];
    [self configTableView];
    self.navigationController.navigationBar.translucent = NO;
    //初始化开始加载的页码
    self.dataSource.currentPage = @"1";
    //点击艺术品cell的回调
    __weak typeof(self) weakSelf = self;
    self.dataSource.didClickedCell = ^(AW_MarketModal * modal){
        NSLog(@"%d",[NSThread isMainThread]);
        NSLog(@"艺术品id==%@==", modal.commidityModal.commodity_Id);
        ;
        AW_ArtDetailController * detailController = [[AW_ArtDetailController alloc]init];
        detailController.hidesBottomBarWhenPushed = YES;
        //将艺术品id传到下个界面
        detailController.detailDataSource.commidity_id = modal.commidityModal.commodity_Id;
        detailController.detailDataSource.isCollection = modal.commidityModal.isCollected;
        [weakSelf.navigationController pushViewController:detailController animated:YES];
        detailController = nil;
    };
}

// 设置主界面-市集界面布局
-(void)configCollectionView{
    WaterFLayout *layout = [[WaterFLayout alloc]init];
    layout.headerHeight = 289;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,  0, kSCREEN_WIDTH, kSCREEN_HEIGHT -  KTAB_BAR_HEIGHT - kNAV_BAR_HEIGHT) collectionViewLayout:layout];
    _mainCollectionView.backgroundColor = [UIColor clearColor];
    _mainCollectionView.userInteractionEnabled = YES;
    _mainCollectionView.alwaysBounceVertical = YES;
    
    /**
     *  @author zhe, 15-07-10 14:07:49
     *
     *  注册UICollectionViewCell
     */
    UINib *cellNib = [UINib nibWithNibName:@"AW_ProduceCollectionCell" bundle:nil];
    [_mainCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"MarketCell"];
    
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"HeaderView"];
    
    _mainCollectionView.dataSource = self.dataSource;
    _mainCollectionView.delegate = self.dataSource;
    
    _mainCollectionView.backgroundColor = HexRGB(0XF2F2F2);
    
    self.dataSource.collectionView = _mainCollectionView;
    
    self.dataSource.hasRefreshHeader = YES;
    self.dataSource.hasLoadMoreFooter = YES;
    [self.view addSubview:_mainCollectionView];
    // 点击热门分类视图回调
    __weak typeof(self)weakSelf = self;
    self.dataSource.didSelectKind = ^(NSString * class_id){
        NSLog(@"小分类id==%@===",class_id);
        AW_SearchReaultController * searchController = [[AW_SearchReaultController alloc]init];
        searchController.hidesBottomBarWhenPushed = YES;
        //将小分类id传到搜索结果控制器
        searchController.searchDataSource.class_id = class_id;
        [weakSelf.navigationController pushViewController:searchController animated:YES];
    };
    //点击弹出视图（是否跳转到登陆界面）
    self.dataSource.didClickedConfirmBtn = ^(NSInteger index){
        if (index == 1) {
            AW_LoginInViewController * loginController = [[AW_LoginInViewController alloc]init];
            loginController.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:loginController animated:YES];
        }else if (index == 2){
            NSLog(@"点击了取消按钮。。。。");
        }
    };
}

// 添加navItem并设置图片为原色
- (void)navItem {
    self.leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"全部分类图标"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:self action:@selector(classifyBtnClick)];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    
    self.searchBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"搜索"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:self action:@selector(searchBtnClick)];//[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.shopBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"购物车"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:self action:@selector(shopCartBtnClick)];
    
    // 设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x88c244);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    //隐藏NavBar下边线
    [self.navigationController.navigationBar setShadowImage:shadowImage];
    self.navigationItem.rightBarButtonItems = @[self.shopBtn,self.searchBtn];
}

#pragma mark - ConfigView Method

-(void)configBackGroundView{
    [self.view addSubview:self.backgroundView];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
   [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTrailing
      relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)configTableView {
    //添加容器视图
    [self.view addSubview:self.containerView];
    //点击收起按钮的回调
    __weak typeof(self) weakSelf = self;
    self.containerView.didClickedButton = ^(){
       [UIView animateWithDuration:0.3 animations:^{
          weakSelf.backgroundView.alpha = 0;
           weakSelf.containerView.frame = Rect(0, -300, kSCREEN_WIDTH, 300);
       } completion:^(BOOL finished) {
           weakSelf.backgroundView.hidden = YES;
       }];
        weakSelf.leftButton.enabled = YES;
        weakSelf.shopBtn.enabled = YES;
        weakSelf.searchBtn.enabled = YES;
    };
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-300]];
      [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
      [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
       [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300]];
    //添加大小分类列表视图
    [self.containerView addSubview:self.bigClassTable];
    [self.containerView addSubview:self.smallClassTable];
}

#pragma mark - BtnClick Method

- (void)classifyBtnClick {
    //动画效果显示
        self.backgroundView.hidden = NO;
        self.backgroundView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundView.alpha = 0.4;
            self.containerView.frame = Rect(0, 0, kSCREEN_WIDTH, 300);
        }];
    self.leftButton.enabled = NO;
    self.shopBtn.enabled = NO;
    self.searchBtn.enabled = NO;
    //在这进行请求(大分类)
    NSDictionary * dict = @{};
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * bigClass = @{@"param":@"getBigType",@"jsonParam":string};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:bigClass success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"响应信息:===%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
            //先将大分类数组的数据清空
            if (self.bigClassArray.count > 0) {
                [self.bigClassArray removeAllObjects];
            }
            //为大分类modal赋值
            AW_BigClassModal * modal = [[AW_BigClassModal alloc]init];
            modal.big_name = @"全部分类";
            modal.tmpImage = self.iconArray[0];
            [self.bigClassArray addObject:modal];
            NSArray * arr = responseObject[@"info"];
            [responseObject[@"info"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * dict = obj;
               AW_BigClassModal * bigModal = [[AW_BigClassModal alloc]init];
                bigModal.bid_id = dict[@"id"];
                bigModal.big_name = dict[@"name"];
                bigModal.bid_image = dict[@"img"];
                bigModal.tmpImage = self.iconArray[idx + 1];
                [self.bigClassArray addObject:bigModal];
            }];
            //插入默认收礼人modal
            [self.tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * tmpDict = obj;
                AW_BigClassModal * receiveModal = [[AW_BigClassModal alloc]init];
                receiveModal.big_name = [tmpDict allKeys][0];
                receiveModal.tmpImage = self.iconArray[arr.count + 1];
                [self.bigClassArray addObject:receiveModal];
            }];
            //插入原创modal
            AW_BigClassModal * originalityModal = [[AW_BigClassModal alloc]init];
            originalityModal.big_name = @"原创";
            originalityModal.tmpImage = self.iconArray[arr.count + 2];
            [self.bigClassArray addObject:originalityModal];
            
            //刷新大分类数据
            [self.bigClassTable reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息:%@",[error localizedDescription]);
    }];
}

// 点击搜索方法
- (void)searchBtnClick {
    AW_KeyWordSearchController * keySearchController = [[AW_KeyWordSearchController alloc]init];
    keySearchController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:keySearchController animated:YES];
}

// 点击购物车方法
- (void)shopCartBtnClick {
    //判断用户的登陆状态(如果没有登陆就跳转到登陆界面)
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * nameString = [userDefault objectForKey:@"name"];
    if (!nameString) {
        //如果是没有登录状态就跳转到登陆界面
        DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
        AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:self options:nil][1];
        contentView.bounds = Rect(0, 0, 272, 130);
        alertView.contentView = contentView;
        [alertView showWithoutAnimation];
        //点击确定或取消按钮的回调(弹出视图)
        __weak typeof(self) weakSelf = self;
        contentView.didClickedBtn = ^(NSInteger index){
            if (index == 1) {
                AW_LoginInViewController * controller = [[AW_LoginInViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }else if(index == 2){
                NSLog(@"点击了取消按钮。。。");
            }
        };
    }else{
       //如果是登陆状态就跳转到购物车界面
        AW_MyShopCarViewController * shopCart = [[AW_MyShopCarViewController alloc]init];
        shopCart.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopCart animated:YES];
    }
}


#pragma mark - TableViewData Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.bigClassTable) {
        return self.bigClassArray.count;
    }else if (tableView == self.smallClassTable){
        return self.smallClassArray.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorColor = HexRGB(0xe6e6e6);
    
    if (tableView == self.bigClassTable) {
        AW_BigClassModal * modal = self.bigClassArray[indexPath.row];
        static NSString * CellId = @"bigCell";
        AW_BigClassCell * bigCell = [tableView dequeueReusableCellWithIdentifier:CellId];
        if (!bigCell) {
            bigCell = BundleToObj(@"AW_BigClassCell");
        }
        //[bigCell.bigClassImage sd_setImageWithURL:[NSURL URLWithString:modal.bid_image]];
        bigCell.bigClassImage.image = [UIImage imageNamed:modal.tmpImage];
        bigCell.bigClassLabel.text = modal.big_name;
        UIView * backView = [[UIView alloc]init];
        backView.backgroundColor = HexRGB(0xF5F5F5);
        bigCell.selectedBackgroundView = backView;
        return bigCell;
    }else if (tableView == self.smallClassTable){
        AW_SmallClassModal * modal = self.smallClassArray[indexPath.row];
        static NSString * cellId = @"smallCell";
        AW_SmallClassCell * smallCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!smallCell) {
            smallCell = BundleToObj(@"AW_SmallClassCell");
        }
        smallCell.smallClassLabel.text = modal.small_name;
        UIView * backView = [[UIView alloc]init];
        backView.backgroundColor = HexRGB(0xF5F5F5);
        smallCell.selectedBackgroundView = backView;
        return smallCell;
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDelegate Menthod
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.bigClassTable) {
        return 40;
    }else if (tableView == self.smallClassTable){
        return 35;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.bigClassTable) {
        AW_BigClassModal * tmpModal = self.bigClassArray[indexPath.row];
        NSLog(@"%@",tmpModal.bid_id);
        if (!tmpModal.bid_id) {
            if (indexPath.row == 0) {
                
                NSLog(@"点击了全部分类。。。。");
                [UIView animateWithDuration:0.3 animations:^{
                    self.backgroundView.alpha = 0;
                    self.containerView.frame = Rect(0, -300, kSCREEN_WIDTH, 300);
                } completion:^(BOOL finished) {
                    self.backgroundView.alpha = 0;
                    //跳转到搜索结果页面
                    AW_SearchReaultController * searchController = [[AW_SearchReaultController alloc]init];
                    searchController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:searchController animated:YES];
                }];
            }else if([tmpModal.big_name isEqualToString:@"原创"]){
                
                NSLog(@"点击了原创按钮");
                [UIView animateWithDuration:0.3 animations:^{
                    self.backgroundView.alpha = 0;
                    self.containerView.frame = Rect(0, -300, kSCREEN_WIDTH, 300);
                } completion:^(BOOL finished) {
                    self.backgroundView.alpha = 0;
                    //跳转到搜索结果页面
                    AW_SearchReaultController * searchController = [[AW_SearchReaultController alloc]init];
                    searchController.searchDataSource.labelString = tmpModal.big_name;
                    searchController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:searchController animated:YES];
                }];
                
            }else{
                NSLog(@"点击了收礼人按钮");
                //先将小分类数组的数据清空
                if (self.smallClassArray.count > 0) {
                    [self.smallClassArray removeAllObjects];
                }
                NSDictionary * smallDict = self.tmpArray[0];
                NSArray * tmpArray = [smallDict valueForKey:@"收礼人"];
                [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString * str = obj;
                    AW_SmallClassModal * smallModal = [[AW_SmallClassModal alloc]init];
                    smallModal.small_name = str;
                    [self.smallClassArray addObject:smallModal];
                }];
                //刷新小分类数据
                [self.smallClassTable reloadData];
            }
        }else {
            //进行小分类请求(点击大分类触发)
            NSError * error = nil;
            AW_BigClassModal * modal = self.bigClassArray[indexPath.row];
            NSDictionary * dict = @{@"id":modal.bid_id};
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * smallDict = @{@"param":@"getSmallType",@"jsonParam":string};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:smallDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]integerValue] == 0) {
                    //先将小分类数组的数据清空
                    if (self.smallClassArray.count > 0) {
                        [self.smallClassArray removeAllObjects];
                    }
                    //为小分类modal赋值
                    [responseObject[@"info"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary * dict = obj;
                        AW_SmallClassModal * smallModal = [[AW_SmallClassModal alloc]init];
                        smallModal.small_id = dict[@"id"];
                        smallModal.small_name = dict[@"name"];
                        [self.smallClassArray addObject:smallModal];
                    }];
                    //刷新小分类数据
                    [self.smallClassTable reloadData];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息:%@",[error localizedDescription]);
            }];
        }
    }else if (tableView == self.smallClassTable){
        AW_SmallClassModal * modal = self.smallClassArray[indexPath.row];
        NSLog(@"小分类id:==%@==",modal.small_id);
        if (modal.small_id) {
            self.leftButton.enabled = YES;
            self.shopBtn.enabled = YES;
            self.searchBtn.enabled = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.backgroundView.alpha = 0;
            } completion:^(BOOL finished) {
                self.backgroundView.hidden = YES;
                //跳转到搜索结果页面
                AW_SearchReaultController * searchController = [[AW_SearchReaultController alloc]init];
                searchController.hidesBottomBarWhenPushed = YES;
                searchController.searchDataSource.class_id = modal.small_id;
                [self.navigationController pushViewController:searchController animated:YES];
            }];
        }else{
            self.leftButton.enabled = YES;
            self.shopBtn.enabled = YES;
            self.searchBtn.enabled = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.backgroundView.alpha = 0;
            }completion:^(BOOL finished) {
                self.backgroundView.hidden = YES;
                //跳转到搜索结果页面
                AW_SearchReaultController * searchController = [[AW_SearchReaultController alloc]init];
                searchController.hidesBottomBarWhenPushed = YES;
                searchController.searchDataSource.labelString = modal.small_name;
                [self.navigationController pushViewController:searchController animated:YES];
            }];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
