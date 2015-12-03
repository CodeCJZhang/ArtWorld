//
//  AW_ArtDetailController.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ArtDetailController.h"
#import "AW_DetailBottomView.h"//底部视图
#import "AW_DeleteAlertMessage.h"
#import "DeliveryAlertView.h"
#import "AW_MyShopCarViewController.h"//购物车界面
#import "AW_LoginInViewController.h"//注册界面
#import "AW_PopView.h"
#import "AW_ShareView.h"//分享视图
#import "AW_SelectColorView.h"//选择颜色视图
#import "MBProgressHUD.h"
#import "AW_MyDetailViewController.h"//我的详情视图
#import "MWPhotoBrowser.h"//图片浏览器
#import "ScaleAnimation.h"
#import "AFNetworking.h"
#import "AW_ArtCommetController.h"//艺术品评价控制器
#import "UIImageView+WebCache.h"
#import "AW_Constants.h"
#import "AW_MyDetailViewController.h"//个人详情界面
#import "ChatViewController.h"//与店主对话界面
#import "UIImage+IMB.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "NSString+HTML.h"
#import "IQKeyboardManager.h"

@interface AW_ArtDetailController ()<MWPhotoBrowserDelegate>

/**
 *  @author cao, 15-10-12 14:10:21
 *
 *  缩放动画控制器
 */
@property(nonatomic,strong)ScaleAnimation *scaleAnimationController;
/**
 *  @author cao, 15-10-25 17:10:18
 *
 *  图片数组
 */
@property(nonatomic,strong)NSMutableArray * photoArray;
/**
 *  @author cao, 15-10-23 14:10:54
 *
 *  艺术品列表
 */
@property(nonatomic,strong)UITableView * artTableView;
/**
 *  @author cao, 15-10-24 16:10:25
 *
 *  底部视图
 */
@property(nonatomic,strong)AW_DetailBottomView * bottomView;
/**
 *  @author cao, 15-10-25 12:10:28
 *
 *  背景视图
 */
@property(nonatomic,strong)UIControl * backgroungViw;
/**
 *  @author cao, 15-10-25 12:10:26
 *
 *  弹出视图
 */
@property(nonatomic,strong)AW_PopView *popView;
/**
 *  @author cao, 15-10-25 12:10:36
 *
 *  分享视图
 */
@property(nonatomic,strong)AW_ShareView * shareView;
/**
 *  @author cao, 15-10-25 12:10:43
 *
 *  颜色选择视图
 */
@property(nonatomic,strong)AW_SelectColorView * selectColorView;
/**
 *  @author cao, 15-10-25 13:10:05
 *
 *  分享视图高度
 */
@property(nonatomic,strong)NSLayoutConstraint * shareHeight;
/**
 *  @author cao, 15-10-25 13:10:21
 *
 *  选择颜色视图高度
 */
@property(nonatomic,strong)NSLayoutConstraint * selectColorHeight;
/**
 *  @author cao, 15-10-25 14:10:30
 *
 *  颜色字符串
 */
@property(nonatomic,copy)NSString * colorString;
/**
 *  @author cao, 15-10-25 17:10:11
 *
 *  左侧按钮
 */
@property(nonatomic,strong)UIButton * leftBtn;
/**
 *  @author cao, 15-10-25 17:10:14
 *
 *  进入购物车按钮
 */
@property(nonatomic,strong)UIButton * shopBtn;
/**
 *  @author cao, 15-10-25 17:10:17
 *
 *  更多按钮
 */
@property(nonatomic,strong)UIButton * moreBtn;
/**
 *  @author cao, 15-11-23 14:11:14
 *
 *  控制器标记
 */
@property(nonatomic)NSInteger viewcontrollerMark;

@end

@implementation AW_ArtDetailController

#pragma mark - Private Menthod
-(AW_DetailBottomView*)bottomView{
    if (!_bottomView) {
        _bottomView = BundleToObj(@"AW_DetailBottomView");
    }
    return _bottomView;
}

-(AW_ArtDetailDataSource*)detailDataSource{
    if (!_detailDataSource) {
        _detailDataSource = [[AW_ArtDetailDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _detailDataSource;
}

-(UITableView*)artTableView{
    if (!_artTableView) {
        _artTableView = [[UITableView alloc]init];
        _artTableView.dataSource = self.detailDataSource;
        _artTableView.delegate = self.detailDataSource;
        _artTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _artTableView.backgroundColor = [UIColor clearColor];
    }
    return _artTableView;
}

-(NSMutableArray*)photoArray{
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc]init];
    }
    return _photoArray;
}

