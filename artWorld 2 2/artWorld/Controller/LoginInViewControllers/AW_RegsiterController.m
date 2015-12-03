//
//  AW_RegsiterController.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/21.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_RegsiterController.h"
#import "AW_Constants.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AW_SelectPreferenceController.h"//选择偏好控制器
#import <SMS_SDK/SMS_SDK.h>
#import "AW_MyPreferenceModal.h"//偏好modal

@interface AW_RegsiterController ()<AW_SelectPreferenceControllerDelegate>

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

@implementation AW_RegsiterController

-(NSTimer*)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(NSMutableString*)hobbyIdString{
    if (!_hobbyIdString) {
        _hobbyIdString = [[NSMutableString alloc]init];
    }
    return _hobbyIdString;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    //设置边框颜色
    UIImage * tmpImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    tmpImage = ResizableImageDataForMode(tmpImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    //设置边框颜色
    [self.background setBackground:tmpImage];
    [self.background2 setBackground:tmpImage];
    [self.background3 setBackground:tmpImage];
    [self.background4 setBackground:tmpImage];
    [self.background5 setBackground:tmpImage];
    [self.resignBtn setBackgroundImage:tmpImage forState:UIControlStateNormal];
    
    self.sendBtn.layer.cornerRadius = 4;
    self.sendBtn.clipsToBounds = YES;
 
    [self.phoneNumber setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.VerificationNumber setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passWord setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmPwd setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.navigationItem.title = @"注册";
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

//选择偏好
- (IBAction)selectPreference:(id)sender {
    //跳到选择偏好控制器
    AW_SelectPreferenceController * selectController = [[AW_SelectPreferenceController alloc]init];
    selectController.hidesBottomBarWhenPushed = YES;
    selectController.delegate = self;
    [self.navigationController pushViewController:selectController animated:YES];
}

//点击注册按钮
- (IBAction)resignBtnClicked:(id)sender {
   
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
    }else if (self.preferenceLabel.text.length == 0){
        [self showHUDWithMessage:@"请选择则偏好"];
    }else{
     //只有都填写完全后才进行post请求
        NSDictionary *dic = @{
                              @"phone":self.phoneNumber.text,
                              @"pwd":self.passWord.text,
                              @"id":self.hobbyIdString,
                              };
        NSError *error=nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *RegisterDic = @{@"param":@"register",@"jsonParam":str};
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:RegisterDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"响应信息：%@",responseObject);
            if ([responseObject[@"code"]intValue] == 0) {
                [self showHUDWithMessage:@"注册成功"];
            }else{
                [self showHUDWithMessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",[error localizedDescription]);
        }];
    }
}

//点击发送验证码(在这判断该手机号是否已经注册过了)
- (IBAction)sendCaptchaBtnClicked:(id)sender {
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
                //发送验证码(如果该手机没有注册过)
                [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneNumber.text zone:@"86" result:^(SMS_SDKError *error) {
                    _currentSecond = 0;
                    [self.timer invalidate];
                   [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    
                }];
            }else{
                [self showHUDWithMessage:@"该手机已经注册过了"];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",[error localizedDescription]);
        }];
    }
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

#pragma mark - AW_SelectPreferenceControllerDelegate Menthod
-(void)didClickCompleteBtnWithSelectArray:(NSMutableArray *)selectArray{

    
    
    if (self.preferenceString.length > 0) {
        self.preferenceString = nil;
    }
    if (self.hobbyIdString.length > 0) {
        self.hobbyIdString = nil;
    }
    
    if (selectArray.count > 0) {
        NSMutableString * tmpString = [[NSMutableString alloc]init];
        [selectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AW_MyPreferenceModal * modal = obj;
            [tmpString appendString:modal.preferenceDes];
            [self.hobbyIdString appendString: [NSString stringWithFormat:@"%@",modal.hobby_id]];
            if (idx < selectArray.count - 1) {
                [tmpString appendString:@","];
                [self.hobbyIdString appendString:@","];
            }
        }];
        self.preferenceString = [tmpString copy];
        self.preferenceLabel.text = self.preferenceString;
        NSLog(@"%@",self.hobbyIdString);
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

@end
