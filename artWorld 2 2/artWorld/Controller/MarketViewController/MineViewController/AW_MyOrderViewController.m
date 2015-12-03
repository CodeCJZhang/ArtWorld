//
//  AW_MyOrderViewController.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyOrderViewController.h"
#import "HMSegmentedControl.h"
#import "AW_MyAllOrderDataSource.h"//全部订单数据源
#import "AW_OrderWaitPayDataSource.h"//待付款数据源
#import "AW_OrderWaitSendDataSource.h"//待发货数据源
#import "AW_OrderWaitReceiveDataSource.h"//待收货数据源
#import "AW_WaitEvaluteDataSource.h"//待评价数据源
#import "UIImage+IMB.h"
#import "AW_CommentEvaluteController.h"//发表评论控制器
#import "AW_MyOrderModal.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "AW_ArtDetailController.h"//艺术品详情界面
#import "AFNetworking.h"
#import "AW_PayController.h"//点击付款进入的控制器
#import "ChatViewController.h"
#import "ChatSendHelper.h"
#import "EMMessage.h"

#define KHMSegmentedControlHeight 45

@interface AW_MyOrderViewController ()<UIScrollViewDelegate>

/**
 *  @author cao, 15-08-21 19:08:29
 *
 *  全部订单列表
 */
@property(nonatomic,strong)UITableView * allOrderTableView;
/**
 *  @author cao, 15-08-21 19:08:41
 *
 *  待付款订单列表
 */
@property(nonatomic,strong)UITableView * payMentTableView;
/**
 *  @author cao, 15-08-21 19:08:59
 *
 *  待发货订单列表
 */
@property(nonatomic,strong)UITableView * sendTableView;
/**
 *  @author cao, 15-08-21 19:08:24
 *
 *  待收货订单列表
 */
@property(nonatomic,strong)UITableView * receiveTableView;
/**
 *  @author cao, 15-08-21 19:08:58
 *
 *  待评价订单列表
 */
@property(nonatomic,strong)UITableView * evaluateTableView;
/**
 *  @author cao, 15-08-21 19:08:25
 *
 *  主滚动视图
 */
@property(nonatomic,strong)UIScrollView  *mainScrollView;
/**
 *  @author cao, 15-08-21 19:08:27
 *
 *  全部订单数据源
 */
@property(nonatomic,strong)AW_MyAllOrderDataSource * allOrderDataSource;
/**
 *  @author cao, 15-08-21 19:08:47
 *
 *  待付款订单数据源
 */
@property(nonatomic,strong)AW_OrderWaitPayDataSource * payMentDataSource;
/**
 *  @author cao, 15-08-21 19:08:05
 *
 *  待发货订单数据源
 */
@property(nonatomic,strong)AW_OrderWaitSendDataSource * sendDataSource;
/**
 *  @author cao, 15-08-21 19:08:19
 *
 *  待收货订单数据源
 */
@property(nonatomic,strong)AW_OrderWaitReceiveDataSource * receiveDataSource;
/**
 *  @author cao, 15-08-21 19:08:37
 *
 *  待评价订单数据源
 */
@property(nonatomic,strong)AW_WaitEvaluteDataSource  *evaluateDataSource;
/**
 *  @author cao, 15-08-21 19:08:35
 *
 *  分段按钮
 */
@property(nonatomic,strong)HMSegmentedControl * segment;
@end

@implementation AW_MyOrderViewController

