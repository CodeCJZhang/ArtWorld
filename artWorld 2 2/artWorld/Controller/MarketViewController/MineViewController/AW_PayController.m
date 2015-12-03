//
//  AW_PayController.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/5.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_PayController.h"
#import "AW_ConfirmOrderFootView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "AW_CommodityModal.h"
#import "AW_PaymentSucessController.h"
#import "AW_ArtDetailController.h"//艺术品详情界面

@interface AW_PayController ()
/**
 *  @author cao, 15-09-12 11:09:48
 *
 *  确认订单底部视图
 */
@property(nonatomic,strong)AW_ConfirmOrderFootView * footView;
/**
 *  @author cao, 15-11-05 10:11:07
 *
 *  付款列表
 */
@property(nonatomic,strong)UITableView * payTableView;

@end

@implementation AW_PayController

#pragma mark - Private Menthod
-(UITableView*)payTableView{
    if (!_payTableView) {
        _payTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT - self.footView.bounds.size.height) style:UITableViewStylePlain];
        _payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _payTableView;
}

-(AW_PayDataSource*)payDataDouse{
    if (!_payDataDouse) {
        _payDataDouse = [[AW_PayDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _payDataDouse;
}

-(AW_ConfirmOrderFootView*)footView{
    if (!_footView) {
        _footView = [[NSBundle mainBundle]loadNibNamed:@"AW_ConfirmOrderFootView" owner:self options:nil][1];
    }
    return _footView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.payTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.payTableView];
    self.payTableView.dataSource = self.payDataDouse;
    self.payTableView.delegate = self.payDataDouse;
    self.payDataDouse.hasLoadMoreFooter = NO;
    self.payDataDouse.hasRefreshHeader = NO;
    self.payDataDouse.tableView = self.payTableView;
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //获取数据
    [self.payDataDouse getData];
    
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
    
    //点击艺术品cell的回调
    __weak typeof(self) weakSeld = self;
    self.payDataDouse.didClickedCell = ^(NSString *commidity_id){
        AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
        NSLog(@"%@",commidity_id);
        controller.detailDataSource.commidity_id = commidity_id;
        [weakSeld.navigationController pushViewController:controller animated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.footView.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",self.payDataDouse.totalPrice.floatValue];
}

-(void)pushToNextController{
    
    AW_PaymentSucessController * paySucessController = [[AW_PaymentSucessController alloc]init];
    paySucessController.hidesBottomBarWhenPushed = YES;
    //将收货地址传到支付成功界面
    paySucessController.paySucessDataSource.currentAdressModal = self.payDataDouse.adressModal;
    //将总价格传到下一个界面
    paySucessController.paySucessDataSource.totalPrice = self.payDataDouse.totalPrice;
    //将运费传到下一个界面
    paySucessController.paySucessDataSource.postagePrice = self.payDataDouse.freight;
   //将店铺modal数组传到下一个界面
    paySucessController.paySucessDataSource.storeModalArray = [self.payDataDouse.storeModalArray copy];
    
    [self.navigationController pushViewController:paySucessController animated:YES];
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmOrder{
   //在这进入支付宝支付
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
    [self.payDataDouse.commidityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AW_CommodityModal * modal = obj;
        
        NSString * titleStr;//商品标题
        if (modal.commodity_Name.length > 10) {
            titleStr  = [modal.commodity_Name substringToIndex:9];
        }else{
            titleStr = modal.commodity_Name;
        }
        [titleString appendString:titleStr];
        [titleString appendString:@"---"];
        
        NSString *colorStr;//商品属性
        if (![modal.commodity_color isKindOfClass:[NSNull class]]) {
            if (modal.commodity_color.length > 10) {
                colorStr = [modal.commodity_color substringToIndex:9];
            }else{
                colorStr = modal.commodity_color;
            }
        }
        
        [titleString appendString:titleStr];
        [titleString appendString:@"---"];
        
        if (colorStr) {
            [attributeString appendString:colorStr];
        }
        [attributeString appendString:@"---"];
    }];
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.payDataDouse.order_id; //订单ID
    order.productName = titleString; //商品标题
    order.productDescription = attributeString; //商品描述
    order.amount =@"0.01";
    //[NSString stringWithFormat:@"%.2f",[self.payDataDouse.totalPrice floatValue]];
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
