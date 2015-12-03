//
//  AW_DeliveryAdressController.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/1.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_DeliveryAdressController.h"
#import "UIImage+IMB.h"
#import "DeliveryAlertView.h"
#import "AW_DeliveryAdressAlertView.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface AW_DeliveryAdressController ()
/**
 *  @author cao, 15-09-01 17:09:25
 *
 *  收货地址列表
 */
@property(nonatomic,strong)UITableView * deliveryAddressTableView;
/**
 *  @author cao, 15-10-10 16:10:15
 *
 *  收货地址
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * modal;

@end

@implementation AW_DeliveryAdressController

#pragma mark - private Menthod

-(AW_DeliveryAdressDataSource*)deliveryDataSource{
    if (!_deliveryDataSource) {
        _deliveryDataSource = [[AW_DeliveryAdressDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _deliveryDataSource;
}

-(UITableView*)deliveryAddressTableView{
    if (!_deliveryAddressTableView) {
        _deliveryAddressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _deliveryAddressTableView.dataSource = self.deliveryDataSource;
        _deliveryAddressTableView.delegate = self.deliveryDataSource;
        _deliveryAddressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _deliveryAddressTableView;
}

#pragma mark - LifeCycle  Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.deliveryAddressTableView];
    self.deliveryDataSource.hasLoadMoreFooter = NO;
    self.deliveryDataSource.hasRefreshHeader = NO;
    self.deliveryDataSource.tableView = self.deliveryAddressTableView;
    self.deliveryAddressTableView.backgroundColor = HexRGB(0xf6f7f8);
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //获得测试数据
    [self.deliveryDataSource getData];
    
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    // 设置设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x71c930);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    [self.navigationController.navigationBar setShadowImage:shadowImage];//隐藏navgationbar下边的那条线
    
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"收货地址";
    //点击cell单元格后的回调
    __weak typeof(self) weakSelf = self;
    __weak typeof (_delegate) weakDelegate = _delegate;
    self.deliveryDataSource.didSelectAdressCell = ^(AW_DeliveryAdressModal*modal){
        [weakSelf.navigationController popViewControllerAnimated:YES];
        NSLog(@"===%@===",modal.deliveryName);
        NSLog(@"%@",modal.adress_Id);
        [weakDelegate didClickedDeliveryCell:modal];
    };
    //点击删除按钮后的回调
    self.deliveryDataSource.didClickedDeleteBtn = ^(NSInteger index){
        [weakSelf performSelector:@selector(showMessage) withObject:nil afterDelay:1];
    };
    //已经是默认收货地址时，再次点击进行提示
    self.deliveryDataSource.isDefaultAdress = ^(){
        [weakSelf showHUDWithMessage:@"已经是默认收货地址"];
    };
    //设置默认收货地址成功后的回调
    self.deliveryDataSource.defaultAdressSucess = ^(AW_DeliveryAdressModal *modal){
        [weakSelf showHUDWithMessage:@"设置默认收货地址成功"];
        [weakDelegate didClickedDeliveryCell:modal];
    };
    //点击添加收货地址确定按钮的回调
    self.deliveryDataSource.didClickedConfirmButton = ^(AW_DeliveryAdressModal * modal){
        weakSelf.modal = modal;
        NSLog(@"===%@==",modal.deliveryName);
        if (modal.deliveryName.length == 0) {
            [weakSelf showHUDWithMessage:@"收货人姓名不能为空"];
        }else if (modal.deliveryPhoneNumber.length > 0){
            if ([self isAvailableTelephone] == NO) {
                [weakSelf showHUDWithMessage:@"该手机号码不合法"];
            }
        }else if (modal.deliveryPhoneNumber.length == 0){
            [weakSelf showHUDWithMessage:@"手机号码不能为空"];
        }else if (modal.deliveryAdress.length == 0){
            [weakSelf showHUDWithMessage:@"收货地址不能为空"];
        }
        //当收货地址，收货人姓名，电话号码都存时，才刷新数据
        if (modal.deliveryAdress.length >0 && modal.deliveryName.length > 0 && modal.deliveryPhoneNumber.length > 0 && [self isAvailableTelephone] == YES) {
            
            //在这进行添加收货地址请求 (请求成功后刷新数据)
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * user_id = [user objectForKey:@"user_id"];
            NSDictionary * dict = @{
                                  @"userId":user_id,
                                  @"name":modal.deliveryName,
                                  @"phone":modal.deliveryPhoneNumber,
                                  @"address":modal.deliveryAdress,
                                  @"is_default":@"0",
                                };
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * addDict = @{@"jsonParam":str,@"token":@"",@"param":@"addAddress"};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:addDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    //请求成功以后刷新数据
                    [SVProgressHUD showWithStatus:@"请稍等" maskType:SVProgressHUDMaskTypeBlack];
                    [SVProgressHUD dismissAfterDelay:1];
                    [weakSelf performSelector:@selector(reloadAdressData) withObject:nil afterDelay:1];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                 NSLog(@"error:%@",[error localizedDescription]);
            }]; 
        }
    };
    //点击编辑按钮,再点击确定按钮的回调
    self.deliveryDataSource.didClickedEditeConfirmBtn = ^(AW_DeliveryAdressModal * modal){
        weakSelf.modal = modal;
        NSLog(@"===%@==",modal.deliveryName);
        if (modal.deliveryName.length == 0) {
            [weakSelf showHUDWithMessage:@"收货人姓名不能为空"];
        }else if (modal.deliveryPhoneNumber.length > 0){
            if ([self isAvailableTelephone] == NO) {
                [weakSelf showHUDWithMessage:@"该手机号码不合法"];
            }
        }else if (modal.deliveryPhoneNumber.length == 0){
            [weakSelf showHUDWithMessage:@"手机号码不能为空"];
        }else if (modal.deliveryAdress.length == 0){
            [weakSelf showHUDWithMessage:@"收货地址不能为空"];
        }
        //当收货地址，收货人姓名，电话号码都存时，才刷新数据
        if (modal.deliveryAdress.length >0 && modal.deliveryName.length > 0 && modal.deliveryPhoneNumber.length > 0 && [self isAvailableTelephone] == YES) {
            
            //在这进行编辑收货地址请求
            NSLog(@"收货地址id==%@==",modal.adress_Id);
            NSLog(@"%@",modal.deliveryAdress);
            NSLog(@"%@",modal.is_default);
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * user_id = [user objectForKey:@"user_id"];
            NSDictionary * dict = @{
                                    @"id":modal.adress_Id,
                                    @"name":modal.deliveryName,
                                    @"phone":modal.deliveryPhoneNumber,
                                    @"address":modal.deliveryAdress,
                                    @"is_default":modal.is_default,
                                    @"user_id":user_id,
                                    };
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * editeDict = @{@"jsonParam":str,@"token":@"",@"param":@"updateAddress"};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:editeDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    //请求成功以后刷新数据
                    [SVProgressHUD showWithStatus:@"请稍等" maskType:SVProgressHUDMaskTypeBlack];
                    [SVProgressHUD dismissAfterDelay:1];
                    [weakSelf performSelector:@selector(reloadAdressDataAfterEdite) withObject:nil afterDelay:1];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"error:%@",[error localizedDescription]);
            }];
        }
    };
}

-(void)reloadAdressData{
    [self.deliveryDataSource.dataArr addObject:self.deliveryDataSource.freshAdressModal];
    [self.deliveryDataSource.tableView reloadData];
}

-(void)reloadAdressDataAfterEdite{
    [self showHUDWithMessage:@"修改成功"];
    [self.deliveryDataSource.dataArr removeObjectAtIndex:self.deliveryDataSource.adressIndex - 1];
    [self.deliveryDataSource.dataArr insertObject:self.deliveryDataSource.editeModal atIndex:self.deliveryDataSource.adressIndex - 1];
    [self.deliveryDataSource.tableView reloadData];
}

-(void)showMessage{
    [self showHUDWithMessage:@"删除成功"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClick Menthod
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ShowMessage Menthod
- (void)showHUDWithMessage:(NSString*)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.labelFont = [UIFont boldSystemFontOfSize:13];
    hud.margin = 10.f;
    hud.alpha = 0.9;
    hud.cornerRadius = 4.0;
    hud.yOffset = 150.f;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma mark - CheckPhoneNumber Menthod
//验证手机号格式是否正确
- (BOOL)isAvailableTelephone{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return  [regextestmobile evaluateWithObject:self.modal.deliveryPhoneNumber];
}

@end
