//
//  AW_FrogetPasswprdController.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/21.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_FrogetPasswprdController.h"
#import "AW_Constants.h"
#import <SMS_SDK/SMS_SDK.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "ApplyViewController.h"

@interface AW_FrogetPasswprdController ()
/**
 *  @author cao, 15-11-26 11:11:12
 *
 *  设置倒计时的秒数
 */
@property(nonatomic)NSInteger currentSecond;
/**
 *  @author cao, 15-11-26 11:11:45
 *
 *  倒计时
 */
@property(nonatomic,strong)NSTimer * timer;
@end

@implementation AW_FrogetPasswprdController

-(NSTimer*)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImage * tmpImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    tmpImage = ResizableImageDataForMode(tmpImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    //设置边框颜色
    [self.background setBackground:tmpImage];
    [self.background2 setBackground:tmpImage];
    [self.background3 setBackground:tmpImage];
    [self.background4 setBackground:tmpImage];
    [self.confirmBtn setBackgroundImage:tmpImage forState:UIControlStateNormal];
    
    self.sendBtn.layer.cornerRadius = 4;
    self.sendBtn.clipsToBounds = YES;
    
    
    [self.phoneNumber setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.VerificationNumber setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passWord setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmPwd setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.navigationItem.title = @"忘记密码";
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.view.backgroundColor = HexRGB(0xf6f7f8);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TimeDown Menthod
-(void)timeDown{
    self.currentSecond--;
    NSString *title = [NSString stringWithFormat:@"%ld", self.currentSecond];
    [self.sendBtn setTitle:title forState:UIControlStateNormal];
    if (self.currentSecond < 1) {
        [_timer invalidate];
        self.sendBtn.enabled = YES;
        [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmBtnClicked:(id)sender {
    if (self.phoneNumber.text.length == 0) {
        [self showHUDWithMessage:@"手机号码不能为空"];
    }else if (self.VerificationNumber.text.length == 0){
        [self showHUDWithMessage:@"请填写验证码"];
    }else if (self.passWord.text.length == 0){
        [self showHUDWithMessage:@"请填写密码"];
    }else if (self.passWord.text.length > 0 && [self isAvailablePassword] == NO){
        [self showHUDWithMessage:@"密码格式不正确"];
    }else if (self.confirmPwd.text.length == 0){
        [self showHUDWithMessage:@"请确认密码"];
    }else if (self.confirmPwd.text.length > 0 && self.passWord.text.length >0 && ![self.confirmPwd.text isEqualToString:self.passWord.text]){
        [self showHUDWithMessage:@"前后密码不一致"];
    }else{
      //只有都填写完全后才进行post请求
        NSDictionary * dict = @{
                              @"phone":self.phoneNumber.text,
                              @"pwd":self.passWord.text,
                            };
        NSError * error = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary * forgetDict = @{@"param":@"pwdBack",@"jsonParam":string};
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:forgetDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"响应信息：%@",responseObject);
            if ([responseObject[@"code"]intValue] == 0) {
                //删除旧密码，保存新密码
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                NSString * md5String = [self.passWord.text MD5Hash];
                [user removeObjectForKey:@"password"];
                [user setValue:md5String forKey:@"password"];
                //退出环信登录
                [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                    [self hideHud];
                    if (error && error.errorCode != EMErrorServerNotLogin) {
                        [self showHint:error.description];
                    }
                    else{
                        [[ApplyViewController shareController] clear];
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                    }
                } onQueue:nil];
                //重新登录环信
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.phoneNumber.text password:self.passWord.text completion:^(NSDictionary *loginInfo, EMError *error) {
                    if (!error && loginInfo){
                        [self showHUDWithMessage:@"环信登陆成功"];
                        // 设置自动登录
                         [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                    }
                } onQueue:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",error);
        }];
    }
}

- (IBAction)sendBtnClicked:(id)sender {
    if (self.phoneNumber.text.length == 0) {
        [self showHUDWithMessage:@"手机号码不能为空"];
    }else if (self.phoneNumber.text.length > 0 && [self isAvailableTelephone] == NO){
        [self showHUDWithMessage:@"手机格式不正确"];
    }else if (self.phoneNumber.text.length > 0 && [self isAvailableTelephone] == YES){
        _currentSecond = 60;
        [self.timer fire];
        //进行判断该手机号是否已经注册过
        NSDictionary * dict = @{
                                @"phone":self.phoneNumber.text,
                                };
        NSError * error = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary * verificationDict = @{@"param":@"checkPhone",@"jsonParam":str};
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:verificationDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"响应信息：%@",responseObject);
            if ([responseObject[@"info"]integerValue]== 0) {
                NSLog(@"该手机没有注册过");
                [self showHUDWithMessage:@"该手机号还没有注册过"];
            }else{
                //发送验证码(如果该手机已经注册过了才发送验证码)
                NSInteger  index = arc4random() % 9000 + 1000;
                NSLog(@"%ld",index);
                [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneNumber.text zone:@"86" result:^(SMS_SDKError *error) {
                    _currentSecond = 0;
                    [self.timer invalidate];
                    [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    
                }];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",[error localizedDescription]);
        }];
    }
}

#pragma mark - CheckPassword Menthod
//验证密码格式是否正确
- (BOOL)isAvailablePassword{
    NSString * regex = @"^[A-Z0-9a-z]{6,18}";
    NSPredicate *  pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self.passWord.text];
}

//验证手机号格式是否正确
- (BOOL)isAvailableTelephone{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return  [regextestmobile evaluateWithObject:self.phoneNumber.text];
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

@end
