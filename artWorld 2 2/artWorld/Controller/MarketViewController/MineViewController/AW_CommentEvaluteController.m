//
//  AW_CommentEvaluteController.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_CommentEvaluteController.h"
#import "AW_Constants.h"
#import "AW_CommentFootView.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface AW_CommentEvaluteController ()
/**
 *  @author cao, 15-09-16 16:09:05
 *
 *  发表评论列表
 */
@property(nonatomic,strong)UITableView * commentTableView;
/**
 *  @author cao, 15-09-16 21:09:05
 *
 *  发表评论底部视图
 */
@property(nonatomic,strong)AW_CommentFootView * footView;

@end

@implementation AW_CommentEvaluteController

#pragma mark - Private Menthod
-(AW_CommentEvaluteDataSource*)commentDataSource{
    if (!_commentDataSource) {
        _commentDataSource = [[AW_CommentEvaluteDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _commentDataSource;
}

-(UITableView*)commentTableView{
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT - 40)];
        _commentTableView.dataSource = self.commentDataSource;
        _commentTableView.delegate = self.commentDataSource;
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTableView.backgroundColor = [UIColor clearColor];
    }
    return _commentTableView;
}

-(AW_CommentFootView*)footView{
    if (!_footView) {
        _footView = BundleToObj(@"AW_CommentFootView");
    }
    return _footView;
}
#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //获取数据
    [self.commentDataSource getData];
    [self.view addSubview:self.commentTableView];
    self.commentDataSource.hasLoadMoreFooter = NO;
    self.commentDataSource.hasRefreshHeader = NO;
    self.commentDataSource.tableView = self.commentTableView;
    self.commentTableView.backgroundColor = [UIColor clearColor];
     //self.view.backgroundColor = HexRGB(0xf6f7f8);
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"发表评论";
    //添加底部视图
    [self.view addSubview:self.footView];
    self.footView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.footView addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:40]];
    //添加点击事件
    [self.footView.selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.footView.commentBtn addTarget:self action:@selector(commentClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectBtnClicked{
    self.footView.selectBtn.selected = !self.footView.selectBtn.selected;
}

-(void)commentClicked{
    //在这进行评论订单请求
    NSMutableArray * artArray = [[NSMutableArray alloc]init];
    __block AW_MyOrderModal * storeModal;
    [self.commentDataSource.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AW_MyOrderModal * modal = obj;
        if (modal.rowHeight == 176) {
            storeModal = modal;
        }else if (modal.rowHeight == 150){
            NSMutableDictionary * artDict = [NSMutableDictionary dictionary];
            [artDict setValue:modal.CommodityModal.commodity_Id forKey:@"commodity_id"];
            [artDict setValue:modal.CommodityModal.comment_state forKey:@"state"];
            [artDict setValue:modal.CommodityModal.comment_content forKey:@"content"];
            //插入数组
            [artArray addObject:artDict];
        }
    }];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSLog(@"%@",storeModal.storeModal.content_grade);
    NSLog(@"%@",storeModal.storeModal.flow_grade);
    NSLog(@"%@",storeModal.orderId);
    NSLog(@"%@",artArray);
    NSDictionary * dict = @{
                         @"userId":user_id,
                         @"shop_id":storeModal.storeModal.shop_Id,
                         @"content_grade":storeModal.storeModal.content_grade,
                         @"flow_grade":storeModal.storeModal.flow_grade,
                         @"service_attitude":storeModal.storeModal.service_attitude,
                         @"commodity_list":artArray,
                         @"order_id":storeModal.orderId,
                        };
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * evaluteDict = @{@"param":@"evaluationCommodity",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:evaluteDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
            //发表评论成功后进行提示
            [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD dismissAfterDelay:1];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [self showHUDWithMessage:@"发表评论成功"];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
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
