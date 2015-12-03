//
//  AW_MyCollectionStoreController.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyCollectionStoreController.h"
#import "AW_MyCollectionStoreDataSource.h"//我的收藏数据源
#import "AW_MyShopCarViewController.h"//我的购物车
#import "AW_MyDetailViewController.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "AW_NoCommidityView.h"//我收藏的店铺没有收藏品时显示的视图
#import "AW_SearchReaultController.h"
#import "ChatViewController.h"//聊天界面

@interface AW_MyCollectionStoreController ()
/**
 *  @author cao, 15-08-27 15:08:30
 *
 *  我收藏的店铺数据源
 */
@property(nonatomic,strong)AW_MyCollectionStoreDataSource * dataSource;
/**
 *  @author cao, 15-08-27 15:08:42
 *
 *  我收藏的商铺列表
 */
@property(nonatomic,strong)UITableView * myCollectionStoreTableView;
/**
 *  @author cao, 15-10-15 15:10:20
 *
 *  没有收藏店铺时的视图
 */
@property(nonatomic,strong)AW_NoCommidityView * noCommidityView;

@end

@implementation AW_MyCollectionStoreController

#pragma mark - Private  Menthod

-(AW_NoCommidityView*)noCommidityView{
    if (!_noCommidityView) {
        _noCommidityView = BundleToObj(@"AW_NoCommidityView");
    }
    return _noCommidityView;
}

-(AW_MyCollectionStoreDataSource*)dataSource{
    if (!_dataSource) {
        _dataSource = [[AW_MyCollectionStoreDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _dataSource;
}

-(UITableView*)myCollectionStoreTableView{
    if (!_myCollectionStoreTableView) {
        _myCollectionStoreTableView = [[UITableView alloc]init];
        _myCollectionStoreTableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT);
        _myCollectionStoreTableView.backgroundColor = [UIColor clearColor];
        _myCollectionStoreTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _myCollectionStoreTableView;
}
#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //程序的灰色背景色
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    [self.view addSubview:self.myCollectionStoreTableView];
    self.dataSource.tableView = self.myCollectionStoreTableView;
    self.myCollectionStoreTableView.delegate = self.dataSource;
    self.myCollectionStoreTableView.dataSource = self.dataSource;
    self.dataSource.hasRefreshHeader = YES;
    self.dataSource.hasLoadMoreFooter = YES;
    
    self.navigationItem.title = @"我收藏的店铺";
    UIBarButtonItem * rightIterm = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"我收藏的店铺---购物车"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:self action:@selector(rightBarButtonClick)];
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.rightBarButtonItem = rightIterm;
    //添加没有收藏品时的临时视图
    self.noCommidityView.hidden = YES;
    [self.view addSubview:self.noCommidityView];
    self.noCommidityView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noCommidityView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    //请求成功后的回调
    __weak typeof(self) weakSelf =self;
    self.dataSource.didRequestSucess = ^(NSString * num){
        if ([num intValue] == 0) {
            weakSelf.noCommidityView.hidden = NO;
        }else{
            weakSelf.noCommidityView.hidden = YES;
        }
        //点击了随便逛逛按钮
        weakSelf.noCommidityView.didClickedStrollBtn = ^(){
            AW_SearchReaultController * controller = [[AW_SearchReaultController alloc]init];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        };
    };
    //点击按钮后的回调,进入个人详情界面
    self.dataSource.didClickBtn = ^(NSInteger index,AW_MyCollectionStoreModal* storeModal){
        AW_MyDetailViewController * detailController = [[AW_MyDetailViewController alloc]init];
        detailController.hidesBottomBarWhenPushed = YES;
        weakSelf.navigationController.navigationBar.hidden = NO;
        detailController.collectionStoreBtnTag = index;
        //NSLog(@"%@",weakSelf.detailDataSource.personId);
        detailController.person_id = storeModal.storeModal.shoper_id;
        detailController.shop_id = storeModal.storeModal.shop_Id;
        detailController.shop_state = @"3";
        detailController.productionDataSource.person_id = storeModal.storeModal.shoper_id;
        detailController.attentionDataSource.person_id = storeModal.storeModal.shoper_id;
        detailController.fansDataSource.person_id = storeModal.storeModal.shoper_id;
        detailController.dynamicDataSource.person_id = storeModal.storeModal.shoper_id;
        
        [weakSelf.navigationController pushViewController:detailController animated:YES];
    };
    //点击了取消和对话按钮的回调
    self.dataSource.didClickTalkBtn = ^(NSInteger index,AW_MyCollectionStoreModal * modal){
       if (index == 6){
            NSLog(@"商铺的店主id：%@",modal.storeModal.shoper_IM_Id);
           ChatViewController * controller = [[ChatViewController alloc]initWithChatter:modal.storeModal.shoper_IM_Id conversationType:eConversationTypeChat];
           controller.shopIM_phone = [NSString stringWithFormat:@"%@",modal.storeModal.shoper_IM_Id];
           controller.shop_id =  modal.storeModal.shop_Id;
           controller.shoper_id = modal.storeModal.shoper_id;
           controller.navigationItem.title = [NSString stringWithFormat:@"%@",modal.storeModal.shoper_IM_Id];
           [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    };
    //点击取消按钮后的回调
    self.dataSource.didClickedCancleBtn = ^(){
        [SVProgressHUD showWithStatus:@"正在取消收藏" maskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissAfterDelay:1];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf.dataSource.tableView reloadData];
            [weakSelf showHUDWithMessage:@"取消成功"];
            //判断什么时候显示隐藏的视图
            if (weakSelf.dataSource.dataArr.count < 2) {
                weakSelf.noCommidityView.hidden = NO;
                weakSelf.noCommidityView.didClickedStrollBtn = ^(){
                    NSLog(@"点击了随便逛逛按钮。。。");
                    //点击了随便逛逛按钮
                    weakSelf.noCommidityView.didClickedStrollBtn = ^(){
                        AW_SearchReaultController * controller = [[AW_SearchReaultController alloc]init];
                        [weakSelf.navigationController pushViewController:controller animated:YES];
                    };

                };
            }
        });
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
#pragma mark - ButtonClick  Menthod
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonClick{
    AW_MyShopCarViewController * shopController = [[AW_MyShopCarViewController alloc]init];
    shopController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopController animated:YES];
}

#pragma mark - ShowMessage Menthod
- (void)showHUDWithMessage:(NSString*)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = msg;
    hud.labelFont = [UIFont boldSystemFontOfSize:13];
    hud.margin = 10.f;
    hud.cornerRadius = 4.0;
    hud.yOffset = 150.f;
    hud.alpha = 0.9;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}
@end
