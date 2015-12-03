//
//  AW_MyShopCarViewController.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/24.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyShopCarViewController.h"
#import "AW_MyShopCarDataSource.h" //购物车数据源
#import "UIImage+IMB.h"
#import "AW_MyShopCarCell.h"//艺术品cell
#import "AW_MyShopCarFootView.h"//脚视图
#import "AW_MyShopCarHeadView.h"//头视图
#import "AW_ArticleStoreCell.h" //商铺名称cell
#import "AW_MineViewController.h"
#import "AW_MyShopCartModal.h" //购物车模型
#import "AW_ConfirmOrderController.h"
#import "AW_ConfirmBtnView.h"
#import "AW_SelectColorDataSource.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "AW_SimilaryProduceController.h"//找相似产品控制器
#import "AW_NoCommidityView.h" //购物车中没商品时显示的视图
#import "AW_ArtDetailController.h"//艺术品详情控制器
#import "AW_SelectColorView.h"
#import "AW_Constants.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "AW_SearchReaultController.h"

@interface AW_MyShopCarViewController ()
/**
 *  @author cao, 15-11-25 10:11:08
 *
 *  头部视图
 */
@property(nonatomic,strong)AW_MyShopCarHeadView * headView;
/**
 *  @author cao, 15-11-25 10:11:11
 *
 *  底部视图
 */
@property(nonatomic,strong)AW_MyShopCarFootView * footView;
/**
 *  @author cao, 15-11-25 10:11:14
 *
 *  艺术品cell
 */
@property(nonatomic,strong)AW_MyShopCarCell * articleCell;
/**
 *  @author cao, 15-11-25 10:11:44
 *
 *  店铺cell
 */
@property(nonatomic,strong)AW_ArticleStoreCell * storeNameCell;

//=================↓↓↓弹出视图的属性↓↓↓=====================
/**
 *  @author cao, 15-09-19 14:09:36
 *
 *  弹出的视图（tableView商品详情）
 */
@property(nonatomic,strong)UIView * popingView;
/**
 *  @author cao, 15-10-31 15:10:56
 *
 *  用来记录艺术品id
 */
@property(nonatomic,copy)NSString * art_id;

//=================↑↑↑弹出视图的属性↑↑↑=======================
/**
 *  @author cao, 15-08-25 14:08:35
 *
 *  购物车数据源
 */
@property(nonatomic,strong)AW_MyShopCarDataSource * shopCarDataSource;
/**
 *  @author cao, 15-08-25 14:08:15
 *
 *  购物车列表
 */
@property(nonatomic,strong)UITableView * shopCarTableView;
/**
 *  @author cao, 15-08-26 09:08:37
 *
 *  右侧编辑按钮
 */
@property(nonatomic,strong)UIBarButtonItem * editeBtn;
/**
 *  @author cao, 15-10-15 11:10:11
 *
 *  右侧对话按钮
 */
@property(nonatomic,strong)UIBarButtonItem * talkBtn;
/**
 *  @author cao, 15-10-15 10:10:28
 *
 *  购物车中没有商品时显示的视图
 */
@property(nonatomic,strong)AW_NoCommidityView * noCommidityView;
/**
 *  @author cao, 15-10-31 14:10:46
 *
 *  选择颜色视图
 */
@property(nonatomic,strong)AW_SelectColorView * selectColorView;

@end

@implementation AW_MyShopCarViewController

#pragma mark - PrivateMenthod Menthod

-(UIView*)popingView{
    if (!_popingView) {
        _popingView = [[UIView alloc]init];
    }
    return _popingView;
}

-(AW_MyShopCarFootView*)footView{
    if (!_footView) {
        _footView = BundleToObj(@"AW_MyShopCarFootView");
        _footView.hidden = YES;
    }
    return _footView;
}

-(AW_MyShopCarHeadView*)headView{
    if (!_headView) {
        _headView = BundleToObj(@"AW_MyShopCarHeadView");
    }
    return _headView;
}