-(ScaleAnimation*)scaleAnimationController{
    if (!_scaleAnimationController) {
        _scaleAnimationController = [[ScaleAnimation alloc] initWithNavigationController:self.navigationController];
    }
    return _scaleAnimationController;
}

#pragma mark - ConfigView Menthod
-(UIControl*)backgroungViw{
    if (!_backgroungViw) {
        _backgroungViw = [[UIControl alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        [_backgroungViw addTarget:self action:@selector(touchBackgroungView) forControlEvents:UIControlEventTouchUpInside];
        _backgroungViw.backgroundColor = [UIColor blackColor];
        _backgroungViw.alpha = 0.4;
        _backgroungViw.hidden = YES;
    }
    return _backgroungViw;
}

-(AW_PopView*)popView{
    if (!_popView) {
        _popView = BundleToObj(@"AW_PopView");
        _popView.hidden = YES;
    }
    return _popView;
}

-(AW_ShareView*)shareView{
    if (!_shareView) {
        //判断手机上是否按装了微信或QQ
    if ([WXApi isWXAppInstalled] && [QQApiInterface isQQInstalled]){
           _shareView = BundleToObj(@"AW_ShareView");
    }else if([WXApi isWXAppInstalled] == NO && [QQApiInterface isQQInstalled] == YES){
        _shareView = [[NSBundle mainBundle]loadNibNamed:@"AW_ShareView" owner:self options:nil][1];
    }else if ([WXApi isWXAppInstalled] == YES && [QQApiInterface isQQInstalled] == NO){
      _shareView = [[NSBundle mainBundle]loadNibNamed:@"AW_ShareView" owner:self options:nil][2];
    }else if ([WXApi isWXAppInstalled] == NO && [QQApiInterface isQQInstalled] == NO)
      _shareView = [[NSBundle mainBundle]loadNibNamed:@"AW_ShareView" owner:self options:nil][3];
    }
    return _shareView;
}

-(AW_SelectColorView*)selectColorView{
    if (!_selectColorView) {
        _selectColorView = BundleToObj(@"AW_SelectColorView");
    }
    return _selectColorView;
}

#pragma mark - lifeCycle Menthod
- (void)viewDidLoad {
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    __weak typeof(self) weakSelf = self;
    [super viewDidLoad];
    [self.view addSubview:self.artTableView];
    self.artTableView.bounces = NO;
    self.artTableView.translatesAutoresizingMaskIntoConstraints = NO;
    //添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.artTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-45]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.artTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.artTableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.artTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    //=========================添加底部视图============================
        [self.view addSubview:self.bottomView];
    if (self.detailDataSource.isCollection == YES) {
        //请求成功后改变图片颜色
        weakSelf.bottomView.praiseImage.image = [UIImage imageNamed:@"赞1"];
        weakSelf.bottomView.storeLabel.textColor= [UIColor redColor];
    }else{
        //请求成功后改变图片颜色
        weakSelf.bottomView.praiseImage.image = [UIImage imageNamed:@"赞-空"];
        weakSelf.bottomView.storeLabel.textColor = [UIColor lightGrayColor];
    }
    
    //点击底部视图按钮的回调
    self.bottomView.didClickedBtn = ^(NSInteger index){
        //取消第一响应者
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        if (index == 1) {
            //判断用户是否已经登陆(判断用户的登录状态)
            //获取UserDefault
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *name = [userDefault objectForKey:@"name"];
            if (!name){
                //如果没有登陆走这个方法
                DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
                AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:weakSelf options:nil][1];
                contentView.bounds = Rect(0, 0, 272, 130);
                alertView.contentView = contentView;
                [alertView showWithoutAnimation];
                //点击确定或取消按钮的回调(弹出视图)
                contentView.didClickedBtn = ^(NSInteger index){
                    if (index == 1) {
                        //进入登陆界面
                        AW_LoginInViewController * loginIn = [[AW_LoginInViewController alloc]init];
                        loginIn.hidesBottomBarWhenPushed  = YES;
                        [weakSelf.navigationController pushViewController:loginIn animated:YES];
                        weakSelf.navigationController.navigationBar.hidden = NO;
                    }else if (index == 2){
                        NSLog(@"点击了取消按钮。。。");
                    }
                };
            }else{
            //如果已经登陆
                if (![weakSelf.bottomView.praiseImage.image isEqual:[UIImage imageNamed:@"赞1"]]) {
                    //在这请求收藏艺术品
                    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                    NSString * IdString = [userDefault objectForKey:@"user_id"];
                    NSError * error = nil;
                    NSDictionary * dict = @{
                                            @"userId":IdString,
                                            @"id":weakSelf.detailDataSource.commidity_id,
                                            };
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                    NSString * collectionString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSDictionary * collectionDict = @{@"param":@"collectionCommodity",@"jsonParam":collectionString};
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    NSLog(@"用户id:==%@==",IdString);
                    NSLog(@"艺术品id==%@==",weakSelf.detailDataSource.commidity_id);
                    [manager POST:ARTSCOME_INT parameters:collectionDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSLog(@"%@",responseObject);
                        if ([responseObject[@"code"]intValue] == 0) {
                            //请求成功后改变图片颜色
                            weakSelf.bottomView.praiseImage.image = [UIImage imageNamed:@"赞1"];
                            weakSelf.bottomView.storeLabel.textColor= [UIColor redColor];
                        }
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        NSLog(@"错误信息：%@",[error localizedDescription]);
                    }];
                }else{
                    
                    //在这请求取消收藏艺术品
                    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                    NSString * IdString = [userDefault objectForKey:@"user_id"];
                    NSLog(@"用户id==%@==",IdString);
                    NSLog(@"艺术品id==%@==",weakSelf.detailDataSource.commidity_id);
                    NSError * error = nil;
                    NSDictionary * dict = @{
                                            @"userId":IdString,
                                            @"id":weakSelf.detailDataSource.commidity_id,
                                            };
                    NSData * Data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                    NSString * string = [[NSString alloc]initWithData:Data encoding:NSUTF8StringEncoding];
                    NSDictionary * cancleDict = @{@"param":@"cancelCollectionCommodity",@"jsonParam":string};
                    AFHTTPSessionManager * httpManager = [AFHTTPSessionManager manager];
                    [httpManager POST:ARTSCOME_INT parameters:cancleDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSLog(@"%@",responseObject);
                        NSLog(@"%@",responseObject[@"message"]);
                        if ([responseObject[@"code"]intValue] == 0) {
                            //请求成功后改变图片颜色
                            weakSelf.bottomView.praiseImage.image = [UIImage imageNamed:@"赞-空"];
                            weakSelf.bottomView.storeLabel.textColor = [UIColor lightGrayColor];
                        }
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        NSLog(@"错误信息：%@",[error localizedDescription]);
                    }];
                }
            }
        }else if (index == 2){
            weakSelf.backgroungViw.hidden = NO;
            weakSelf.backgroungViw.alpha = 0;
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.backgroungViw.alpha = 0.4;
                weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT - 166 + 20, kSCREEN_WIDTH, 166);
            }];
        }else if (index == 3){
            //判断用户是否已经登陆(判断用户的登录状态)
            //获取UserDefault
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *name = [userDefault objectForKey:@"name"];
            if (!name) {
                //如果没有登陆走这个方法
                DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
                AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:weakSelf options:nil][1];
                contentView.bounds = Rect(0, 0, 272, 130);
                alertView.contentView = contentView;
                [alertView showWithoutAnimation];
                //点击确定或取消按钮的回调(弹出视图)
                contentView.didClickedBtn = ^(NSInteger index){
                    if(index == 1) {
                        //进入登陆界面
                        AW_LoginInViewController * loginIn = [[AW_LoginInViewController alloc]init];
                        loginIn.hidesBottomBarWhenPushed  = YES;
                        [weakSelf.navigationController pushViewController:loginIn animated:YES];
                        weakSelf.navigationController.navigationBar.hidden = NO;
                    }else if (index == 2){
                        NSLog(@"点击了取消按钮。。。");
                    }
                };
            }else{
                //如果已经登陆
                if (weakSelf.colorString.length == 0) {
                    [weakSelf showHUDWithMessage:@"请选择颜色"];
                }else{
                    NSLog(@"id:%@",weakSelf.detailDataSource.commidity_id);
                    NSLog(@"amount:%@",weakSelf.detailDataSource.commidity_account);
                    NSLog(@"color:%@",weakSelf.colorString);
                    NSLog(@"shopId:%@",weakSelf.detailDataSource.shop_id);
                    NSString * count = [[NSString alloc]init];
                    if (weakSelf.detailDataSource.commidity_account) {
                        count = weakSelf.detailDataSource.commidity_account;
                    }else{
                        count = @"1";
                    }
                if (!weakSelf.colorString ) {
                    weakSelf.colorString = @"";
                }
                //在这进行请求(加入购物车)
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    NSString * user_id = [defaults objectForKey:@"user_id"];
                    NSDictionary * dict = @{
                                       @"userId":user_id,
                                       @"id":weakSelf.detailDataSource.commidity_id,
                                       @"amount":count,
                                       @"color":weakSelf.colorString,
                                       @"shopId":weakSelf.detailDataSource.shop_id,
                                            };
                    NSError * error = nil;
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                    NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSDictionary * shopCartDict =@{@"param":@"addShoppingCart",@"jsonParam":string};
                    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                    [manager POST:ARTSCOME_INT parameters:shopCartDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSLog(@"%@",responseObject);
                        NSLog(@"%@",responseObject[@"message"]);
                        if ([responseObject[@"code"]intValue]==0) {
                        [weakSelf showHUDWithMessage:@"加入购物车成功"];
                        }
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        NSLog(@"错误信息：%@",[error localizedDescription]);
                    }];
                }
            }
        }
    };
        self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        [self.bottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45]];

    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.detailDataSource.hasLoadMoreFooter = NO;
    self.detailDataSource.hasRefreshHeader = NO;
    self.detailDataSource.tableView = self.artTableView;
    
    //获取数据
    [self.detailDataSource getData];
    
    //添加左右两侧按钮
    [self addLeftAndRightBtn];
    //==========================添加背景视图=========================
    [self.view addSubview: self.backgroungViw];
    self.backgroungViw.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroungViw attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroungViw attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroungViw attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroungViw attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    //===========================添加pop视图=========================
    [self.view addSubview:self.popView];
    //点击pop按钮的回调
    self.popView.didClickedButton = ^(NSInteger index){
        //取消第一响应者
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        if (index == 1) {
            NSLog(@"消息。。。。");
            NSString * nameString = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
            //判断用户是否已经登陆(如果没有登陆就跳转到登陆界面)
            if (!nameString) {
                //如果没有登陆走这个方法
                DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
                AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:weakSelf options:nil][1];
                contentView.bounds = Rect(0, 0, 272, 130);
                alertView.contentView = contentView;
                [alertView showWithoutAnimation];
                //点击确定或取消按钮的回调(弹出视图)
                contentView.didClickedBtn = ^(NSInteger index){
                    if (index == 1) {
                        //跳转到登陆界面
                        AW_LoginInViewController * loginController = [[AW_LoginInViewController alloc]init];
                        loginController.hidesBottomBarWhenPushed = YES;
                        weakSelf.navigationController.navigationBar.hidden = NO;
                        [weakSelf.navigationController pushViewController:loginController animated:YES];
                    }
                };
            }else{
                //如果已经登陆(跳转到消息界面)
                
            }

        }else if (index == 2){
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.backgroungViw.alpha = 0;
                weakSelf.popView.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    weakSelf.backgroungViw.alpha = 0.4;
                    weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT - 166 + 20, kSCREEN_WIDTH, 166);
                }];
            }];
        }
    };
    self.popView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.popView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-12]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.popView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:60]];
    [self.popView addConstraint:[NSLayoutConstraint constraintWithItem:self.popView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70]];
    [self.popView addConstraint:[NSLayoutConstraint constraintWithItem:self.popView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:180]];
    //============================添加share视图=========================
    
    [self.view addSubview:self.shareView];
    //点击shareView上的按钮的回调
    self.shareView.didClickedBtn = ^ (NSInteger index){
        //取消第一响应者
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        
        if (index == 1) {
            [weakSelf SinaShareMenthod];
            
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.backgroungViw.alpha = 0;
                weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT + 20 , kSCREEN_WIDTH, 166);
            } completion:^(BOOL finished) {
                weakSelf.backgroungViw.hidden = YES;
            }];
        }else if (index == 2){
            [weakSelf QQShareMenthod];
            
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.backgroungViw.alpha = 0;
                weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT + 20 , kSCREEN_WIDTH, 166);
            } completion:^(BOOL finished) {
                weakSelf.backgroungViw.hidden = YES;
            }];
        }else if (index == 3){
            [weakSelf WeChatShareMenthod];
            
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.backgroungViw.alpha = 0;
                weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT + 20 , kSCREEN_WIDTH, 166);
            } completion:^(BOOL finished) {
                weakSelf.backgroungViw.hidden = YES;
            }];
        }else if (index == 5){
          [UIView animateWithDuration:0.4 animations:^{
              weakSelf.backgroungViw.alpha = 0;
              weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT + 20 , kSCREEN_WIDTH, 166);
          } completion:^(BOOL finished) {
              weakSelf.backgroungViw.hidden = YES;
          }];
        }
    };
    self.shareView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    self.shareHeight = [NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:166];
    [self.shareView addConstraint:self.shareHeight];
    //=========================添加颜色选择视图==========================
    self.selectColorView.frame = Rect(0, kSCREEN_HEIGHT - 268 + 20 + 268, kSCREEN_WIDTH, 268);
    [self.view addSubview:self.selectColorView];
    //点击确定按钮的回调
    self.selectColorView.didClickedBtns = ^(NSInteger index){
        //取消第一响应者
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        
        if (index == 7) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.backgroungViw.alpha = 0;
                weakSelf.selectColorView.frame = Rect(0, kSCREEN_HEIGHT + 20, kSCREEN_WIDTH, 268);
            } completion:^(BOOL finished) {
                weakSelf.backgroungViw.hidden = YES;
                //将选中的颜色显示在tableView上
                weakSelf.detailDataSource.artColor = weakSelf.colorString;
                [weakSelf.detailDataSource.tableView reloadData];
            }];
            
        }
    };
    
    //点击颜色后的回调
    weakSelf.selectColorView.clickedColorBtnCell = ^(NSString *str){
        NSLog(@"%@",str);
        //取消第一响应者
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        weakSelf.colorString = str;
    };
    
    //点击头部视图按钮的回调
    self.detailDataSource.didClickedHeadCellBtn = ^(NSInteger index){
        //取消第一响应者
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        
        if (index == 1) {
            weakSelf.backgroungViw.hidden = NO;
            weakSelf.backgroungViw.alpha = 0;
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.backgroungViw.alpha = 0.4;
                weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT - 166 + 20, kSCREEN_WIDTH, 166);
            }];
        }else if (index == 2){
            NSLog(@"跳转到评论界面。。。");
            AW_ArtCommetController * commentController = [[AW_ArtCommetController alloc]init];
            commentController.hidesBottomBarWhenPushed = YES;
            weakSelf.navigationController.navigationBar.hidden = NO;
            //将艺术品id传到下一个界面
            commentController.commentDataSource.Art_id = weakSelf.detailDataSource.commidity_id;
            [weakSelf.navigationController pushViewController:commentController animated:YES];
        }
    };
    //点击颜色按钮的回调
    self.detailDataSource.didClickedColorButton = ^(AW_CommodityModal * modal){
        //取消第一响应者
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        
        if (![modal.commodity_color isKindOfClass:[NSNull class]]) {
            NSArray * colorArray = [modal.commodity_color componentsSeparatedByString:@","];
            
            [weakSelf.selectColorView setColorArray:colorArray];
           
            [weakSelf.selectColorView.artImage sd_setImageWithURL:[NSURL URLWithString:modal.clearImageURL] placeholderImage:PLACE_HOLDERIMAGE];
            weakSelf.selectColorView.artDescribe.text = modal.commodity_Name;
            weakSelf.backgroungViw.hidden = NO;
            weakSelf.backgroungViw.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.backgroungViw.alpha = 0.4;
                weakSelf.selectColorView.frame = Rect(0, kSCREEN_HEIGHT - 268 + 20, kSCREEN_WIDTH, 268);
            }];
        }
        
    };
    
    //选择的商品数量小于1时的回调
    self.detailDataSource.didClicked = ^(){
        [weakSelf showHUDWithMessage:@"数量最小为1"];
    };
    //点击商铺cell按钮的回调
    self.detailDataSource.didClickedStoreCell = ^(NSInteger index){
        
        //取消第一响应者
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSString * nameString = [userDefault objectForKey:@"name"];
        if (index == 4) {
            NSLog(@"跳转到联系卖家界面。。。");
            //判断用户是否已经登陆(如果没有登陆就跳转到登陆界面)
            if (!nameString) {
                //如果没有登陆走这个方法
                DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
                AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:weakSelf options:nil][1];
                contentView.bounds = Rect(0, 0, 272, 130);
                alertView.contentView = contentView;
                [alertView showWithoutAnimation];
                //点击确定或取消按钮的回调(弹出视图)
                contentView.didClickedBtn = ^(NSInteger index){
                    NSLog(@"%d",index);
                    if (index == 1) {
                        //跳转到登陆界面
                        AW_LoginInViewController * loginController = [[AW_LoginInViewController alloc]init];
                        loginController.hidesBottomBarWhenPushed = YES;
                        weakSelf.navigationController.navigationBar.hidden = NO;
                        [weakSelf.navigationController pushViewController:loginController animated:YES];
                    }
                };
            }else{
                //如果已经登陆(跳转到联系店主界面)
                if ([nameString isEqualToString:weakSelf.detailDataSource.shoper_IM_id]) {
                    [weakSelf showHUDWithMessage:@"不能和自己聊天"];
                }else{
                    ChatViewController *chatView = [[ChatViewController alloc]initWithChatter:weakSelf.detailDataSource.shoper_IM_id conversationType:eConversationTypeChat];
                    chatView.navigationItem.title = weakSelf.detailDataSource.shoper_IM_id;
                    chatView.shopIM_phone = weakSelf.detailDataSource.shoper_IM_id;
                    NSLog(@"店主id%@",weakSelf.detailDataSource.personId);
                    chatView.shoper_id = weakSelf.detailDataSource.personId;
                    chatView.shop_id = weakSelf.detailDataSource.shop_id;
                    [weakSelf.navigationController pushViewController:chatView animated:YES];
                }
            }
        }else{
            AW_MyDetailViewController * detailController = [[AW_MyDetailViewController alloc]init];
            detailController.hidesBottomBarWhenPushed = YES;
            weakSelf.navigationController.navigationBar.hidden = NO;
            detailController.artStoreBtnTag = index;
            NSLog(@"%@",weakSelf.detailDataSource.personId);
            NSLog(@"%@",weakSelf.detailDataSource.shop_id);
            detailController.person_id =  weakSelf.detailDataSource.personId;
            detailController.shop_id = weakSelf.detailDataSource.shop_id;
            detailController.shop_state = weakSelf.detailDataSource.shop_state;
            detailController.productionDataSource.person_id = weakSelf.detailDataSource.personId;
            detailController.attentionDataSource.person_id = weakSelf.detailDataSource.personId;
            detailController.fansDataSource.person_id = weakSelf.detailDataSource.personId;
            detailController.dynamicDataSource.person_id = weakSelf.detailDataSource.personId;
            
            [weakSelf.navigationController pushViewController:detailController animated:YES];
        }
    };
    //点击相似艺术品的回调
    self.detailDataSource.didClickedSimilaryBtn = ^(NSString* artId){
        //取消第一响应者
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        
        NSLog(@"艺术品id===%@===",artId);
        AW_ArtDetailController * artController = [[AW_ArtDetailController alloc]init];
        artController.hidesBottomBarWhenPushed = YES;
        //将艺术品id传到艺术品详情界面
        artController.detailDataSource.commidity_id = artId;
        [weakSelf.navigationController pushViewController:artController animated:YES];
        weakSelf.viewcontrollerMark = 1;
        //weakSelf.navigationController.navigationBar.hidden = YES;
    };
    //点击轮播视图的回调
    self.detailDataSource.didClickedIcarousel = ^(NSInteger index,NSArray* imageArray){
        
        //取消第一响应者
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        
            [weakSelf.photoArray removeAllObjects];
            weakSelf.photoArray = nil;
            [imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MWPhoto * photo = [[MWPhoto alloc]initWithURL:[NSURL URLWithString:obj]];
                [weakSelf.photoArray addObject:photo];
                
            }];
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:weakSelf];
            browser.displayActionButton = NO;
            browser.displayNavArrows = NO;
            browser.displaySelectionButtons = NO;
            browser.alwaysShowControls = NO;
            browser.zoomPhotosToFill = YES;
            browser.enableGrid = NO;
            browser.startOnGrid = NO;
            browser.enableSwipeToDismiss = NO;
            browser.autoPlayOnAppear = YES;
            [browser setCurrentPhotoIndex:index];
            
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf presentViewController:nc animated:YES completion:nil];
            [browser reloadData];
    };
    //滚动结束后的回调
    self.detailDataSource.didEndScroll = ^(CGFloat beforeY,CGFloat afterY){
        if (beforeY - afterY > 0) {
            weakSelf.moreBtn.hidden = NO;
            weakSelf.shopBtn.hidden = NO;
            weakSelf.leftBtn.hidden = NO;
            weakSelf.moreBtn.alpha = 0;
            weakSelf.shopBtn.alpha = 0;
            weakSelf.leftBtn.alpha = 0;
           [UIView animateWithDuration:0.3 animations:^{
               weakSelf.moreBtn.alpha = 1;
               weakSelf.shopBtn.alpha = 1;
               weakSelf.leftBtn.alpha = 1;
           } completion:^(BOOL finished) {
               
           }];
        }else if (beforeY - afterY < 0){
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.moreBtn.alpha = 0;
                weakSelf.shopBtn.alpha = 0;
                weakSelf.leftBtn.alpha = 0;
            } completion:^(BOOL finished) {
                weakSelf.moreBtn.hidden = YES;
                weakSelf.shopBtn.hidden = YES;
                weakSelf.leftBtn.hidden = YES;
            }];
        }
    };
    //商品数量大于库存的回调
    self.detailDataSource.numgreaterThanStore = ^(){
        [weakSelf showHUDWithMessage:@"商品数量不能大于库存"];
    };
