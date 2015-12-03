//
//  RootViewController.m
//  artWorld
//
//  Created by a on 15/8/8.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "RootViewController.h"
#import "IMB_Macro.h"
#import "DeliveryAlertView.h"
#import "AW_DeleteAlertMessage.h"
#import "AW_LoginInViewController.h"
#import "UIViewController+HUD.h"
#import "ChatListViewController.h"
#import "ContactsViewController.h"
#import "SettingsViewController.h"
#import "ApplyViewController.h"
//#import "CallViewController.h"
#import "ChatViewController.h"
#import "EMCDDeviceManager.h"
#import "RobotManager.h"
#import "UserProfileManager.h"
#import "TTGlobalUICommon.h"
#import "SystemCrashReport.h"
#import "AFNetworking.h"
#import "NSFileManager+Utils.h"
#import "AW_LoadAdvertisementImage.h"
#import "AW_MyDetailViewController.h"//店铺详情
#import "AW_AdvertisementController.h"//广告html
#import "AW_ArtDetailController.h"//广告页的艺术品详情


// add by jason yan 2014-04-30
#define kFileName       @"filename"
#define kFileData       @"filedata"
#define kFileMimeType   @"filemime"

// 文件的MIME类型
#define FILE_MIME_TYPE_FOR_TXT @"text"
#define FILE_MIME_TYPE_FOR_JPG @"image/jpeg"
#define kFileUploadName  @"fileUploadName"

// 文件上传参数名称
// txt
#define kTxtFile     @"file"

@interface RootViewController ()<UITabBarControllerDelegate,UIAlertViewDelegate>
{
    ChatListViewController *_chatListVC;
    ContactsViewController *_contactsVC;
    UIBarButtonItem *_addFriendItem;
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@property(nonatomic,strong)UINavigationController * fromController;
/**
 *  @author cao, 15-11-27 21:11:00
 *
 *  广告图片按钮
 */
@property(nonatomic,strong)UIButton * adButton;
@end

@implementation RootViewController

#pragma mark - SendCashInfo Menthod

//发送cash日志
- (void)sendCrashInfo {
    SystemCrashReport *crashReport = [[SystemCrashReport alloc]initSaveSystemCrashInfoWithErrFile:nil];
    if (!crashReport.isExsitFile) {
        NSLog(@"不用上传，不存在文件...");
        return;
    }
    NSLog(@"%@",crashReport);
    NSDictionary * dic = @{
                         @"mobile_brand":@"Apple",
                         @"mobile_version":crashReport.deviceModels,
                         @"mobile_type":crashReport.systemVersion,
                         @"system_version":crashReport.appBuild,
                         @"app_version":crashReport.appVersion,
                         //@"bug_details":@"",
                        };
    NSError *err;
    //转换成json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
    NSString *json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"param":@"addBug",@"jsonParam":json}];
    AFHTTPSessionManager * Manager = [AFHTTPSessionManager manager];
    [Manager POST:ARTSCOME_INT parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"%@",crashReport.errFile);
        [formData appendPartWithFileData:crashReport.errFile name:kTxtFile fileName:@"exception.txt" mimeType:FILE_MIME_TYPE_FOR_TXT];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
            NSLog(@"上传成功");
            //上传成功以后将文件删除
            [crashReport removeCrashFolderIfNotExist];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

#pragma mark - Advertisement Menthod
-(void)loadAdvertisementMenthod{
    if ([AW_LoadAdvertisementImage isShouldDisplayAd]) {
        
        UIImage * tmpImage = ResizableImageDataForMode([AW_LoadAdvertisementImage getAdImage], 8, 8, 8, 8, UIImageResizingModeStretch);
        self.adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.adButton.frame = [UIScreen mainScreen].bounds;
        [self.adButton setBackgroundImage:tmpImage forState:UIControlStateNormal];
        self.adButton.adjustsImageWhenHighlighted = NO;
        
        [self.view addSubview:self.adButton];
        //为按钮添加点击事件
        self.adButton.userInteractionEnabled = YES;
        [self.adButton addTarget:self action:@selector(clickAdvertisement) forControlEvents:UIControlEventTouchUpInside];
        [self performSelector:@selector(dissMissMenthod) withObject:nil afterDelay:3];
        
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
    }else{
        //广告页消失后再请求
        [AW_LoadAdvertisementImage requestAdvertisementImage];
    }
}

-(void)dissMissMenthod{
    [UIView animateWithDuration:3 animations:^{
        self.adButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        [UIView animateWithDuration:0 animations:^{
            self.adButton.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.adButton removeFromSuperview];
            //广告页消失后再请求(防止图片与id混乱)
            [AW_LoadAdvertisementImage requestAdvertisementImage];
        }];
    }];
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setChildView];
    self.delegate = self;
    //发送奔溃日志
    [self sendCrashInfo];
    //加载广告图
    [self loadAdvertisementMenthod];
}

