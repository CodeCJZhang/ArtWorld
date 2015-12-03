//
//  AW_OptionController.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/10.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_OptionController.h"
#import "AW_Constants.h"
#import "MBProgressHUD.h"
#import "BRPlaceholderTextView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface AW_OptionController ()
/**
 *  @author cao, 15-11-10 09:11:57
 *
 *  联系方式背景视图
 */
@property (weak, nonatomic) IBOutlet UITextField *textBackground;
/**
 *  @author cao, 15-11-10 09:11:01
 *
 *  联系方式
 */
@property (weak, nonatomic) IBOutlet UITextField *connectPhone;
/**
 *  @author cao, 15-11-10 09:11:04
 *
 *  反馈内容
 */
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *textView;
/**
 *  @author cao, 15-11-10 09:11:07
 *
 *  提交反馈按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@end

@implementation AW_OptionController

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    //改变按钮字体的颜色
    self.bottomButton.tintColor = HexRGB(0x88c244);
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    /**
     设置左侧返回按钮
     */
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"意见反馈";
    //设置边框颜色
    UIImage * tmpImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    tmpImage = ResizableImageDataForMode(tmpImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.bottomButton setBackgroundImage:tmpImage forState:UIControlStateNormal];
    //设置边框颜色
    [self.textBackground setBackground:tmpImage];
    [self.connectPhone setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //设置边框颜色
    self.textView.layer.borderColor =HexRGB(0xf2f2f2).CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 4;
    self.textView.clipsToBounds = YES;
    self.textView.placeholder = @"反馈内容";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClicked Menthod
- (IBAction)ideaResponse:(id)sender {
    if (self.connectPhone.text.length == 0) {
        [self showHUDWithMessage:@"请输入联系方式"];
    }else if (self.textView.text.length == 0){
        [self showHUDWithMessage:@"反馈意见不能为空"];
    }else if ([self isAvailableQQ] == NO && [self isAvailableTelephone] == NO){
        [self showHUDWithMessage:@"QQ或电话号码格式不正确"];
    }else{
        //在这进行反馈意见(只有都填写完全时才进行请求)
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * user_id = [user objectForKey:@"user_id"];
        NSDictionary * dict = @{
                             @"user_id":user_id,
                             @"type":@"2",
                             @"phone":self.connectPhone.text,
                             @"content":self.textView.text,
                            };
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
        NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary * optionDict = @{@"param":@"feedback",@"jsonParam":str};
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:optionDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"code"]intValue] == 0) {
                //请求成功以后提交
                [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD dismissAfterDelay:1];
                [self performSelector:@selector(responseSucess) withObject:nil afterDelay:1];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@",[error localizedDescription]);
        }];
    }
}

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)responseSucess{
    [self showHUDWithMessage:@"反馈成功"];
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
    hud.alpha = 0.9;
    hud.cornerRadius = 4.0;
    hud.yOffset = 150.f;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma mark - Check Menthod
//验证QQ格式是否正确
- (BOOL)isAvailableQQ{
    NSString * regex = @"[1-9][0-9]{4,}";
    NSPredicate *  pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self.connectPhone.text];
}

//验证手机号格式是否正确
- (BOOL)isAvailableTelephone{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return  [regextestmobile evaluateWithObject:self.connectPhone.text];
}

@end