#warning 隐藏navigationBar的返回按钮
    [self.navigationItem setHidesBackButton:YES];
}

-(void)addLeftAndRightBtn{
    //返回按钮
    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 50, 50)];
    [self.view addSubview:self.leftBtn];
    [self.leftBtn setImage:[UIImage imageNamed:@"产品详情---透明圆返回"] forState:UIControlStateNormal];
    self.leftBtn.adjustsImageWhenHighlighted = NO;
    self.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0,5,21,16);
    [self.leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //返回按钮
    self.shopBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-100, 25, 50, 50)];
    [self.view addSubview:self.shopBtn];
    [self.shopBtn setImage:[UIImage imageNamed:@"产品详情---透明圆购物车"] forState:UIControlStateNormal];
    self.shopBtn.adjustsImageWhenHighlighted = NO;
    self.shopBtn.imageEdgeInsets = UIEdgeInsetsMake(0,15,21,6);
    [self.shopBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //更多按钮
    self.moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH- 50, 25, 50, 50)];
    [self.view addSubview:self.moreBtn];
    [self.moreBtn setImage:[UIImage imageNamed:@"产品详情---透明圆更多"] forState:UIControlStateNormal];
    self.moreBtn.adjustsImageWhenHighlighted = NO;
    self.moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0,5,21,16);
    [self.moreBtn addTarget:self action:@selector(moreInfoClicked) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.tmpString = nil;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if (self.viewcontrollerMark != 1) {
        self.navigationController.navigationBar.hidden = NO;
    }
    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClicked Menthod
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;
    
    //在这调用退出艺术品详情接口 (不用等请求成功后在返回上个界面)
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [defaults objectForKey:@"user_id"];
    if (user_id) {
        user_id = user_id;
    }else{
        user_id = @"";
    }
    NSDictionary * dict = @{@"userId":user_id,@"id":self.detailDataSource.commidity_id};
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * cancleDict = @{@"param":@"endCommodityDetail",@"jsonParam":str};
    NSLog(@"艺术品id==%@==",self.detailDataSource.commidity_id);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:cancleDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
}