-(AW_ArticleStoreCell*)storeNameCell{
    if (!_storeNameCell) {
        _storeNameCell = [[NSBundle mainBundle]loadNibNamed:@"AW_ArticleStoreCell" owner:self options:nil][0];
    }
    return _storeNameCell;
}
-(AW_MyShopCarCell*)articleCell{
    if (!_articleCell) {
        _articleCell = [[NSBundle mainBundle]loadNibNamed:@"AW_MyShopCarCell" owner:self options:nil][0];
    }
    return _articleCell;
}

-(AW_NoCommidityView*)noCommidityView{
    if (!_noCommidityView) {
        _noCommidityView = BundleToObj(@"AW_NoCommidityView");
    }
    return _noCommidityView;
}

-(AW_SelectColorView*)selectColorView{
    if (!_selectColorView) {
        _selectColorView = BundleToObj(@"AW_SelectColorView");
    }
    return _selectColorView;
}

#pragma mark - DataSource  Menthod
-(AW_MyShopCarDataSource*)shopCarDataSource{
    if (!_shopCarDataSource) {
        _shopCarDataSource = [[AW_MyShopCarDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _shopCarDataSource;
}

-(UITableView*)shopCarTableView{
    if (!_shopCarTableView) {
        _shopCarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNAV_BAR_HEIGHT-self.footView.bounds.size.height)style:UITableViewStylePlain];
        _shopCarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _shopCarTableView.backgroundColor = [UIColor clearColor];
        _shopCarTableView.dataSource = self.shopCarDataSource;
        _shopCarTableView.delegate = self.shopCarDataSource;
    }
    return _shopCarTableView;
}

#pragma mark - ConfigPopViews Menthod

- (void)configPopViews {
    self.popingView.backgroundColor = HexRGBAlpha(0x000000, 0.5);

    //添加列表视图
    [self.popingView addSubview:self.selectColorView];
    self.selectColorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.popingView addConstraint:[NSLayoutConstraint constraintWithItem:self.selectColorView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.popingView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.popingView addConstraint:[NSLayoutConstraint constraintWithItem:self.selectColorView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.popingView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.popingView addConstraint:[NSLayoutConstraint constraintWithItem:self.selectColorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.popingView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.selectColorView addConstraint:[NSLayoutConstraint constraintWithItem:self.selectColorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:268]];
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  @author cao, 15-08-25 18:08:04
     *
     *  获得测试数据
     */
    [self.shopCarDataSource getTextData];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak typeof(self) weakSelf = self;
    //艺术品cell进入编辑状态后默认显示的数量
    self.shopCarDataSource.everyArticleNum = 1;
    [self.view addSubview:self.shopCarTableView];
    [self configData];
    self.shopCarDataSource.tableView = self.shopCarTableView;
    //列表的底部视图同数据源的底部视图相关联
    self.shopCarDataSource.FootView = self.footView;
    self.shopCarDataSource.hasRefreshHeader = NO;
    self.shopCarDataSource.hasLoadMoreFooter =NO;
    
    self.shopCarTableView.contentInset = UIEdgeInsetsMake(self.headView.bounds.size.height, 0, 0, 0);
    //添加没有商品时显示的视图
    self.noCommidityView.hidden = YES;
    [self.view addSubview:self.noCommidityView];
    self.noCommidityView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    /**
     *  @author cao, 15-08-25 18:08:17
     *
     *  添加底部的视图
     */
    [self.view addSubview:self.footView];
    self.footView.hidden = YES;
    [self.footView.payMentBtn addTarget:self action:@selector(payMentArticle) forControlEvents:UIControlEventTouchUpInside];
    self.footView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
     [self.footView addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.footView.bounds.size.height]];

    self.navigationItem.title = @"购物车";
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    // 设置设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x88c244);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    [self.navigationController.navigationBar setShadowImage:shadowImage];
    //添加右侧按钮
    self.talkBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"结算--对话图标"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:self action:@selector(payMentAndtalk)];
    self.editeBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑全部" style:0 target:self action:@selector(editeAllArticle)];
    self.editeBtn.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems = @[self.editeBtn];
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //添加弹出商品详情视图
    [self addPopingView];

    //点击展示详情按钮后的回调
    self.shopCarDataSource.didClickDetailBtn = ^(AW_MyShopCartModal * modal){
        NSLog(@"====%@====",modal.commodityModal.commodity_Name);
        //记录下来商品id
        weakSelf.art_id = modal.commodityModal.commodity_Id;
        //将艺术品modal传到颜色选择视图
        if (![modal.commodityModal.all_colors isKindOfClass:[NSNull class]]) {
            NSArray * colorArray = [modal.commodityModal.all_colors componentsSeparatedByString:@","];
            [weakSelf.selectColorView setColorArray:colorArray];
        }

        [weakSelf.selectColorView.artImage sd_setImageWithURL:[NSURL URLWithString:modal.commodityModal.clearImageURL] placeholderImage:PLACE_HOLDERIMAGE];
        weakSelf.selectColorView.artDescribe.text = modal.commodityModal.commodity_Name;
        
        [UIView animateWithDuration:0.2 animations:^{
        weakSelf.popingView.frame = Rect(0, 0, kSCREEN_WIDTH, weakSelf.navigationController.view.bounds.size.height);
        }];
        
        //点击颜色后的回调
        weakSelf.selectColorView.clickedColorBtnCell = ^(NSString *str){
            NSLog(@"%@",str);
            [weakSelf.shopCarDataSource.colorDictionary removeObjectForKey:modal.commodityModal.commodity_Id];
            [weakSelf.shopCarDataSource.colorDictionary  setValue:str forKey:modal.commodityModal.commodity_Id];
        };
        
        //点击颜色确认按钮的回调
        weakSelf.selectColorView.didClickedBtns = ^(NSInteger index){
            if (index == 7) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.popingView.frame = Rect(0, weakSelf.navigationController.view.bounds.size.height, kSCREEN_WIDTH, weakSelf.navigationController.view.bounds.size.height);
                } completion:^(BOOL finished) {
                    //在这进行请求(改变商品的颜色)
                    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                    NSString * user_id = [userDefaults objectForKey:@"user_id"];

                    NSLog(@"user_id:%@",user_id);
                    NSLog(@"艺术品id：%@", modal.commodityModal.commodity_Id);
                    NSLog(@"颜色：%@",weakSelf.shopCarDataSource.colorDictionary[modal.commodityModal.commodity_Id]);
                    if (weakSelf.shopCarDataSource.colorDictionary[modal.commodityModal.commodity_Id]) {
                        NSDictionary * dict = @{
                                                @"userId":user_id,
                                                @"id":modal.commodityModal.shopCart_id,
                                                @"color":weakSelf.shopCarDataSource.colorDictionary[modal.commodityModal.commodity_Id],
                                                };
                        NSError * error = nil;
                        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                        NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSDictionary * colorDict = @{@"param":@"updateShoppingCartColor",@"jsonParam":str};
                        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                        [manager POST:ARTSCOME_INT parameters:colorDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                            NSLog(@"%@",responseObject);
                            NSLog(@"%@",responseObject[@"message"]);
                            modal.commodityModal.commodity_color = weakSelf.shopCarDataSource.colorDictionary[modal.commodityModal.commodity_Id];
                            [weakSelf.shopCarDataSource.tableView reloadData];
                            [weakSelf showHUDWithMessage:@"颜色修改成功"];
                        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                            NSLog(@"错误信息：%@",[error localizedDescription]);
                        }];
                    }
                }];
            }
        };
    };
    

    //点击找相似商品按钮的回调
    weakSelf.shopCarDataSource.didClickSimilaryBtn = ^(NSString * art_id){
        NSLog(@"相似产品id===%@====",art_id);
        AW_SimilaryProduceController * similaryController = [[AW_SimilaryProduceController alloc]init];
        similaryController.hidesBottomBarWhenPushed = YES;
        similaryController.similaryDataSource.similaryArt_id = art_id;
        [weakSelf.navigationController pushViewController:similaryController animated:YES];
    };
    //点击随便逛逛按钮的回调
    self.noCommidityView.didClickedStrollBtn = ^(){
        NSLog(@"点击了随便逛逛按钮");
            AW_SearchReaultController * controller = [[AW_SearchReaultController alloc]init];
            [weakSelf.navigationController pushViewController:controller animated:YES];
    };
    //商品数量在界面上显示为0时进行的回调（显示随便逛逛视图）
    self.shopCarDataSource.noneCommidity = ^(){
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            weakSelf.noCommidityView.hidden = NO;
            weakSelf.footView.hidden = YES;
            weakSelf.navigationItem.rightBarButtonItems = @[weakSelf.editeBtn];
        });
        
        //点击随便逛逛按钮的回调
        weakSelf.noCommidityView.didClickedStrollBtn = ^(){
            NSLog(@"点击了随便逛逛按钮");
            AW_SearchReaultController * controller = [[AW_SearchReaultController alloc]init];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        };
    };
    
    //点击艺术品cell的回调
    self.shopCarDataSource.didClickedArtCell = ^(NSString * artId){
        AW_ArtDetailController * detailController = [[AW_ArtDetailController alloc]init];
        detailController.detailDataSource.commidity_id = artId;
        [weakSelf.navigationController pushViewController:detailController animated:YES];
    };
    //请求成功后的回调
    self.shopCarDataSource.didrequestSucess = ^(NSString * totalNum,NSString * invaluteNum){
        //没有商品时显示
        if ([totalNum intValue] == 0 && [invaluteNum intValue] == 0) {
            weakSelf.noCommidityView.hidden = NO;
            weakSelf.footView.hidden = YES;
            weakSelf.headView.hidden = YES;
            //点击了随便逛逛按钮
            weakSelf.noCommidityView.didClickedStrollBtn = ^(){
                AW_SearchReaultController * controller = [[AW_SearchReaultController alloc]init];
                [weakSelf.navigationController pushViewController:controller animated:YES];
            };
        }else if ([totalNum intValue] == 0 && [invaluteNum intValue] > 0){
                weakSelf.footView.hidden = NO;
                //显示失效商品的数量
                weakSelf.headView.alertInfo.text = [NSString stringWithFormat:@"您的购物车已有%@件商品失效",invaluteNum];
                weakSelf.headView.hidden = NO;
            weakSelf.noCommidityView.hidden = YES;
        }else if([totalNum intValue] > 0 && [invaluteNum intValue] == 0){
            weakSelf.noCommidityView.hidden = YES;
            weakSelf.footView.hidden = NO;
            weakSelf.headView.hidden = YES;
            weakSelf.shopCarTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }else{
            weakSelf.noCommidityView.hidden = YES;
            weakSelf.footView.hidden = NO;
            weakSelf.headView.hidden = NO;
            weakSelf.headView.alertInfo.text = [NSString stringWithFormat:@"您的购物车已有%@件商品失效",invaluteNum];

        }
//            [UIView animateWithDuration:0.2 animations:^{
//                    self.shopCarTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//                }];
    };
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(void)configData{
    /**
     *  @author cao, 15-08-25 18:08:44
     *
     *  添加顶部的视图
     */
    [self.view addSubview:self.headView];
    self.headView.hidden = YES;
    //添加删除按钮点击事件
    [self.headView.deleteBtn addTarget:self action:@selector(deleteFromView) forControlEvents:UIControlEventTouchUpInside];
    self.headView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.headView addConstraint:[NSLayoutConstraint constraintWithItem:self.headView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.headView.bounds.size.height]];
}



