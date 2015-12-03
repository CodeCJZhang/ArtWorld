//
//  AW_MineViewController.m
//  artWorld
//
//  Created by a  on 15/8/10.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//
#import "AW_MineViewController.h"
#import "IMB_Macro.h"
#import "UIImage+IMB.h"
#import "AW_MyDetailViewController.h"
#import "AW_MyOrderViewController.h"
#import "AW_MyShopCarViewController.h"
#import "AW_MyCollectionViewController.h"
#import "AW_MyShopCarViewController.h"
#import "AW_MyCollectionStoreController.h"
#import "AW_OptionController.h"
#import "AW_CommenIssureController.h"
#import "AW_MineMainDataSource.h" //我的主界面数据源
#import "AW_MyInformationViewController.h"
#import "AW_CertificationViewController.h"//认证界面
#import "AW_OpenShopViewController.h"//申请开店界面
#import "IQKeyboardManager.h"

@interface AW_MineViewController ()
/**
 *  @author cao, 15-09-13 15:09:33
 *
 *  我的主界面数据源
 */
@property(nonatomic,strong)AW_MineMainDataSource * mineDataSource;
/**
 *  @author cao, 15-09-13 15:09:46
 *
 *  我的界面列表
 */
@property(nonatomic,strong)UITableView * mineTableView;

@end

@implementation AW_MineViewController

#pragma mark - Private Menthod
-(AW_MineMainDataSource*)mineDataSource{
    if (!_mineDataSource) {
        _mineDataSource = [[AW_MineMainDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj){
        }];
    }
    return _mineDataSource;
}

-(UITableView*)mineTableView{
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT-KTAB_BAR_HEIGHT)];
        _mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mineTableView.backgroundColor = [UIColor clearColor];
        _mineTableView.bounces = YES;
    }
    return _mineTableView;
}
#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mineTableView];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mineTableView.delegate = self.mineDataSource;
    self.mineTableView.dataSource = self.mineDataSource;
    self.mineDataSource.tableView = self.mineTableView;
    self.mineDataSource.hasLoadMoreFooter = YES;
    self.mineDataSource.hasRefreshHeader = YES;
    self.navigationController.navigationBar.translucent = NO;
    //界面的灰色背景颜色
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    // 设置设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x88c244);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    //隐藏navgationbar下边的那条线
    [self.navigationController.navigationBar setShadowImage:shadowImage];
    
    __weak typeof(self) weakSelf = self;
    //点击cell上的按钮后的回调
    self.mineDataSource.didClickHeadViewBtn = ^(NSInteger index){
        NSLog(@"按钮的标签：%ld",index);
        [weakSelf kindBtnClick:index];
    };
    self.mineDataSource.didClickOrderViewBtn = ^(NSInteger index){
        [weakSelf OrderKindBtnClick:index];
    };
    self.mineDataSource.didClickStoreBtn = ^(NSInteger index){
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * user_id = [user objectForKey:@"user_id"];
        AW_MyDetailViewController * detailController = [[AW_MyDetailViewController alloc]init];
        detailController.hidesBottomBarWhenPushed = YES;
        detailController.PreviousButtonTag = index;
        NSLog(@"%ld",index);
        detailController.person_id = user_id;
        detailController.shop_state = @"3";
        detailController.productionDataSource.person_id = user_id;
        detailController.attentionDataSource.person_id = user_id;
        detailController.dynamicDataSource.person_id = user_id;
        detailController.fansDataSource.person_id = user_id;
        detailController.collectionStoreBtnTag = 1;
       [weakSelf.navigationController pushViewController:detailController animated:YES];
    };
    self.mineDataSource.didClickOtherCellBtn = ^(NSInteger index){
        [weakSelf OtherKindBtnClick:index];
    };
    self.mineDataSource.didClickBottomCellBtn = ^(NSInteger index){
        [weakSelf BottomKindBtnClick:index];
    };
    self.mineDataSource.didClickedBtnsWithoutProduce = ^(NSInteger index){
        if (index == 5) {
            AW_MyInformationViewController * infomationController = [[AW_MyInformationViewController alloc]init];
            infomationController.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:infomationController animated:YES];
        }else{
            AW_MyDetailViewController * detailController = [[AW_MyDetailViewController alloc]init];
            detailController.hidesBottomBarWhenPushed = YES;
            detailController.buttonWithoutProduceTag = index;
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * user_id = [user objectForKey:@"user_id"];
            detailController.person_id =  user_id;
            detailController.shop_state = weakSelf.mineDataSource.shop_state;
            detailController.productionDataSource.person_id = user_id;
            detailController.attentionDataSource.person_id = user_id;
            detailController.fansDataSource.person_id = user_id;
            detailController.dynamicDataSource.person_id = user_id;
            
            [weakSelf.navigationController pushViewController:detailController animated:YES];
        }
    };
    //点击申请开店和申请认证按钮的回调
    self.mineDataSource.didClickedOpenShopBtn = ^(){
        AW_OpenShopViewController  * ViewController = [[AW_OpenShopViewController alloc]init];
        ViewController.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:ViewController animated:YES];
    };
    self.mineDataSource.didClickedCertificationBtn = ^(){
        AW_CertificationViewController  * certificationViewController = [[AW_CertificationViewController alloc]init];
        certificationViewController.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:certificationViewController animated:YES];
    };
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.mineTableView resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.mineTableView resignFirstResponder];
}

#pragma mark - ButtonClick Menthod
-(void)kindBtnClick:(NSInteger)index{
    NSLog(@"%d",[NSThread isMainThread]);
    if (index == 5) {
        AW_MyInformationViewController * infomationController = [[AW_MyInformationViewController alloc]init];
        infomationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infomationController animated:YES];
    }else{
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * user_id = [user objectForKey:@"user_id"];
        AW_MyDetailViewController * detailController = [[AW_MyDetailViewController alloc]init];
        detailController.hidesBottomBarWhenPushed = YES;
        detailController.PreviousButtonTag = index;
        detailController.person_id = user_id;
        detailController.shop_state = self.mineDataSource.shop_state;
        detailController.productionDataSource.person_id = user_id;
        detailController.attentionDataSource.person_id = user_id;
        detailController.dynamicDataSource.person_id = user_id;
        detailController.fansDataSource.person_id = user_id;
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

-(void)OrderKindBtnClick:(NSInteger)index{
    AW_MyOrderViewController * orderController = [[AW_MyOrderViewController alloc]init];
    orderController.hidesBottomBarWhenPushed = YES;
    orderController.selectOrderBtnTag = index - 1;
    [self.navigationController pushViewController:orderController animated:YES];
}

-(void)OtherKindBtnClick:(NSInteger)index{
    if (index == 1) {
        AW_MyShopCarViewController * shopController = [[AW_MyShopCarViewController alloc]init];
        shopController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopController animated:YES];
    }else if (index == 2){
        AW_MyCollectionViewController * collectionController = [[AW_MyCollectionViewController alloc]init];
        collectionController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collectionController animated:YES];
    }else if (index == 3){
        AW_MyCollectionStoreController * storeCollection = [[AW_MyCollectionStoreController alloc]init];
        storeCollection.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:storeCollection animated:YES];
    }
}

-(void)BottomKindBtnClick:(NSInteger)index{
    if (index == 1) {
        AW_OptionController * controller = [[AW_OptionController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (index == 2){
        AW_CommenIssureController * questionController = [[AW_CommenIssureController alloc]init];
        questionController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:questionController animated:YES];
    }else if (index == 3){
        [self performSegueWithIdentifier:@"pushToSystermSetting" sender:nil];
    }
}
@end