-(void)rightBtnClick{
    
    //取消第一响应者
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    
    //判断用户是否已经登陆(判断用户的登录状态)
    //获取UserDefault
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefault objectForKey:@"name"];
    if (!name) {
        //如果没有登陆走这个方法
        DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
        AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:self options:nil][1];
        contentView.bounds = Rect(0, 0, 272, 130);
        alertView.contentView = contentView;
        [alertView showWithoutAnimation];
        //点击确定或取消按钮的回调(弹出视图)
        contentView.didClickedBtn = ^(NSInteger index){
            if (index == 1) {
                //进入登陆界面
                AW_LoginInViewController * loginIn = [[AW_LoginInViewController alloc]init];
                loginIn.hidesBottomBarWhenPushed  = YES;
                [self.navigationController pushViewController:loginIn animated:YES];
                self.navigationController.navigationBar.hidden = NO;
            }else if (index == 2){
                NSLog(@"点击了取消按钮。。。");
            }
        };
    }else{
        //如果已经登陆(跳转到购物车界面)
        AW_MyShopCarViewController * shopCart = [[AW_MyShopCarViewController alloc]init];
        shopCart.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopCart animated:YES];
        self.navigationController.navigationBar.hidden = NO;
    }
}

-(void)moreInfoClicked{
    
    //取消第一响应者
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    
    self.backgroungViw.alpha = 0;
    self.backgroungViw.hidden = NO;
    self.popView.alpha = 0;
    self.popView.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroungViw.alpha = 0.4;
        self.popView.alpha = 1.0;
    }];
}

