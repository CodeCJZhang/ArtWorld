//
//  AW_ConfirmOrderController.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ConfirmOrderController.h"
#import "AW_ConfirmOrderDataSource.h"
#import "AW_Constants.h"
#import "AW_ConfirmOrderFootView.h"
#import "AW_PaymentSucessController.h"
#import "AW_DeliveryAdressController.h" //收货地址控制器
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AW_MyShopCartModal.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "AW_ArtDetailController.h" //艺术品详情

@interface AW_ConfirmOrderController ()<AW_AdressDelegate>
/**
 *  @author cao, 15-09-11 18:09:34
 *
 *  确认订单列表
 */
@property(nonatomic,strong)UITableView * confirmOrderTableView;
/**
 *  @author cao, 15-09-12 11:09:48
 *
 *  确认订单底部视图
 */
@property(nonatomic,strong)AW_ConfirmOrderFootView * footView;
/**
 *  @author cao, 15-11-03 10:11:03
 *
 *  记录服务器返回过来的订单id
 */
@property(nonatomic,copy)NSString * order_id;
/**
 *  @author cao, 15-11-03 11:11:11
 *
 *  商品属性
 */
@property(nonatomic,strong)NSMutableArray * attributeArray;
/**
 *  @author cao, 15-11-03 17:11:30
 *
 *  购物车id字符串
 */
@property(nonatomic,copy)NSMutableString * shopId_string;

@end

@implementation AW_ConfirmOrderController

#pragma mark - Private Menthod

-(NSMutableString*)shopId_string{
    if (!_shopId_string) {
        _shopId_string = [[NSMutableString alloc]init];
    }
    return _shopId_string;
}

-(NSMutableArray*)attributeArray{
    if (!_attributeArray) {
        _attributeArray = [[NSMutableArray alloc]init];
    }
    return _attributeArray;
}

-(UITableView*)confirmOrderTableView{
    if (!_confirmOrderTableView) {
        _confirmOrderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT - self.footView.bounds.size.height) style:UITableViewStylePlain];
        _confirmOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _confirmOrderTableView;
}

-(AW_ConfirmOrderDataSource*)confirmOrderDataSource{
    if (!_confirmOrderDataSource) {
        _confirmOrderDataSource = [[AW_ConfirmOrderDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
        }];
    }
    return _confirmOrderDataSource;
}

-(AW_ConfirmOrderFootView*)footView{
    if (!_footView) {
        _footView = BundleToObj(@"AW_ConfirmOrderFootView");
    }
    return _footView;
}
#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.confirmOrderTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.confirmOrderTableView];
    self.confirmOrderTableView.dataSource = self.confirmOrderDataSource;
    self.confirmOrderTableView.delegate = self.confirmOrderDataSource;
    self.confirmOrderDataSource.hasLoadMoreFooter = NO;
    self.confirmOrderDataSource.hasRefreshHeader = NO;
    self.confirmOrderDataSource.tableView = self.confirmOrderTableView;
   
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"确认订单";
    //添加底部确认订单视图
    [self.view addSubview:self.footView];
    //添加确认订单按钮点击事件
    [self.footView.confirmOrderBtn addTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchUpInside];
    self.footView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.footView addConstraint:[NSLayoutConstraint constraintWithItem:self.footView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    //点击cell单元格后的回调
    __weak typeof(self) weakSelf = self;
    self.confirmOrderDataSource.didSelectCell = ^(NSInteger index){
        if (index == 0) {
            AW_DeliveryAdressController * adressController = [[AW_DeliveryAdressController alloc]init];
            adressController.hidesBottomBarWhenPushed = YES;
            //将代理指定为weakSelf
            adressController.deliveryDataSource.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:adressController animated:YES];
        }
    };
    //添加提示信息
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissAfterDelay:1];
    [self performSelector:@selector(configData) withObject:nil afterDelay:1];
    
    //点击优惠券确定的按钮回调
    self.confirmOrderDataSource.didClicked = ^(NSString * message){
        [weakSelf showHUDWithMessage:message];
    };
    
    //点击艺术品cell的回调
    self.confirmOrderDataSource.didClickedArtCell = ^(NSString * str){
        AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
        NSLog(@"%@",str);
        controller.detailDataSource.commidity_id = str;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
}

