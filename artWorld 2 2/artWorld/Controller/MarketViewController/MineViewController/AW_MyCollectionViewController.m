//
//  AW_MyCollectionViewController.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyCollectionViewController.h"
#import "AW_MyCollectionDataSource.h"
#import "AW_MycollectionHeadView.h"
#import "UIImage+IMB.h"
#import "AW_NoCommidityView.h"//没有收藏品显示的视图
#import "AW_MyCollectionModal.h"
#import "AW_ArtsQueryCell.h"
#import "AW_SearchReaultController.h"//艺术品列表
#import "AW_ArtDetailController.h"//艺术品详情控制器

@interface AW_MyCollectionViewController ()
/**
 *  @author cao, 15-10-15 18:10:03
 *
 *  没有收藏品时显示的视图
 */
@property(nonatomic,strong)AW_NoCommidityView *noCommidityView;
/**
 *  @author cao, 15-08-26 12:08:01
 *
 *  我的收藏数据源
 */
@property(nonatomic,strong)AW_MyCollectionDataSource * collectionDataSource;
/**
 *  @author cao, 15-08-26 12:08:16
 *
 *  我的收藏上部的视图
 */
@property(nonatomic,strong)AW_MycollectionHeadView * collectionHeadView;
/**
 *  @author cao, 15-08-26 12:08:39
 *
 *  我的收藏列表
 */
@property(nonatomic,strong)UITableView * myCollectionTableView;
/**
 *  @author cao, 15-10-16 11:10:18
 *
 *  搜索关键字
 */
@property(nonatomic,copy)NSString * searchString;

@end

@implementation AW_MyCollectionViewController

#pragma mark - Private Menthod

-(AW_NoCommidityView*)noCommidityView{
    if (!_noCommidityView) {
        _noCommidityView = BundleToObj(@"AW_NoCommidityView");
    }
    return _noCommidityView;
}

-(AW_MycollectionHeadView*)collectionHeadView{
    if (!_collectionHeadView) {
        _collectionHeadView = BundleToObj(@"AW_MycollectionHeadView");
    }
    return _collectionHeadView;
}

-(AW_MyCollectionDataSource*)collectionDataSource{
    if (!_collectionDataSource) {
        _collectionDataSource = [[AW_MyCollectionDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
        }];
    }
    return _collectionDataSource;
}

-(UITableView*)myCollectionTableView{
    if (!_myCollectionTableView) {
        _myCollectionTableView = [[UITableView alloc]init];
        _myCollectionTableView.frame = CGRectMake(0, self.collectionHeadView.bounds.size.height, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT - self.collectionHeadView.bounds.size.height);
        _myCollectionTableView.dataSource = self.collectionDataSource;
        _myCollectionTableView.delegate = self.collectionDataSource;
        _myCollectionTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _myCollectionTableView.backgroundColor = [UIColor clearColor];
    }
    return _myCollectionTableView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    //点击cell按钮的回调
    __weak typeof(self)weakSelf = self;
    self.collectionDataSource.didSelectCell = ^(AW_CommodityModal *modal){
        AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.detailDataSource.commidity_id = modal.commodity_Id;
        controller.detailDataSource.isCollection = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加点击事件
    [self.collectionHeadView.classifyBtn addTarget:self action:@selector(classifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.collectionHeadView.hidden = YES;
    [self.collectionHeadView.invalidBtn addTarget:self action:@selector(invalidBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.title = @"我收藏的宝贝";
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:0 target:self action:@selector(backToMineController)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    /**
     *  @author cao, 15-08-26 18:08:43
     *
     *  获取数据
     */
    [self.collectionDataSource getData];
    
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    // 设置设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x88c244);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    [self.navigationController.navigationBar setShadowImage:shadowImage];//隐藏navgationbar下边的那条线
    /**
     *  @author cao, 15-08-26 15:08:18
     *
     *  添加我的收藏列表视图
     */
    [self.view addSubview:self.myCollectionTableView];
    self.collectionDataSource.tableView = self.myCollectionTableView;
    self.collectionDataSource.hasRefreshHeader = NO;
    self.collectionDataSource.hasLoadMoreFooter = NO;
    /**
     *  @author cao, 15-08-26 15:08:45
     *
     *  添加头部视图
     */
    [self.view addSubview:self.collectionHeadView];
    self.collectionHeadView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionHeadView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionHeadView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionHeadView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.collectionHeadView addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionHeadView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:38]];
    //添加没有艺术品时显示的视图
    self.noCommidityView.hidden = YES;
    [self.view addSubview:self.noCommidityView];
    self.noCommidityView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
  
    //点击取消按钮的回调
    self.collectionDataSource.didClickedCancleBtn = ^(AW_MyCollectionModal*modal){
        NSLog(@"===%ld===",weakSelf.collectionDataSource.dataArr.count);
        //将艺术品总数减去1
        weakSelf.collectionDataSource.totalClassNum  = [NSString stringWithFormat:@"%d",[self.collectionDataSource.totalClassNum intValue] - 1];
        //为button标题赋值
        [weakSelf.collectionHeadView.classifyBtn setTitle:[NSString stringWithFormat:@"全部分类(%@)",weakSelf.collectionDataSource.totalClassNum] forState:UIControlStateNormal];
        
        if(weakSelf.collectionDataSource.dataArr.count < 4){
            //延迟1秒执行
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                weakSelf.noCommidityView.hidden = NO;
                weakSelf.collectionHeadView.hidden = YES;
                //点击了随便逛逛按钮
                weakSelf.noCommidityView.didClickedStrollBtn = ^(){
                    AW_SearchReaultController * controller = [[AW_SearchReaultController alloc]init];
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                };
            });
        }
    };
    //请求成功后的回调
    self.collectionDataSource.requestSucess = ^(NSString * totalNum){
        if ([totalNum intValue] == 0) {
            weakSelf.noCommidityView.hidden = NO;
            weakSelf.collectionHeadView.hidden = YES;
        }else{
            //为button标题赋值
            [weakSelf.collectionHeadView.classifyBtn setTitle:[NSString stringWithFormat:@"全部分类(%@)",weakSelf.collectionDataSource.totalClassNum] forState:UIControlStateNormal];
            weakSelf.noCommidityView.hidden = YES;
            weakSelf.collectionHeadView.hidden = NO;
        
        }
    
    };
    //点击了随便逛逛按钮
    self.noCommidityView.didClickedStrollBtn = ^(){
        AW_SearchReaultController * controller = [[AW_SearchReaultController alloc]init];
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(void)backToMineController{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClick Menthod
//点击左侧按钮
-(void)classifyBtnClick{
    if (self.collectionDataSource.dataArr.count > 0) {
        [self.collectionDataSource.dataArr removeAllObjects];
    }
    [self.collectionDataSource getData];
}
/**
 *  @author cao, 15-08-27 14:08:36
 *
 *  点击右侧按钮，获得失效的收藏商品列表
 */
-(void)invalidBtnClick{
    if (self.collectionDataSource.dataArr.count > 0) {
        [self.collectionDataSource.dataArr removeAllObjects];
    }
    [self.collectionDataSource getFailureData];
    
}

@end