//添加弹出视图
-(void)addPopingView{
    self.popingView.frame = Rect(0, self.navigationController.view.bounds.size.height, kSCREEN_WIDTH, self.navigationController.view.bounds.size.height);
    //一定要添加到(self.navigationController.view)否则显示不全
    [self.navigationController.view addSubview:self.popingView];
    [self configPopViews];
}

#pragma mark - ButtonClick Menthod

-(void)confirmBtnClicked{
    [UIView animateWithDuration:0.2 animations:^{
        self.popingView.frame = Rect(0, self.navigationController.view.bounds.size.height, kSCREEN_WIDTH, self.navigationController.view.bounds.size.height);
    }];
}

-(void)payMentArticle{
    if (self.shopCarDataSource.articleTmpArray.count > 0) {
        AW_ConfirmOrderController * confirmController = [[AW_ConfirmOrderController alloc]init];
        confirmController.hidesBottomBarWhenPushed = YES;
        confirmController.articleTotalPrice = self.shopCarDataSource.totalPrice;
        //将购买的商品信息传到下一个界面
        confirmController.confirmOrderDataSource.PurchaseArticleModal = [self.shopCarDataSource.articleTmpArray mutableCopy];
        confirmController.confirmOrderDataSource.storeArray = [self.shopCarDataSource.tmpArray mutableCopy];
        [self.navigationController pushViewController:confirmController animated:YES];
    }else{
        //[SVProgressHUD showOnlyStatus:@"请选择商品" withDuration:0.5];
        [self showHUDWithMessage:@"请选择商品"];
    }
}

