//
//  AppDelegate.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/6.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import <SMS_SDK/SMS_SDK.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import <AlipaySDK/AlipaySDK.h>
#import <sqlite3.h>
#import "FMDB.h"
#import "NSFileManager+Utils.h"
#import "AW_Constants.h"
#import "SystemCrashReport.h"
#import "EaseMob.h"  //不需要实时语音功能
//#import "EMSDKFull.h"  //具备实时语音功能
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface AppDelegate ()

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //分享
    [self shareMenthod];
    
    //环信设置：
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"artscome#yitianxia" apnsCertName:@"artWorld_dev"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //百度地图设置：
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"NHjO8gejGNbtq1O9aYB6RGYn"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    //发送验证码
    [SMS_SDK registerApp:@"a2795a749876"withSecret:@"35a2f91cc5b890eb02bf77f4ef3a1f3a"];
    self.window.backgroundColor = [UIColor whiteColor];
    //键盘处理
    [self appconfig];
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    self.hostReachability = [Reachability reachabilityWithHostName:@""];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
    
    
    //创建本地数据库
    NSString * documentPath = [NSFileManager documentsDirectory];
    NSString * pathString = [documentPath stringByAppendingPathComponent:@"Data.db"];
    if (![NSFileManager fileExistAt:pathString]) {
        [NSFileManager createFile:pathString withContent:nil];
            FMDatabase * db = [FMDatabase databaseWithPath:pathString];
            if ([db open]) {
                NSString * sql = @"CREATE TABLE 't_userIM' ('user_id' VARCHAR(30)  NOT NULL , 'nickName' VARCHAR(30), 'headImage' VARCHAR(30),'IM_phone' VARCHAR(30))";
                NSString * key_table = @"CREATE TABLE 't_keyWord' ('id'  integer PRIMARY KEY autoincrement, 'keyWord' VARCHAR(30))";
                NSString * artSearch_table = @"CREATE TABLE 't_ArtSearch' ('id'  integer PRIMARY KEY autoincrement, 'keyWord' VARCHAR(30))";
                if ([db executeUpdate:sql] == YES) {
                    NSLog(@"列表创建成功。。。");
                }else if([db executeUpdate:sql]){
                    NSLog(@"列表创建失败。。。");
                }
                if ([db executeUpdate:key_table]) {
                    NSLog(@"搜索关键词列表创建成功");
                }else{
                    NSLog(@"搜索关键词列表创建失败");
                }
                if ([db executeUpdate:artSearch_table]) {
                    NSLog(@"艺术品搜索关键字列表创建成功");
                }else{
                    NSLog(@"艺术品搜索关键字列表创建失败");
                }
                [db close];
            }else{
                NSLog(@"数据库创建失败。。。");
            }
    }
    NSLog(@"%@",pathString);
    //崩溃时记录cash日志
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}

#pragma mark - GetCrash Menthod
void uncaughtExceptionHandler(NSException *exception){
    // 测试在system crash后是否能弹框（不能）
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Crash" message:@"Report" delegate:nil cancelButtonTitle:@"cancal" otherButtonTitles:@"enter", nil];
        [alertView show];
    });
    
    // 调用堆栈
    NSArray *callStackSymbols = [exception callStackSymbols];
    // 错误reason
    NSString *reason = [exception reason];
    // exception name
    NSString *name = [exception name];
    NSString *result = [NSString stringWithFormat:(@"\n\n\n\niOS系统崩溃报告 \n\n iMobile CrashReport ————————callStackSymbols:%@\n iMobile CrashReport ——————reason:%@\n iMobile CrashReport ——————name:%@\n\n\n\n"),callStackSymbols,reason,name];
    
    SystemCrashReport *report =  nil;
    report = [[SystemCrashReport alloc]initSaveSystemCrashInfoWithErrFile:result];
    // 根据自己的需求将crash信息记录下来，下次启动的时候传给服务器。
    // 尽量不要在此处将crash信息上传，因为App将要退出，不保证能够将信息上传至服务器
}

#pragma mark - Appdelegate Menthod
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)appconfig{
    // 设置键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

#pragma mark - Reachability Menthod
/**
 *  @author cao, 15-10-08 11:10:59
 *
 *  改变网络状态
 *
 *  @param note
 */
- (void)reachabilityChanged:(NSNotification *)note{
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    NSString * internetStatus = [[NSString alloc]init];
    switch (status){
        case NotReachable:{
          internetStatus = @"当前网络不可用";
        }break;
        case ReachableViaWiFi:{
          internetStatus = @"切换到WiFi网络";
        }break;
        case ReachableViaWWAN:{
          internetStatus = @"切换到WWAN网络";
        }break;
    }
    [self showHUDWithMessage:internetStatus];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"NetState"]) {
        [user removeObjectForKey:@"NetState"];
        [user setValue:internetStatus forKey:@"NetState"];
    }else{
        [user setValue:internetStatus forKey:@"NetState"];
    }
}
/**
 *  @author cao, 15-10-08 15:10:05
 *
 *  网络状态改变时界面处理
 *
 *  @param reachability 网络状态
 */
-(void)updateInterfaceWithReachability:(Reachability *)reachability{
    if (reachability == self.hostReachability) {
        NSLog(@"网络不可用");
    }else if (reachability == self.wifiReachability){
        NSLog(@"切换到WIFI状态");
    }else if (reachability == self.internetReachability){
        NSLog(@"切换到WWAN状态");
    }
}
/**
 *  @author cao, 15-10-08 11:10:00
 *
 *  显示网络状态
 *
 *  @param msg
 */
- (void)showHUDWithMessage:(NSString*)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
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

#pragma mark - Share Menthod
-(void)shareMenthod{
    [ShareSDK registerApp:@"c8c09dbfe65d"];//字符串api20为您的ShareSDK的AppKey
    
    //连接短信分享
    //[ShareSDK connectSMS];

    //添加新浪微博应用 注册网址 http://open.weibo.com    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"877916628"
                        appSecret:@"98f51863c3a2dba0afb96d5c16088eb8"
                      redirectUri:@"http://www.artscome.com"
                      weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQZoneWithAppKey:@"1104796545"
                           appSecret:@"9NaHInyiswVZ8Br5"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:@"1104796545"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wxbcc2f3fe5a93363d"
                      appSecret:@"3e2a25e1a02e054caaf5369cbc7eccc4"
                      wechatCls:[WXApi class]];
}

@end
