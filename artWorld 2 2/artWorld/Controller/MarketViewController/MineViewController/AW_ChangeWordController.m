//
//  AW_ChangeWordController.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ChangeWordController.h"
#import "AW_Constants.h"
#import "UIImage+IMB.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"

@interface AW_ChangeWordController ()<UITextFieldDelegate>

/**
 *  @author cao, 15-11-09 22:11:52
 *
 *  旧密码背景
 */
@property (weak, nonatomic) IBOutlet UITextField *oldWordBackground;
/**
 *  @author cao, 15-11-09 22:11:06
 *
 *  旧的密码
 */
@property (weak, nonatomic) IBOutlet UITextField *oldWorld;
/**
 *  @author cao, 15-09-14 10:09:20
 *
 *  新密码
 */
@property (weak, nonatomic) IBOutlet UITextField *freshPassWord;
/**
 *  @author cao, 15-09-14 10:09:29
 *
 *  确认新密码
 */
@property (weak, nonatomic) IBOutlet UITextField *confirmFreshWord;
/**
 *  @author cao, 15-09-14 10:09:41
 *
 *  确认修改密码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
/**
 *  @author cao, 15-10-16 18:10:58
 *
 *  新密码
 */
@property (weak, nonatomic) IBOutlet UITextField *nowFreshWord;
/**
 *  @author cao, 15-10-16 18:10:00
 *
 *  确认新密码
 */
@property (weak, nonatomic) IBOutlet UITextField *nowConfirmWord;

@end

@implementation AW_ChangeWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x71c930);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    [self.navigationController.navigationBar setShadowImage:shadowImage];
        self.confirmButton.tintColor = HexRGB(0x88c244);
        [self.confirmButton setBackgroundColor:[UIColor whiteColor]];
        self.confirmButton.showsTouchWhenHighlighted = YES;
    
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //设置颜色
    UIImage * tmpImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    tmpImage = ResizableImageDataForMode(tmpImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.oldWordBackground setBackground:tmpImage];
    [self.oldWorld setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.freshPassWord setBackground:tmpImage];
    [self.nowFreshWord setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.confirmButton setBackgroundImage:tmpImage forState:UIControlStateNormal];
    self.confirmButton.layer.cornerRadius = 4;
    self.confirmButton.clipsToBounds = YES;
    [self.confirmFreshWord setBackground:tmpImage];
    [self.nowConfirmWord setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmBtnClick:(id)sender {
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * oldMd5String = [user objectForKey:@"password"];
    if(self.oldWorld.text.length == 0){
        [self showHUDWithMessage:@"请输入旧密码"];
    }else if(![[self.oldWorld.text MD5Hash] isEqualToString:oldMd5String]){
        [self showHUDWithMessage:@"旧密码不正确"];
    }else if(self.nowFreshWord.text.length == 0) {
        [self showHUDWithMessage:@"请输入新密码"];
    }else if (self.nowConfirmWord.text.length == 0){
        [self showHUDWithMessage:@"请输入确认密码"];
    }else if (![self.nowConfirmWord.text compare:self.nowFreshWord.text] == NSOrderedSame){
        [self showHUDWithMessage:@"您输入的密码不一致"];
    }else if([self isAvailablePassword] == NO){
        [self showHUDWithMessage:@"密码格式不正确"];
    }else{
        //在这进行修改密码请求
        NSString * user_id = [user objectForKey:@"user_id"];
        NSDictionary * dict = @{
                                @"userId":user_id,
                                @"oldPassword":self.oldWorld.text,
                                @"newPassword":self.nowConfirmWord.text,
                                };
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
        NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary * changDict = @{@"param":@"updatePwd",@"jsonParam":str};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:changDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"code"]intValue] == 0) {
                //修改成功以后进行提示
                [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD dismissAfterDelay:0.5];
                [self performSelector:@selector(changeSucess) withObject:nil afterDelay:0.5];
                //修改成功以后重新登录
                [user removeObjectForKey:@"password"];
                [user setObject:[self.nowConfirmWord.text MD5Hash] forKey:@"password"];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@",[error localizedDescription]);
        }];
    }
}

-(void)changeSucess{
   [self showHUDWithMessage:@"修改成功"];
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
    return [pred evaluateWithObject:self.nowFreshWord.text];
}

@end