-(void)configData{
    //获取测试数据
    [self.confirmOrderDataSource getData];
    //获取上个界面传过来的艺术品的总价格
    self.footView.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",self.articleTotalPrice + self.confirmOrderDataSource.total_freight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmOrder{
    AW_MyShopCartModal * tmpModal = self.confirmOrderDataSource.dataArr[0];
    NSLog(@"收货地址id：%@",tmpModal.adressModal.adress_Id);
    if (tmpModal.rowHeight == 70) {
        //在这进行请求(提交订单请求)
        NSMutableArray * storeArray = [[NSMutableArray alloc]init];
       [self.confirmOrderDataSource.storeModalArray enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
           //插入商店
           AW_MyShopCartModal * storeModal = obj;
            NSMutableDictionary * StoreDict  = [[NSMutableDictionary alloc]init];
           NSMutableArray * commidityArray = [[NSMutableArray alloc]init];
           [StoreDict setValue:storeModal.storeModal.shop_Id forKey:@"id"];
          
           NSString * message = self.confirmOrderDataSource.messageDict[storeModal.storeModal.shop_Id];
            NSString *coupons = self.confirmOrderDataSource.couponsDict[[NSString stringWithFormat:@"%@",storeModal.storeModal.shop_Id]];
           if (!coupons) {
               coupons = @"";
           }
           if (!message) {
               message = @"";
           }
           NSLog(@"%@",self.confirmOrderDataSource.couponsDict);
           [StoreDict setValue:coupons forKey:@"coupons"];
           [StoreDict setValue:message forKey:@"leaveMessage"];
           NSLog(@"%@",storeModal.storeModal.shop_Id);
           NSLog(@"优惠券：%@",coupons);
           NSLog(@"留言信息：%@",message);
           [storeArray addObject:StoreDict];
           //插入艺术品
           [storeModal.subArray enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
               AW_MyShopCartModal * artModal = obj;
            NSMutableDictionary * CommidityDict  = [[NSMutableDictionary alloc]init];
               [CommidityDict setValue:artModal.commodityModal.commodity_Id forKey:@"id"];
               [CommidityDict setValue:artModal.commodityModal.commodityPrice forKey:@"price"];
               [CommidityDict setValue:artModal.commodityModal.commodityNumber forKey:@"number"];
               [CommidityDict setValue:artModal.commodityModal.commodity_color forKey:@"commodity_attr"];
               [commidityArray addObject:CommidityDict];
               //记录购物车id
               [self.shopId_string appendString:[NSString stringWithFormat:@"%@",artModal.commodityModal.shopCart_id]];
               [self.shopId_string appendString:@","];
               
               //将数据插入数组(请求支付宝时使用)
               [self.attributeArray addObject:artModal.commodityModal];
           }];
           [StoreDict setValue:commidityArray forKey:@"commodityList"];
           
       }];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * user_id = [defaults objectForKey:@"user_id"];
        NSLog(@"%@",self.shopId_string);
        NSLog(@"收货地址id===%@==",tmpModal.adressModal.adress_Id);
       NSDictionary * orderDict =   @{
                       @"userId":user_id,
                       @"id":tmpModal.adressModal.adress_Id,
                       @"anonymousBuy":@"0",
                       @"shoppingId":self.shopId_string,
                       @"json":storeArray,
                   };
        NSError * error = nil;
        NSData * orderData = [NSJSONSerialization dataWithJSONObject:orderDict options:NSJSONWritingPrettyPrinted error:&error];
        NSString * orderString = [[NSString alloc]initWithData:orderData encoding:NSUTF8StringEncoding];
        
        NSDictionary * tmpDict = @{@"param":@"submitOrder",@"jsonParam":orderString};
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:tmpDict success:^(NSURLSessionDataTask *  task, id   responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"%@",responseObject[@"info"]);
            [self showHUDWithMessage:responseObject[@"message"]];
            if ([responseObject[@"code"]intValue] == 0) {
                //获取服务器返回过来的订单id和价格
                self.order_id = [responseObject[@"info"]valueForKey:@"id"];
                NSLog(@"%@",[responseObject[@"info"]valueForKey:@"price"]);
                self.articleTotalPrice = [[responseObject[@"info"]valueForKey:@"price"] floatValue];
                //跳转到支付宝
                [self SubmitOrderAndPayMenthod];
            }
        } failure:^(NSURLSessionDataTask *  task, NSError *  error){
            NSLog(@"错误信息：%@",[error localizedDescription]);
        }];
    }else{
        [self showHUDWithMessage:@"请选择或添加收货地址"];
    }
}

-(void)pushToNextController{
    AW_PaymentSucessController * paySucessController = [[AW_PaymentSucessController alloc]init];
    paySucessController.hidesBottomBarWhenPushed = YES;
    //将收货地址传到支付成功界面
    if (self.confirmOrderDataSource.adressModal) {
       paySucessController.paySucessDataSource.currentAdressModal = self.confirmOrderDataSource.adressModal;
    }else{
       paySucessController.paySucessDataSource.currentAdressModal = self.confirmOrderDataSource.defaultAdressModal;
    }
    //将总价格传到下一个界面
    paySucessController.paySucessDataSource.totalPrice = [NSString stringWithFormat:@"%f",self.articleTotalPrice ];
    //将邮费传到下个界面
    paySucessController.paySucessDataSource.postagePrice = [NSString stringWithFormat:@"%f",self.confirmOrderDataSource.total_freight];
    //将店铺modal数组传到下一个界面
    paySucessController.paySucessDataSource.storeModalArray = [self.confirmOrderDataSource.storeArray copy];
    
    [self.navigationController pushViewController:paySucessController animated:YES];
}