-(void)touchBackgroungView{
  [UIView animateWithDuration: 0.4 animations:^{
      self.backgroungViw.alpha = 0;
      self.popView.alpha = 0;
    self.shareView.frame = Rect(0, kSCREEN_HEIGHT + 20 , kSCREEN_WIDTH, 166);
      self.selectColorView.frame = Rect(0, kSCREEN_HEIGHT + 20, kSCREEN_WIDTH, 268);
  } completion:^(BOOL finished) {
      self.backgroungViw.hidden = YES;
      self.popView.hidden = YES;
  }];
}

#pragma mark - ShowMessage Menthod
- (void)showHUDWithMessage:(NSString*)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

#pragma mark - MWPhotoBrowserDelegate Menthod
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photoArray.count)
        return [self.photoArray objectAtIndex:index];
    return nil;
}

#pragma mark - Share Menthod
-(void)SinaShareMenthod{
     NSString *imagePath ;
    id<ISSCAttachment> tmpimage;
    if (self.detailDataSource.share_image) {
        imagePath = self.detailDataSource.share_image;
        tmpimage = [ShareSDK imageWithUrl:imagePath];
        
    }else{
        imagePath = self.detailDataSource.share_image;
        tmpimage = [ShareSDK imageWithUrl:@"http://www.artscome.com:8080/upload/ic_launche.png"];
    }
    NSString * contentString = [self.detailDataSource.commidity_describe stringByConvertingHTMLToPlainText];
    if (contentString.length > 140) {
        contentString = [contentString substringToIndex:127];
    }
    NSLog(@"%@",contentString);
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[contentString stringByAppendingString:[NSString stringWithFormat:@"http://www.artscome.com:8080/yitianxia/mobile/pics?commodity_id=%@",self.detailDataSource.commidity_id]]
                    defaultContent:@"热爱生活，热爱艺术"
                    image:tmpimage
                    title:contentString
                      url:[NSString stringWithFormat:@"http://www.artscome.com:8080/yitianxia/mobile/pics?commodity_id=%@",self.detailDataSource.commidity_id]
              description:nil
                mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess){
                            [self showHUDWithMessage:@"分享成功"];
                        }
                        else if (state == SSPublishContentStateFail){
                    [self showHUDWithMessage:[error errorDescription]];
                        }
                    }];
}

