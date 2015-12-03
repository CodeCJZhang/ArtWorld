//
//  AW_SystermSettingController.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SystermSettingController.h"
#import "AW_Constants.h"
#import "AW_NewsRemindController.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "AW_ArtsComeViewController.h"
#import "IMB_AlertView.h"
#import "NSFileManager+Utils.h"
#import "DeliveryAlertView.h"
#import "AW_DeleteAlertMessage.h"
#import "ChatViewController.h"
#import "AW_ShareView.h"//分享视图
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface AW_SystermSettingController ()<UIActionSheetDelegate>

/**
 *  @author cao, 15-10-25 12:10:36
 *
 *  分享视图
 */
@property(nonatomic,strong)AW_ShareView * shareView;
/**
 *  @author cao, 15-11-09 23:11:09
 *
 *  当前版本号
 */
@property(nonatomic,copy)NSString * freshVersion;
/**
 *  @author cao, 15-11-20 09:11:06
 *
 *  下分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;
/**
 *  @author cao, 15-11-20 14:11:13
 *
 *  缓存大小
 */
@property (weak, nonatomic) IBOutlet UILabel *caheSize;
/**
 *  @author cao, 15-11-20 14:11:01
 *
 *  版本号
 */
@property (weak, nonatomic) IBOutlet UILabel *verson;

/**
 *  @author cao, 15-10-25 12:10:28
 *
 *  背景视图
 */
@property(nonatomic,strong)UIControl * backgroungViw;

@end

@implementation AW_SystermSettingController

-(UIControl*)backgroungViw{
    if (!_backgroungViw) {
        _backgroungViw = [[UIControl alloc]init];
        [_backgroungViw addTarget:self action:@selector(touchBackgroungView) forControlEvents:UIControlEventTouchUpInside];
        _backgroungViw.backgroundColor = [UIColor blackColor];
        _backgroungViw.alpha = 0.4;
        _backgroungViw.hidden = YES;
    }
    return _backgroungViw;
}

#pragma mark - Share Menthod
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

#pragma mark - Share Menthod
-(void)SinaShareMenthod{
    id<ISSCAttachment> tmpimage;
    tmpimage = [ShareSDK imageWithUrl:@"http://www.artscome.com:8080/upload/ic_launche.png"];
NSString *contentString = @"热爱生活,热爱艺术";
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[contentString stringByAppendingString:@"http://www.artscome.com"]
                                       defaultContent:@"热爱生活，热爱艺术"
                                                image:tmpimage
                                                title:contentString
                                                  url:@"http://www.artscome.com"
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
    id<ISSCAttachment> tmpimage;
    tmpimage = [ShareSDK imageWithUrl:@"http://www.artscome.com:8080/upload/ic_launche.png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:nil
                                       defaultContent:@"热爱生活，热爱艺术"
                                                image:tmpimage
                                                title:@"热爱生活，热爱艺术"
                                                  url:@"http://www.artscome.com"
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
    id<ISSCAttachment> tmpimage;
    tmpimage = [ShareSDK imageWithUrl:@"http://www.artscome.com:8080/upload/ic_launche.png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:nil
                                       defaultContent:@"热爱生活，热爱艺术"
                                                image:tmpimage
                                                title:@"热爱生活，热爱艺术"
                                                  url:@"http://www.artscome.com"
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

-(void)addShareMenthod{
    //============================添加share视图=========================
    self.shareView.frame = CGRectMake(0, kSCREEN_HEIGHT+20, kSCREEN_WIDTH, 166);
    [self.navigationController.view addSubview:self.shareView];
__weak typeof(self) weakSelf = self;
    //点击shareView上的按钮的回调
    self.shareView.didClickedBtn = ^ (NSInteger index){
        if (index == 1){
            [weakSelf SinaShareMenthod];
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.backgroungViw.alpha = 0;
                weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT+20, kSCREEN_WIDTH, 166);
            } completion:^(BOOL finished) {
                weakSelf.backgroungViw.hidden = YES;
            }];
        }else if (index == 2){
            [weakSelf QQShareMenthod];
            
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.backgroungViw.alpha = 0;
                weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT+20 , kSCREEN_WIDTH, 166);
            } completion:^(BOOL finished) {
                weakSelf.backgroungViw.hidden = YES;
            }];
        }else if (index == 3){
            [weakSelf WeChatShareMenthod];
            
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.backgroungViw.alpha = 0;
                weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT+20, kSCREEN_WIDTH, 166);
            } completion:^(BOOL finished) {
                weakSelf.backgroungViw.hidden = YES;
            }];
        }else if (index == 5){
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.backgroungViw.alpha = 0;
                weakSelf.shareView.frame = Rect(0, kSCREEN_HEIGHT+20 , kSCREEN_WIDTH, 166);
            } completion:^(BOOL finished) {
                weakSelf.backgroungViw.hidden = YES;
            }];
        }
    };
}

#pragma mark - private Menthod
-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineheight = 1.0f/([UIScreen mainScreen].scale);
        _bottomLayer.frame = Rect(0,40, kSCREEN_WIDTH, lineheight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}