#pragma mark - Prorerty  Menthod
-(AW_MyAllOrderDataSource*)allOrderDataSource{
    if (!_allOrderDataSource) {
        _allOrderDataSource = [[AW_MyAllOrderDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _allOrderDataSource;
}
-(AW_OrderWaitPayDataSource*)payMentDataSource{
    if (!_payMentDataSource) {
        _payMentDataSource = [[AW_OrderWaitPayDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _payMentDataSource;
}
-(AW_OrderWaitSendDataSource*)sendDataSource{
    if (!_sendDataSource) {
        _sendDataSource = [[AW_OrderWaitSendDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _sendDataSource;
}

-(AW_OrderWaitReceiveDataSource*)receiveDataSource{
    if (!_receiveDataSource) {
        _receiveDataSource = [[AW_OrderWaitReceiveDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _receiveDataSource;
}
-(AW_WaitEvaluteDataSource*)evaluateDataSource{
    if (!_evaluateDataSource) {
        _evaluateDataSource = [[AW_WaitEvaluteDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _evaluateDataSource;
}
#pragma mark - ConfigSegment Menthod
-(void)configSegment{
    __weak typeof(self) weakSelf = self;
    _segment = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"]];
    _segment.backgroundColor = [UIColor whiteColor];
    _segment.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    //正常状态下字体颜色
    _segment.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,  [UIFont systemFontOfSize:14],NSFontAttributeName ,nil];
    //选中状态下的字体颜色
    _segment.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x88c244),NSForegroundColorAttributeName,  [UIFont systemFontOfSize:14],NSFontAttributeName ,nil];
    _segment.selectionIndicatorColor = HexRGB(0x88c244);
    _segment.selectionIndicatorHeight = 1.0f;
    _segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //指示器的宽度和文本宽度相同
    _segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segment.selectedSegmentIndex = 0;
    
    //切换视图
    [_segment setIndexChangeBlock:^(NSInteger index) {
        [weakSelf changeTableWithIndex:index];
    }];
    _segment.frame = Rect(0, 0, kSCREEN_WIDTH, KHMSegmentedControlHeight);
    [self.view addSubview:_segment];
    //添加左侧按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark - ConfigTableView  Menthod

-(void)configTableView{
    /**
     主滚动视图
     */
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KHMSegmentedControlHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT - KHMSegmentedControlHeight - kNAV_BAR_HEIGHT)];
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.contentSize = CGSizeMake(kSCREEN_WIDTH*5, kSCREEN_HEIGHT-KHMSegmentedControlHeight - kNAV_BAR_HEIGHT);
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled= YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    /**
     全部订单列表
     */
    _allOrderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - KHMSegmentedControlHeight - kNAV_BAR_HEIGHT)];
    _allOrderTableView.dataSource = self.allOrderDataSource;
    _allOrderTableView.delegate = self.allOrderDataSource;
    self.allOrderDataSource.tableView = _allOrderTableView;
    self.allOrderDataSource.hasRefreshHeader = YES;
    self.allOrderDataSource.hasLoadMoreFooter = YES;
    _allOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _allOrderTableView.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:_allOrderTableView];
    
    /**
     待付款订单列表
     */
    _payMentTableView = [[UITableView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH,0, kSCREEN_WIDTH, kSCREEN_HEIGHT - KHMSegmentedControlHeight - kNAV_BAR_HEIGHT)];
    _payMentTableView.dataSource = self.payMentDataSource;
    _payMentTableView.delegate = self.payMentDataSource;
    self.payMentDataSource.tableView = _payMentTableView;
    self.payMentDataSource.hasRefreshHeader = YES;
    self.payMentDataSource.hasLoadMoreFooter = YES;
    _payMentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _payMentTableView.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:_payMentTableView];
   
    /**
     待发货订单列表
     */
    _sendTableView = [[UITableView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH*2, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - KHMSegmentedControlHeight - kNAV_BAR_HEIGHT)];
    _sendTableView.dataSource = self.sendDataSource;
    _sendTableView.delegate = self.sendDataSource;
    self.sendDataSource.tableView = _sendTableView;
    self.sendDataSource.hasRefreshHeader = YES;
    self.sendDataSource.hasLoadMoreFooter = YES;
    _sendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _sendTableView.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:_sendTableView];
    
    /**
     待收货订单列表
     */
    _receiveTableView = [[UITableView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH*3, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - KHMSegmentedControlHeight - kNAV_BAR_HEIGHT)];
    _receiveTableView.dataSource = self.receiveDataSource;
    _receiveTableView.delegate = self.receiveDataSource;
    self.receiveDataSource.tableView = _receiveTableView;
    self.receiveDataSource.hasRefreshHeader = YES;
    self.receiveDataSource.hasLoadMoreFooter = YES;
    _receiveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _receiveTableView.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:_receiveTableView];
    
    /**
     待评价订单列表
     */
    _evaluateTableView = [[UITableView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH*4, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - KHMSegmentedControlHeight - kNAV_BAR_HEIGHT)];
    _evaluateTableView.dataSource = self.evaluateDataSource;
    _evaluateTableView.delegate = self.evaluateDataSource;
    self.evaluateDataSource.tableView = _evaluateTableView;
    self.evaluateDataSource.hasRefreshHeader = YES;
    self.evaluateDataSource.hasLoadMoreFooter = YES;
    _evaluateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _evaluateTableView.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:_evaluateTableView];
}
/**
 *  @author cao, 15-08-21 21:08:45
 *
 *  切换视图
 *
 *  @param index 视图的索引
 */
-(void)changeTableWithIndex:(NSInteger)index{

    [_mainScrollView scrollRectToVisible:CGRectMake(kSCREEN_WIDTH*index, KHMSegmentedControlHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-KHMSegmentedControlHeight- kNAV_BAR_HEIGHT) animated:NO];
}

#pragma mark - UIScrollViewDlelgate  Menthod

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger current = (scrollView.contentOffset.x + kSCREEN_WIDTH/2)/kSCREEN_WIDTH;
    [_segment setSelectedSegmentIndex:current animated:YES];
}

#pragma mark - LifeCycle  Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSegment];
    [self configTableView];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.selectOrderBtnTag > 0) {
        NSLog(@"%ld",self.selectOrderBtnTag);
        [self.segment setSelectedSegmentIndex:self.selectOrderBtnTag];
        [self changeTableWithIndex:self.selectOrderBtnTag];
    }else if(self.selectOrderBtnTag == 0){
        [self.segment setSelectedSegmentIndex:0];
        [self changeTableWithIndex:0];
    }
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    //界面的灰色背景颜色
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.navigationItem.title = @"我的订单";
    
    //设置设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x88c244);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    //隐藏navgationbar下边的那条线
    [self.navigationController.navigationBar setShadowImage:shadowImage];
    //点击待评价cell上的按钮的回调
    __weak typeof(self) weakSelf = self;
    self.allOrderDataSource.didClickEvaluteCellButtons = ^(AW_MyOrderModal * modal ,NSInteger index){
        if (index == 1) {
            [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD dismissAfterDelay:1];
            
            //在这进行删除订单的请求
            NSDictionary *dict = @{@"orderId":modal.OrderStoreModal.orderId};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * deleteDict = @{@"jsonParam":str,@"token":@"android",@"param":@"delOrder"};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:deleteDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    //请求成功后删除数据
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [weakSelf.allOrderDataSource.dataArr removeObject:modal.separateModal];
                        [weakSelf.allOrderDataSource.dataArr removeObject:modal.OrderStoreModal];
                        [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            AW_MyOrderModal * modal = obj;
                            [weakSelf.allOrderDataSource.dataArr removeObject:modal];
                        }];
                        [weakSelf.allOrderDataSource.dataArr removeObject:modal];
                        [weakSelf.allOrderTableView reloadData];
                        [weakSelf showHUDWithMessage:@"删除成功"];
                    });
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息新：%@",[error localizedDescription]);
            }];

        }else if (index == 2){
           NSLog(@"查看物流:==订单id====%@===商铺名:==%@===",modal.OrderStoreModal.orderId,modal.OrderStoreModal.storeModal.shop_Name);
        }else if (index == 3){
            NSLog(@"订单id==%@==",modal.OrderStoreModal.orderId);
            NSLog(@"shop_id==%@==",modal.OrderStoreModal.storeModal.shop_Id);
            //将modal传到评价订单界面
            AW_CommentEvaluteController * commmentContoller = [[AW_CommentEvaluteController alloc]init];
            commmentContoller.hidesBottomBarWhenPushed = YES;
            commmentContoller.commentDataSource.orderModal = modal;
            [weakSelf.navigationController pushViewController:commmentContoller animated:YES];
        }
    };
    self.evaluateDataSource.didClickedEvaluteCellButtons = ^(AW_MyOrderModal * modal ,NSInteger index){
        if (index == 1) {
            [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD dismissAfterDelay:1];
            
            //在这进行删除订单的请求
            NSDictionary *dict = @{@"orderId":modal.OrderStoreModal.orderId};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * deleteDict = @{@"jsonParam":str,@"token":@"android",@"param":@"delOrder"};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:deleteDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    //请求成功后删除数据
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [weakSelf.evaluateDataSource.dataArr removeObject:modal.separateModal];
                        [weakSelf.evaluateDataSource.dataArr removeObject:modal.OrderStoreModal];
                        [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            AW_MyOrderModal * modal = obj;
                            [weakSelf.evaluateDataSource.dataArr removeObject:modal];
                        }];
                        [weakSelf.evaluateDataSource.dataArr removeObject:modal];
                        [weakSelf.evaluateTableView reloadData];
                        [weakSelf showHUDWithMessage:@"删除成功"];
                    });
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息新：%@",[error localizedDescription]);
            }];
            
        }else if (index == 2){
           NSLog(@"查看物流:==订单id====%@===商铺名:==%@===",modal.OrderStoreModal.orderId,modal.OrderStoreModal.storeModal.shop_Name);
        }else if (index == 3){
            NSLog(@"订单id==%@==",modal.OrderStoreModal.orderId);
            NSLog(@"shop_id==%@==",modal.OrderStoreModal.storeModal.shop_Id);
            //将modal传到评价订单界面
            AW_CommentEvaluteController * commmentContoller = [[AW_CommentEvaluteController alloc]init];
            commmentContoller.hidesBottomBarWhenPushed = YES;
            commmentContoller.commentDataSource.orderModal = modal;
            [weakSelf.navigationController pushViewController:commmentContoller animated:YES];
        }
    };
    //点击待付款cell上的按钮的回调
    self.allOrderDataSource.didClickedPayMentButtons = ^(AW_MyOrderModal*modal ,NSInteger index){
        if (index == 1) {
        NSLog(@"联系卖家:==%@==",modal.OrderStoreModal.storeModal.shoper_IM_Id);
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * user_IM = [user objectForKey:@"name"];
            if ([modal.OrderStoreModal.storeModal.shoper_IM_Id isEqualToString:user_IM]) {
                [weakSelf showHUDWithMessage:@"不能和自己聊天"];
            }else{
                ChatViewController * controller = [[ChatViewController alloc]initWithChatter:modal.OrderStoreModal.storeModal.shoper_IM_Id conversationType:eConversationTypeChat];
                controller.navigationItem.title = modal.OrderStoreModal.storeModal.shoper_IM_Id;
                controller.shopIM_phone = modal.OrderStoreModal.storeModal.shoper_IM_Id;
                controller.shoper_id = modal.OrderStoreModal.storeModal.shoper_id;
                controller.shop_id = modal.OrderStoreModal.storeModal.shop_Id;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            
            }
        }else if (index == 2){
            [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD dismissAfterDelay:1];
            
            //在这进行取消订单请求 (取消成功后在刷新数据)
            NSLog(@"订单id==%@==",modal.OrderStoreModal.orderId);
            NSDictionary * dict = @{@"orderId":modal.OrderStoreModal.orderId};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * cancleDict = @{@"jsonParam":str,@"token":@"android",@"param":@"cancelOrder"};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:cancleDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    //请求成功以后,在这刷新数据
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [weakSelf.allOrderDataSource.dataArr removeObject:modal.separateModal];
                        [weakSelf.allOrderDataSource.dataArr removeObject:modal.OrderStoreModal];
                        [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            AW_MyOrderModal * modal = obj;
                            [weakSelf.allOrderDataSource.dataArr removeObject:modal];
                        }];
                        [weakSelf.allOrderDataSource.dataArr removeObject:modal];
                        [weakSelf.allOrderTableView reloadData];
                        [weakSelf showHUDWithMessage:@"取消成功"];
                    });
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息：%@",[error localizedDescription]);
            }];
     
        }else if (index == 3){
            NSLog(@"付款:订单id===%@==商铺id==%@==",modal.OrderStoreModal.orderId,modal.OrderStoreModal.storeModal.shop_Name);
            //进入付款控制器
            AW_PayController * controller = [[AW_PayController alloc]init];
            controller.payDataDouse.order_id  = modal.OrderStoreModal.orderId;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    };
    self.payMentDataSource.didClickedPayCellButtons = ^(AW_MyOrderModal*modal ,NSInteger index){
        if (index == 1) {
            NSLog(@"联系卖家:==%@==",modal.OrderStoreModal.storeModal.shoper_IM_Id);
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * user_IM = [user objectForKey:@"name"];
            if ([modal.OrderStoreModal.storeModal.shoper_IM_Id isEqualToString:user_IM]) {
                [weakSelf showHUDWithMessage:@"不能和自己聊天"];
            }else{
                ChatViewController * controller = [[ChatViewController alloc]initWithChatter:modal.OrderStoreModal.storeModal.shoper_IM_Id conversationType:eConversationTypeChat];
                controller.navigationItem.title = modal.OrderStoreModal.storeModal.shoper_IM_Id;
                controller.shopIM_phone = modal.OrderStoreModal.storeModal.shoper_IM_Id;
                controller.shoper_id = modal.OrderStoreModal.storeModal.shoper_id;
                controller.shop_id = modal.OrderStoreModal.storeModal.shop_Id;
                [weakSelf.navigationController pushViewController:controller animated:YES];
                
            }
        }else if (index == 2){
            [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD dismissAfterDelay:1];
            
            //在这进行取消订单请求 (取消成功后在刷新数据)
            NSLog(@"订单id==%@==",modal.OrderStoreModal.orderId);
            NSDictionary * dict = @{@"orderId":modal.OrderStoreModal.orderId};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * cancleDict = @{@"jsonParam":str,@"token":@"android",@"param":@"cancelOrder"};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:cancleDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    //请求成功以后,在这刷新数据
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [weakSelf.payMentDataSource.dataArr removeObject:modal.separateModal];
                        [weakSelf.payMentDataSource.dataArr removeObject:modal.OrderStoreModal];
                        [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            AW_MyOrderModal * modal = obj;
                            [weakSelf.payMentDataSource.dataArr removeObject:modal];
                        }];
                        [weakSelf.payMentDataSource.dataArr removeObject:modal];
                        [weakSelf.payMentTableView reloadData];
                        [weakSelf showHUDWithMessage:@"取消成功"];
                    });
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息：%@",[error localizedDescription]);
            }];
        }else if (index == 3){
            NSLog(@"付款:订单id===%@==商铺id==%@==",modal.OrderStoreModal.orderId,modal.OrderStoreModal.storeModal.shop_Name);
            //进入付款控制器
            AW_PayController * controller = [[AW_PayController alloc]init];
            controller.payDataDouse.order_id  = modal.OrderStoreModal.orderId;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    };
    //点击提醒发货按钮的回调
    self.allOrderDataSource.didClickedRemindBtn = ^(AW_MyOrderModal * modal){
    
        [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissAfterDelay:1];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            NSLog(@"%@",modal.OrderStoreModal.orderId);
            NSLog(@"%@",modal.OrderStoreModal.storeModal.shoper_IM_Id);
            //提醒卖家发货
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * user_IM = [user objectForKey:@"name"];
            if ([modal.OrderStoreModal.storeModal.shoper_IM_Id isEqualToString:user_IM]) {
                [weakSelf showHUDWithMessage:@"该店主是自己,不能提醒自己发货"];
            }else{
                [ChatSendHelper sendTextMessageWithString:[NSString stringWithFormat:@"请订单号%@尽快发货,谢谢。",modal.OrderStoreModal.orderId] toUsername:modal.OrderStoreModal.storeModal.shoper_IM_Id messageType:eMessageTypeChat requireEncryption:YES ext:nil];
                [weakSelf showHUDWithMessage:@"提醒成功"];
                
            }
        });
    };
    self.sendDataSource.didClickedRemindButton = ^(AW_MyOrderModal* modal){
        [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissAfterDelay:1];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            NSLog(@"%@",modal.OrderStoreModal.orderId);
            NSLog(@"%@",modal.OrderStoreModal.storeModal.shoper_IM_Id);
            //提醒卖家发货
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * user_IM = [user objectForKey:@"name"];
            NSLog(@"%@",modal.OrderStoreModal.storeModal.shoper_IM_Id);
            if ([modal.OrderStoreModal.storeModal.shoper_IM_Id isEqualToString:user_IM]) {
                [weakSelf showHUDWithMessage:@"该店主是自己,不能提醒自己发货"];
            }else{
                [ChatSendHelper sendTextMessageWithString:[NSString stringWithFormat:@"请订单号%@尽快发货,谢谢。",modal.OrderStoreModal.orderId] toUsername:modal.OrderStoreModal.storeModal.shoper_IM_Id messageType:eMessageTypeChat requireEncryption:YES ext:nil];
                [weakSelf showHUDWithMessage:@"提醒成功"];
            
            }
        });
    };
    //点击待收货cell上的按钮的回调
    self.allOrderDataSource.didClickedReceiveButtons = ^(AW_MyOrderModal*modal,NSInteger index){
        if (index == 1) {
            NSLog(@"查看物流:==订单id====%@===商铺名:==%@===",modal.OrderStoreModal.orderId,modal.OrderStoreModal.storeModal.shop_Name);
        }else if (index == 2){
            NSLog(@"确认收货:==订单id====%@===商铺名:==%@===",modal.OrderStoreModal.orderId,modal.OrderStoreModal.storeModal.shop_Name);
            //在这进行请求确认收货
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * user_id = [user objectForKey:@"user_id"];
            NSDictionary * dict = @{@"userId":user_id,@"orderId":modal.OrderStoreModal.orderId};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * confirmDict = @{@"jsonParam":str,@"token":@"android",@"param":@"confirmReceipt"};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:confirmDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    [weakSelf showHUDWithMessage:@"确认收货成功"];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息：%@",[error localizedDescription]);
            }];
        }
    };
    self.receiveDataSource.didClickedReceiveCellBtns = ^(AW_MyOrderModal*modal,NSInteger index){
        if (index == 1) {
            NSLog(@"查看物流:==订单id====%@===商铺名:==%@===",modal.OrderStoreModal.orderId,modal.OrderStoreModal.storeModal.shop_Name);
        }else if (index == 2){
            NSLog(@"确认收货:==订单id====%@===商铺名:==%@===",modal.OrderStoreModal.orderId,modal.OrderStoreModal.storeModal.shop_Name);
            //在这进行请求确认收货
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * user_id = [user objectForKey:@"user_id"];
            NSDictionary * dict = @{@"userId":user_id,@"orderId":modal.OrderStoreModal.orderId};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * confirmDict = @{@"jsonParam":str,@"token":@"android",@"param":@"confirmReceipt"};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:confirmDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    [weakSelf showHUDWithMessage:@"确认收货成功"];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息：%@",[error localizedDescription]);
            }];
        }
    };
    //点击交易成功cell上的按钮的回调
    self.allOrderDataSource.didClickedOrderSucessCellBtn = ^(AW_MyOrderModal * modal,NSInteger index){
        if (index == 1) {
            [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD dismissAfterDelay:1];
            
            //在这进行删除订单的请求
            NSDictionary *dict = @{@"orderId":modal.OrderStoreModal.orderId};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * deleteDict = @{@"jsonParam":str,@"token":@"android",@"param":@"delOrder"};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:deleteDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    //在这刷新数据
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [weakSelf.allOrderDataSource.dataArr removeObject:modal.separateModal];
                        [weakSelf.allOrderDataSource.dataArr removeObject:modal.OrderStoreModal];
                        [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            AW_MyOrderModal * modal = obj;
                            [weakSelf.allOrderDataSource.dataArr removeObject:modal];
                        }];
                        [weakSelf.allOrderDataSource.dataArr removeObject:modal];
                        [weakSelf.allOrderTableView reloadData];
                        [weakSelf showHUDWithMessage:@"删除成功"];
                    });
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息：%@",[error localizedDescription]);
            }];
            
        }else if (index == 2){
              NSLog(@"查看物流:==订单id====%@===商铺名:==%@===",modal.OrderStoreModal.orderId,modal.OrderStoreModal.storeModal.shop_Name);
        }
    };
    //点击交易关闭cell上的按钮的回调
    self.allOrderDataSource.didClickedOrderCloseCellBtn = ^(AW_MyOrderModal *modal){
        [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissAfterDelay:1];
        
        //在这进行删除订单的请求
        NSDictionary *dict = @{@"orderId":modal.OrderStoreModal.orderId};
        NSError * error = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary * deleteDict = @{@"jsonParam":str,@"token":@"android",@"param":@"delOrder"};
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:deleteDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"code"]intValue] == 0) {
                //在这刷新数据
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf.allOrderDataSource.dataArr removeObject:modal.separateModal];
                    [weakSelf.allOrderDataSource.dataArr removeObject:modal.OrderStoreModal];
                    [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        AW_MyOrderModal * modal = obj;
                        [weakSelf.allOrderDataSource.dataArr removeObject:modal];
                    }];
                    [weakSelf.allOrderDataSource.dataArr removeObject:modal];
                    [weakSelf.allOrderTableView reloadData];
                    [weakSelf showHUDWithMessage:@"删除成功"];
                });
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",[error localizedDescription]);
        }];
    };
    //点击全部订单cell的回调
    self.allOrderDataSource.didClickedCell = ^(AW_CommodityModal *modal){
        AW_ArtDetailController * controlller = [[AW_ArtDetailController alloc]init];
        NSLog(@"%d",modal.isCollected);
        controlller.detailDataSource.commidity_id = modal.commodity_Id;
        controlller.detailDataSource.isCollection = modal.isCollected;
        [weakSelf.navigationController pushViewController:controlller animated:YES];
    };
    //点击待付款cell艺术品的回调
    self.payMentDataSource.didClickedCell = ^(AW_CommodityModal *modal){
        AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
        controller.detailDataSource.commidity_id = modal.commodity_Id;
        controller.detailDataSource.isCollection = modal.isCollected;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
    //点击待发货cell艺术品的回调
    self.sendDataSource.didClickedCell = ^(AW_CommodityModal *modal){
        AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
        controller.detailDataSource.commidity_id = modal.commodity_Id;
        controller.detailDataSource.isCollection = modal.isCollected;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
    //点击待收货cell艺术品的回调
    self.receiveDataSource.didClickedCell = ^(AW_CommodityModal *modal){
        AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
        controller.detailDataSource.commidity_id = modal.commodity_Id;
        controller.detailDataSource.isCollection = modal.isCollected;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
    //点击待评价cell艺术品的回调
    self.evaluateDataSource.didClickedCell = ^(AW_CommodityModal *modal){
        AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
        controller.detailDataSource.commidity_id = modal.commodity_Id;
        controller.detailDataSource.isCollection = modal.isCollected;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ButtonClick Menthod
//返回上一级界面
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

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