-(void)QQShareMenthod{
    NSString *imagePath ;
    id<ISSCAttachment> tmpimage;
    if (self.detailDataSource.share_image) {
        imagePath = self.detailDataSource.share_image;
        tmpimage = [ShareSDK imageWithUrl:imagePath];
    }else{
        imagePath = self.detailDataSource.share_image;
        tmpimage = [ShareSDK imageWithUrl:@"http://www.artscome.com:8080/upload/ic_launche.png"];
    }
    NSString * contentString = [self.detailDataSource.commidity_describe stringByConvertingHTMLToPlainText];
    if (contentString.length > 140) {
        contentString = [contentString substringToIndex:127];
    }
    NSLog(@"%@",contentString);
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:contentString
                                       defaultContent:@"热爱生活，热爱艺术"
                                                image:tmpimage
                                                title:@"热爱生活，热爱艺术"
                                                  url:[NSString stringWithFormat:@"http://www.artscome.com:8080/yitianxia/mobile/pics?commodity_id=%@",self.detailDataSource.commidity_id]
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeQQ
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess){
                            [self showHUDWithMessage:@"分享成功"];
                        }
                        else if (state == SSPublishContentStateFail){
                            [self showHUDWithMessage:[error errorDescription]];
                        }
                    }];
}

-(void)WeChatShareMenthod{
    NSString *imagePath ;
    id<ISSCAttachment> tmpimage;
    if (self.detailDataSource.share_image) {
        imagePath = self.detailDataSource.share_image;
        tmpimage = [ShareSDK imageWithUrl:imagePath];
    }else{
        imagePath = self.detailDataSource.share_image;
        tmpimage = [ShareSDK imageWithUrl:@"http://www.artscome.com:8080/upload/ic_launche.png"];
    }
    NSString * contentString = [self.detailDataSource.commidity_describe stringByConvertingHTMLToPlainText];
    if (contentString.length > 140) {
        contentString = [contentString substringToIndex:127];
    }
    NSLog(@"%@",contentString);
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:contentString
                                       defaultContent:@"热爱生活，热爱艺术"
                                                image:tmpimage
                                                title:@"热爱生活，热爱艺术"
                                                  url:[NSString stringWithFormat:@"http://www.artscome.com:8080/yitianxia/mobile/pics?commodity_id=%@",self.detailDataSource.commidity_id]
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiSession
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess){
                            [self showHUDWithMessage:@"分享成功"];
                        }
                        else if (state == SSPublishContentStateFail){
                            [self showHUDWithMessage:[error errorDescription]];
                        }
                    }];
}


@end