#pragma mark - Delegate Menthod
-(void)didClickAdressCell:(AW_DeliveryAdressModal *)modal{
    self.confirmOrderDataSource.adressModal = modal;
    NSLog(@"传过来的modal====%@===",modal.deliveryName);
    //重新刷新数据
    if (self.confirmOrderDataSource.dataArr) {
        [self.confirmOrderDataSource releaseResources];
        [self.confirmOrderDataSource getData];
        [self.confirmOrderTableView reloadData];
    }
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

#pragma mark - 提交订单进入支付宝
-(void)SubmitOrderAndPayMenthod{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    NSString *partner = @"2088021419253832";
    NSString *seller = @"ytx@artscome.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKoZV2zaIiVFXMk6c9s+J+q1ZSR9Zn7XxfevrpeLmStV9Kkv/7h1mcd99nuI0k0Mg/jXvwqHFkY51ZH6A/dsiT0D7WRbFKCQ6ead1lYqmSPhjidAAInrA7hJQA7ZuR4SYB3UwcTyfO1TcRtOHFE31gh2TcScfTb4gxp27ZJAseohAgMBAAECgYAjRw4yrSrXwAL2WQEeP03YB7bqUnenZujP7cev9mvV6QXM8P+AKiOylBVCmaXEBQx514TvkgS0m9oHZGreLcxoXIaR4U4KD5jTdhmZ8BVzGNUSR9pUFeOLBWbZDm2XbNAHrUdqBkrItiotw0lFodxkDlCM7n3pV9UK4RoJyLBN4QJBANdR0XhZi9zKNakEqYeCURBz8tjELgvb8lii4xR67ksXTsDnD8S+Ov1ykPY9sZvrSTsZD+haQvJczibTJblyJGsCQQDKPGBCtqXZloSG4VgTWt6aGiVkvPZ2So/60yRwSWCNb0wwppYutYYrcvCMxn90s/CaMjvg/BTqAOEQ4IJ5zK6jAkEAmg8NbCnN24TGzg7q6W0BaV88s4HyXEPb6zVoel/Wnd2oWHc6ng9qD6toMvdDXAcF14YADsR+QADM85SB2mTjzwJAKIBg8ttraaE4V17n6bBoJkqYNI2XemdCYIRKpuY7HPguNQwXxbD69talEDxsqC2lQOxQi6VQdvDIIj4kQ0pXqwJAcPa2kQ1r2PsbTce/9S+13iP3ARcpkWjHQ2o1O38Sz6odmzXOaoeDIT2+3bo5TvIR6IYEldTS0rb3NkTqZa67/A==";
    //生成订单信息及签名
    //配置商品标题，商品属性,商品价格字符串
    NSMutableString * titleString = [[NSMutableString alloc]init];
    NSMutableString * attributeString = [[NSMutableString alloc]init];
    [self.attributeArray enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
        AW_CommodityModal * commidityModal = obj;
        NSString * titleStr;//商品标题
        if (commidityModal.commodity_Name.length > 10) {
           titleStr  = [commidityModal.commodity_Name substringToIndex:9];
        }else{
            titleStr = commidityModal.commodity_Name;
        }
        [titleString appendString:titleStr];
        [titleString appendString:@"---"];
        
        NSString *colorStr;//商品属性
        if (commidityModal.commodity_color.length > 10) {
            colorStr = [commidityModal.commodity_color substringToIndex:9];
        }else{
            colorStr = commidityModal.commodity_color;
        }
        [attributeString appendString:colorStr];
        [attributeString appendString:@"---"];
    }];
    
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.order_id; //订单ID
    order.productName = titleString; //商品标题
    order.productDescription = attributeString; //商品描述
    order.amount = @"0.01";
#warning 1分钱
    //[NSString stringWithFormat:@"%.2f",self.articleTotalPrice];
    order.notifyURL =  @"http://www.artscome.com:8080/yitianxia/mobile/zhifubao"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"artWorld";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
            NSLog(@"%@",resultDic[@"memo"]);
            NSLog(@"%@",resultDic[@"resultStatus"]);
            if ([resultDic[@"resultStatus"]integerValue] == 9000) {
                //跳转到支付成功界面
                [self pushToNextController];
            }
        }];
    }
}

@end
