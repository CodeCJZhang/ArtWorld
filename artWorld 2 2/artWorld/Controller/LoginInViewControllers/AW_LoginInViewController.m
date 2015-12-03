//
//  AW_LoginInViewController.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/20.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_LoginInViewController.h"
#import "AW_Constants.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AW_RegsiterController.h"//注册界面
#import "AW_FrogetPasswprdController.h"//忘记密码界面
#import "UIImage+IMB.h"
#import "NSString+MD5.h"
#import "SVProgressHUD.h"

@interface AW_LoginInViewController ()<UINavigationControllerDelegate>
/**
 *  @author cao, 15-10-25 20:10:35
 *
 *  将用户id记录下来
 */
@property(nonatomic,copy)NSString * user_id;
@property(nonatomic,copy)NSString * shop_state;
@end

@implementation AW_LoginInViewController

#pragma mark - LifeCycle Menthod
-(void)viewDidLoad {
    [super viewDidLoad];
    //设置代理属性为自己
    self.navigationController.delegate = self;
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置边框颜色
    UIImage * tmpImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    tmpImage = ResizableImageDataForMode(tmpImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.backgroundTextField setBackground:tmpImage];
    [self.pwdBackgroung setBackground:tmpImage];
    [self.loginInBtn setBackgroundImage:tmpImage forState:UIControlStateNormal];
    [self.phoneNumber setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passWord setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.navigationItem.title = @"登陆";
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //添加右侧按钮
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:0 target:self action:@selector(resignBtnClicked)];
    rightBtn.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   UIColor * backColor = HexRGB(0xf6f7f8);
    UIImage * backImage = [UIImage imageWithColor:backColor];
    backImage = ResizableImageDataForMode(backImage, 0, 0, 1, 0,UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    //隐藏navgationbar下边的那条线
    [self.navigationController.navigationBar setShadowImage:backImage];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    // 设置设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x88c244);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    //隐藏navgationbar下边的那条线
    [self.navigationController.navigationBar setShadowImage:shadowImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)resignBtnClicked{
    AW_RegsiterController * regsiter = [[AW_RegsiterController alloc]init];
    //regsiter.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:regsiter animated:YES];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender{
    
    NSDictionary *dic = @{
                          @"phone":self.phoneNumber.text,
                          @"pwd":self.passWord.text
                          };
    NSError *error=nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *LoginDic = @{@"param":@"login",@"token":@"",@"jsonParam":str};
 
    //显示提示信息(只有都填写完整时才进行请求)
    if (self.phoneNumber.text.length == 0) {
        [self showHUDWithMessage:@"手机号不能为空"];
    }else if (self.passWord.text.length == 0){
        [self showHUDWithMessage:@"请输入密码"];
    }
    else if (self.phoneNumber.text.length > 0 && [self isAvailableTelephone]==NO){
        [self showHUDWithMessage:@"手机号码格式不正确"];
    }else if (self.passWord.text.length > 0 && [self isAvailablePassword]==NO){
        [self showHUDWithMessage:@"密码格式不正确"];
    }
    else{
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:LoginDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary * dict = responseObject;
            
            if ([dict[@"code"]intValue] == 0) {
                //登陆成功后将用户名和密码存到userDefaults
                self.user_id = [responseObject[@"info"]valueForKey:@"id"];
                 self.shop_state = [NSString stringWithFormat:@"%@",[responseObject[@"info"] valueForKey:@"shop_state"]];
                [self saveUserInfo];
                //获取app账号与密码登录环信：
                NSString *username = self.phoneNumber.text;
                NSString *password = self.passWord.text;
                
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:password completion:^(NSDictionary *loginInfo, EMError *error) {
                    if (!error && loginInfo){
                        [self showHUDWithMessage:@"环信登陆成功"];
                        // 设置自动登录(防止再次启动程序时，登录不上的情况)
                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                    }
                } onQueue:nil];
                [SVProgressHUD dismiss];
                //注册成功后返回上个界面
                [self.navigationController popViewControllerAnimated:YES];
                [self showHUDWithMessage:@"登陆成功"];
            }else if ([dict[@"code"]intValue] == 1){
                [self showHUDWithMessage:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"error:%@",[error localizedDescription]);
            [self showHUDWithMessage:@"登录失败"];
        }];
    }
}

#pragma mark - SavePassWord Menthod
-(void)saveUserInfo{
    //获取用户输入的信息
    NSString *username = self.phoneNumber.text;
    NSString *password = self.passWord.text;
    //获取userDefault单例
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * md5String = [password MD5Hash];
    NSLog(@"%@",md5String);
    //登陆成功后把用户名和密码存储到UserDefault
    [userDefault setObject:username forKey:@"name"];
    [userDefault setObject:md5String forKey:@"password"];
    [userDefault setObject:self.user_id forKey:@"user_id"];
    if ([self.shop_state isEqualToString:@"<null>"])
    {
        [userDefault setObject:@"0" forKey:@"shop_state"];
    } else {
        [userDefault setObject:self.shop_state forKey:@"shop_state"];
    }
    [userDefault synchronize];
}

#pragma mark - ShowMessage Menthod
- (void)showHUDWithMessage:(NSString*)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
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

- (IBAction)forgetPwdClicked:(id)sender {
    AW_FrogetPasswprdController * forget = [[AW_FrogetPasswprdController alloc]init];
    forget.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:forget animated:YES];
}

@end