// 设置TabBar图片和字体颜色
-(void)setChildView{
    NSArray *items = self.tabBar.items;
    UITabBarItem *marketItem = items[0];
    marketItem.tag = 1;
    marketItem.image = [[UIImage imageNamed:@"市集-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    marketItem.selectedImage = [[UIImage imageNamed:@"市集-绿"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *artSquareItem = items[1];
    artSquareItem.tag = 2;
    artSquareItem.image = [[UIImage imageNamed:@"圈子-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    artSquareItem.selectedImage = [[UIImage imageNamed:@"圈子-绿"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *messageItem = items[2];
    messageItem.tag = 3;
    messageItem.image = [[UIImage imageNamed:@"消息-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageItem.selectedImage = [[UIImage imageNamed:@"消息-绿"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *mineItem = items[3];
    mineItem.tag = 4;
    mineItem.image = [[UIImage imageNamed:@"我的-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineItem.selectedImage = [[UIImage imageNamed:@"我的-绿"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //改变tabBar 上title的颜色 和 字体大小
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x757575), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x71c930), NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClicked Menthod
-(void)clickAdvertisement{
    self.markNumber = @"1";
    self.tmpString = @"1";
    
    NSString * type = [[NSUserDefaults standardUserDefaults]objectForKey:@"type"];
    NSLog(@"%@",type);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"adContent"]);
    if ([type intValue] == 1) {
        
        AW_AdvertisementController * controller = [[AW_AdvertisementController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.content = [[NSUserDefaults standardUserDefaults]objectForKey:@"adContent"];
        UINavigationController * currentNavigationController = (UINavigationController*)self.viewControllers[0];
        [currentNavigationController pushViewController:controller animated:YES];
    }else if ([type intValue] == 2){
       
            NSDictionary * dict = @{@"no":[[NSUserDefaults standardUserDefaults]objectForKey:@"adContent"]};
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * artDict = @{@"param":@"getCommodityDetailByNo",@"jsonParam":str};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:artDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                NSDictionary * commidityDict = [responseObject[@"info"]valueForKey:@"commodity"];
                if ([responseObject[@"code"]intValue] == 0) {
                    NSString * commidity_id = commidityDict[@"id"];
                    AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.detailDataSource.commidity_id = commidity_id;
                    UINavigationController * currentNavigationController = (UINavigationController*)self.viewControllers[0];
                    [currentNavigationController pushViewController:controller animated:YES];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"%@",[error localizedDescription]);
            }];

    }else if ([type intValue] == 3){
        
            NSDictionary * dic = @{@"no":[[NSUserDefaults standardUserDefaults]objectForKey:@"adContent"]};
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:NULL];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * storeDict = @{@"param":@"othersInfoByShopNo",@"jsonParam":str};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:storeDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                NSDictionary * infoDict = responseObject[@"info"];
                if ([responseObject[@"code"]intValue] == 0) {
                    AW_MyDetailViewController * detailController = [[AW_MyDetailViewController alloc]init];
                    detailController.markNumber = self.markNumber;
                    detailController.hidesBottomBarWhenPushed = YES;
                    
                    detailController.person_id =  infoDict[@"id"];
                    detailController.shop_id = infoDict[@"shop_id"];
                    detailController.shop_state = infoDict[@"shop_state"];
                    detailController.productionDataSource.person_id = infoDict[@"id"];
                    detailController.attentionDataSource.person_id = infoDict[@"id"];
                    detailController.fansDataSource.person_id = infoDict[@"id"];
                    detailController.dynamicDataSource.person_id = infoDict[@"id"];
                    UINavigationController * currentNavigationController = (UINavigationController*)self.viewControllers[0];
                    [currentNavigationController pushViewController:detailController animated:YES];
                    
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"%@",[error localizedDescription]);
            }];
            
        }

}

#pragma mark - UITabBarControllerDelegate Menthod

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"%ld",viewController.tabBarItem.tag);

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    UINavigationController * currentNavigationController = (UINavigationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
    
    NSLog(@"%ld",tabBarController.selectedIndex);
    NSLog(@"%@",currentNavigationController);
     if (viewController.tabBarItem.tag == 4 || viewController.tabBarItem.tag == 3) {
     
     //判断用户的登陆状态(如果没有登陆就跳转到登陆界面)
     NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
     NSString * nameString = [userDefault objectForKey:@"name"];
     if (!nameString) {
     //如果是没有登录状态就跳转到登陆界面
     DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
     AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:self options:nil][1];
     contentView.bounds = Rect(0, 0, 272, 130);
     alertView.contentView = contentView;
     [alertView showWithoutAnimation];
     //点击确定或取消按钮的回调(弹出视图)
     contentView.didClickedBtn = ^(NSInteger index){
     if (index == 1) {
     AW_LoginInViewController * controller = [[AW_LoginInViewController alloc]init];
     controller.hidesBottomBarWhenPushed = YES;
     controller.navigationController.navigationBar.hidden = NO;
     [currentNavigationController pushViewController:controller animated:YES];
     }else if(index == 2){
           NSLog(@"点击了取消按钮。。");
        }
     };
     return NO;
     }else{
     //如果是登陆状态就跳转到我的详情界面
     return YES;
     }
     }else{
     return YES;
     }
}

@end