-(void)leftBarButtonClick{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

//=====================↓↓编辑全部艺术品的方法↓↓==================
-(void)editeAllArticle{
    __weak typeof(self) weakSelf = self;
    if ([self.editeBtn.title isEqualToString:@"编辑全部"]) {
        [self.editeBtn setTitle:@"完成"];
        self.shopCarDataSource.tmpPrice = 0;
        [weakSelf.shopCarDataSource.storeIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AW_MyShopCartModal * storeModal = obj;
            NSInteger storeIndex = [weakSelf.shopCarDataSource.dataArr indexOfObject:storeModal];
            NSIndexPath * path = [NSIndexPath indexPathForRow:storeIndex inSection:0];
            AW_ArticleStoreCell * cell1 = (AW_ArticleStoreCell*)[self.shopCarTableView cellForRowAtIndexPath:path];
            cell1.storeEditeBtn.hidden = YES;
            AW_MyShopCartModal* modal = weakSelf.shopCarDataSource.dataArr[path.row];
            [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSIndexPath * Path = [NSIndexPath indexPathForRow:path.row + idx + 1 inSection:0];
                //将艺术品索引存入数组
                AW_MyShopCartModal * cellModal = obj;
                [weakSelf.shopCarDataSource.editeIndexArray addObject:cellModal];
                AW_MyShopCarCell * articlecell = (AW_MyShopCarCell*)[weakSelf.shopCarTableView cellForRowAtIndexPath:Path];
                articlecell.ArticleEditeView.hidden = NO;
          //当点击全选按钮进入编辑状态后,初始化编辑状态时的商品数量
            articlecell.editeArticleNum.text = articlecell.articleNum.text ;
                //首先将编辑之前的艺术品价格记录下来,在编辑完成之后再对艺术品价格进行处理(只有进入选中状态的艺术品cell才走下面这个方法)
                if ([self.shopCarDataSource.articleTmpArray containsObject:cellModal]) {
                    float  tmpPrice = [cellModal.commodityModal.commodityPrice floatValue]*[cellModal.commodityModal.commodityNumber integerValue];
                    //先将原来的艺术品价格删除(在编辑完成后重新赋值)
                    self.shopCarDataSource.tmpPrice = self.shopCarDataSource.tmpPrice + tmpPrice;
                    NSLog(@"%.2f",self.shopCarDataSource.tmpPrice);
                    NSLog(@"%.2f",self.shopCarDataSource.totalPrice);
                }
            }];
        }];
    }else if([self.editeBtn.title isEqualToString:@"完成"]){
        [self.editeBtn setTitle:@"编辑全部"];
        //如果先选择商铺上的编辑按钮，再点击全部选择按钮，就将点击商铺时进入编辑状态的艺术品cell的索引删除(如果不删除，再次点击全部编辑按钮时，原来的又会显示出来)
        [weakSelf.shopCarDataSource.editeArray removeAllObjects];
        [weakSelf.shopCarDataSource.storeIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AW_MyShopCartModal * storeModal = obj;
            NSInteger storeIndex = [weakSelf.shopCarDataSource.dataArr indexOfObject:storeModal];
            NSIndexPath * path = [NSIndexPath indexPathForRow:storeIndex inSection:0];
            AW_ArticleStoreCell * cell1 = (AW_ArticleStoreCell*)[self.shopCarTableView cellForRowAtIndexPath:path];
            cell1.storeEditeBtn.hidden = NO;
            cell1.storeEditeBtn.selected = NO;
            AW_MyShopCartModal* modal = weakSelf.shopCarDataSource.dataArr[path.row];
            [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSIndexPath * Path = [NSIndexPath indexPathForRow:path.row + idx + 1 inSection:0];
                //将艺术品modal存入数组
                AW_MyShopCartModal * cellModal = obj;
                [weakSelf.shopCarDataSource.editeIndexArray removeObject:cellModal];
                AW_MyShopCarCell * articlecell = (AW_MyShopCarCell*)[weakSelf.shopCarTableView cellForRowAtIndexPath:Path];
                articlecell.ArticleEditeView.hidden = YES;
                //在编辑结束后重新赋值(只有进入选中状态的艺术品cell才走下面这个方法)
                if ([self.shopCarDataSource.articleTmpArray containsObject:cellModal]) {
                    float  tmpPrice = [cellModal.commodityModal.commodityPrice floatValue]*[cellModal.commodityModal.commodityNumber integerValue];
                    //先将原来的艺术品价格删除(在编辑完成后重新赋值)
                    self.shopCarDataSource.totalPrice = self.shopCarDataSource.totalPrice + tmpPrice;
                    NSLog(@"%f",self.shopCarDataSource.tmpPrice);
                    NSLog(@"%.2f",self.shopCarDataSource.totalPrice);
                }
            }];
        }];
        self.shopCarDataSource.totalPrice = self.shopCarDataSource.totalPrice - self.shopCarDataSource.tmpPrice;
        NSLog(@"%.2f",self.shopCarDataSource.totalPrice);
        self.footView.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",self.shopCarDataSource.totalPrice];
    }
    
}