#pragma mark - LifCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.verson.text = app_Version;
    self.tableView.backgroundColor = HexRGB(0xf6f7f8);
    self.tableView.bounces = NO;
    self.tableView.separatorColor = HexRGB(0xe6e6e6);
    //获取缓存大小
    NSString * cach = [NSFileManager cachesDirectory];
    NSLog(@"%.2fM",[self folderSizeAtPath:cach]);
    self.caheSize.text = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:cach]];
    /**
     设置左侧返回按钮
     */
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    self.backgroungViw.frame = Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT+20);
    [self.navigationController.view addSubview:self.backgroungViw];
    //分享
    [self addShareMenthod];
    
}


#pragma mark - countCache Menthod
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器／／／／//
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSLog(@"fileName ==== %@",fileName);
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    NSLog(@"folderSize ==== %lld",folderSize);
    return folderSize/(1024.0*1024.0);
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ButtonClick Menthod
/**
 *  @author cao, 15-08-27 21:08:37
 *
 *  返回上一级界面
 */
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - UITableViewDelegate Menthod
//让分割线显示完全
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AW_NewsRemindController * newsController = [[AW_NewsRemindController alloc]init];
        newsController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsController animated:YES];
    }
    if (indexPath.row == 2) {
        self.backgroungViw.alpha = 0;
        self.backgroungViw.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
          self.backgroungViw.alpha = 0.4;
        self.shareView.frame = Rect(0, kSCREEN_HEIGHT - 166 + 20, kSCREEN_WIDTH, 166);
        } completion:^(BOOL finished) {
            
        }];
    }
    if (indexPath.row == 3) {
        [SVProgressHUD showWithStatus:@"正在清理缓存"];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString * path = [NSFileManager cachesDirectory];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
            }
        [SVProgressHUD dismiss];
        [self showHUDWithMessage:@"清理完成"];
        self.caheSize.text = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:path]];
    }
    if (indexPath.row == 7) {
        AW_ArtsComeViewController * artsCome = [[AW_ArtsComeViewController alloc]init];
        artsCome.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:artsCome animated:YES];
    }
    if (indexPath.row == 4) {
        [self checkVersionUpdate];
    }
    if (indexPath.row == 5) {
        //跳转到联系客服界面
        ChatViewController *chatView = [[ChatViewController alloc]initWithChatter:@"01056228639" conversationType:eConversationTypeChat];
        chatView.navigationItem.title = @"客服";
        chatView.shopIM_phone = @"01056228639";
        chatView.shoper_id = @"";
        chatView.shop_id = @"";
        [self.navigationController pushViewController:chatView animated:YES];
    }
    if (indexPath.row == 6) {
        DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
        AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:self options:nil][3];
        contentView.bounds = Rect(0, 0, 272, 130);
        alertView.contentView = contentView;
        [alertView showWithoutAnimation];
        //点击确定或取消按钮的回调(弹出视图)
        contentView.didClickedBtn = ^(NSInteger index){
            if (index == 1) {
                //调用打电话功能
                UIWebView*callWebview =[[UIWebView alloc] init];
                NSURL *telURL =[NSURL URLWithString:@"tel:01056228639"];
                [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                //记得添加到view上
                [self.view addSubview:callWebview];
            }
        };
    }
}

-(void)showMessage{
    [self showHUDWithMessage:@"清理完成"];
}
#pragma mark - VersionUpdate Menthod
- (void)checkVersionUpdate{
    self.freshVersion = @"1.0.2";
    NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
    NSString *currentVersion = infoDict[@"CFBundleShortVersionString"];
    if ([self.freshVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
        IMB_AlertView * alert = [[IMB_AlertView alloc]initWithTitle:@"版本更新" message:@"发现新版本" select:^(NSInteger index) {
            if (index == 0) {
                
            }else if (index == 1){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/wechat/id414478124?mt=8&uo=4"]];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        [alert show];
    }else{
        [self showHUDWithMessage:@"已经是最新版本"];
    }
}

#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    UISwitch * btn = sender;
    //btn.on = ! btn.on;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"patternState"]) {
         [user removeObjectForKey:@"patternState"];
        if(btn.on) {
            [user setValue:@"yes" forKey:@"patternState"];
        }else {
            [user setValue:@"no" forKey:@"patternState"];
        }
    }else{
        if(btn.on) {
            [user setValue:@"yes" forKey:@"patternState"];
        }else {
            [user setValue:@"no" forKey:@"patternState"];
        }
    }
}

-(void)touchBackgroungView{
    [UIView animateWithDuration: 0.4 animations:^{
        self.backgroungViw.alpha = 0;
        self.shareView.frame = Rect(0, kSCREEN_HEIGHT+20, kSCREEN_WIDTH, 166);
    } completion:^(BOOL finished) {
        self.backgroungViw.hidden = YES;
    }];
}

#pragma mark - UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0: // 马上更新
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/wechat/id414478124?mt=8&uo=4"]];
            break;
        default:
            break;
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

@end