-(void)deleteFromView{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在删除" maskType:SVProgressHUDMaskTypeBlack];
     //在这进行请求删除失效的艺术品
    NSMutableString * InvalidString = [[NSMutableString alloc]init];
    [self.shopCarDataSource.invalidArticleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AW_MyShopCartModal * invaluteModal = obj;
        NSString * tmp =  invaluteModal.commodityModal.shopCart_id;
        NSLog(@"%@",tmp);
        [InvalidString appendString:[NSString stringWithFormat:@"%@",tmp]];
        [InvalidString appendString:@","];
    }];
    NSLog(@"%@",InvalidString);
    NSDictionary * dictt = @{@"id":InvalidString};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictt options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * deleteDict = @{@"param":@"delShoppingCart",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:deleteDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"message"]);
        if ([responseObject[@"code"]intValue] == 0) {
            [SVProgressHUD dismiss];
            //请求成功后将界面的数据删除
            [self.headView removeFromSuperview];
            [UIView animateWithDuration:0.1 animations:^{
                self.shopCarTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                [self.shopCarDataSource.invalidArticleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    //将失效的艺术品的数据删除
                    [self.shopCarDataSource.dataArr removeObject:obj];
                    //将多余的分割线删除
                    [self.shopCarDataSource.dataArr removeLastObject];
                }];
            }];
            self.shopCarDataSource.invaluteArticleNum = 0;
            //重新刷新数据
            [self.shopCarTableView reloadData];
            [self showHUDWithMessage:@"删除成功"];
            
            //判断是否显示没有商品的视图
            /*if (self.shopCarDataSource.articleTmpArray.count == 0) {
                weakSelf.noCommidityView.hidden = NO;
                weakSelf.footView.hidden = YES;
                weakSelf.navigationItem.rightBarButtonItems = @[weakSelf.editeBtn];
                //点击随便逛逛按钮的回调
                weakSelf.noCommidityView.didClickedStrollBtn = ^(){
                    NSLog(@"点击了随便逛逛按钮");
                    AW_SearchReaultController * controller = [[AW_SearchReaultController alloc]init];
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                };
            }*/
        }
    }failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
}

-(void)payMentAndtalk{

}

#pragma mark - ShowMessage Menthod
- (void)showHUDWithMessage:(NSString*)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.labelFont = [UIFont boldSystemFontOfSize:13];
    hud.margin = 10.f;
    hud.cornerRadius = 4.0;
    hud.alpha = 0.9;
    hud.yOffset = 150.f;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}
@end
