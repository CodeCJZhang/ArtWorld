//
//  CJCommentWeiBoController.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJCommentWeiBoController.h"
#import "IQKeyboardManager.h"
#import "MBProgressHUD+NJ.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"

@interface CJCommentWeiBoController ()<UITextViewDelegate,UIAlertViewDelegate>

//取消Btn
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;

//确定
@property (weak, nonatomic) IBOutlet UIBarButtonItem *okBtn;

//评论Text
@property (weak, nonatomic) IBOutlet UITextView *comText;

//占位文字
@property (weak, nonatomic) IBOutlet UILabel *placeHoderLable;

//转发判断Btn
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

//固定的lable
@property (weak, nonatomic) IBOutlet UILabel *fixureLable;

//底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation CJCommentWeiBoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self appconfig];

    [_cancelBtn setTintColor:[UIColor colorWithRed:118.0/255 green:187.0/255 blue:44.0/255 alpha:1.0]];
    [_okBtn setTintColor:[UIColor colorWithRed:118.0/255 green:187.0/255 blue:44.0/255 alpha:1.0]];
    
    _comText.delegate = self;
    
    _comText.layer.cornerRadius = 5.0;
    _comText.layer.borderWidth = 1.0;
    _comText.layer.borderColor = [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0] CGColor];
    
    //注册键盘尺寸监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction BtnClick

//取消Btn
- (IBAction)cancelBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//确定Btn
- (IBAction)confirmBtn:(id)sender
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    //接口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"id":@"", @"content":@"", @"dynamic_comtent":@"", @"meanwhileForward":@"", @"dynamic_user_id":@"", @"forward_id":@""};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"addDynamicComment",@"token":@"android",@"jsonParam":str};
    NSLog(@"str = %@",str);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             [MBProgressHUD showSuccess:@"评论成功"];
             [self.navigationController popViewControllerAnimated:YES];
             
             NSLog(@"请求结果:%@",responseObject);
         }
     }
     failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

//添加话题
- (IBAction)addTopic:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入话题内容" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    
    // 弹出UIAlertView
    [alert show];
}

//选中Btn
- (IBAction)selectBtn:(UIButton *)sender
{
    if (self.selectBtn.selected == YES)
    {
        self.selectBtn.selected = NO;
    }
    else
    {
        self.selectBtn.selected = YES;
    }
}

//点击空白收回键盘
- (IBAction)resignResponder:(UIControl *)sender
{
    [self.view endEditing:YES];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (_comText.text.length != 0)
    {
        _placeHoderLable.hidden = YES;
    }
    else
    {
        _placeHoderLable.hidden = NO;
    }
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) //确认按钮
    {
        //获取alertView中输入的文字
        UITextField *textfield=[alertView textFieldAtIndex:0];
        NSString * requestStr=textfield.text;
        //声明字符串 ##
        NSMutableString *topic = [[NSMutableString alloc]initWithCapacity:10];
        [topic setString:@"##"];
        //输入的文字插入进 ## 中
        [topic insertString:requestStr atIndex:1];
        //新字符串保存微博正文
        NSMutableString *weibo = [[NSMutableString alloc]init];
        [weibo appendString:[NSString stringWithFormat:@"%@",_comText.text]];
        //在微博正文中光标位置插入 话题 内容
        NSInteger location =_comText.selectedRange.location;
        NSRange range = _comText.selectedRange;
        [weibo insertString:topic atIndex:location];
        //添加话题后的微博正文返回给微博
        _comText.text = [weibo copy];
        
        //空话题时 光标位置
        NSInteger location1 = range.location;
        range.location = location1 + 1;
        if (requestStr.length == 0)
        {
            [_comText setSelectedRange:range];
        }
        [self textViewDidChange:_comText];
    }
}

#pragma mark - 键盘处理

-(void)keyboardWillChange:(NSNotification *)notification
{
    //获取键盘Y值
    NSDictionary *dict = notification.userInfo;
    CGRect keyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    
    //获取动画执行时间
    CGFloat duration = [dict[UIKeyboardAnimationCurveUserInfoKey]doubleValue];
    
    //计算要移动的距离
    CGFloat translationY = keyboardY - self.view.frame.size.height;
    [UIView animateWithDuration:duration delay:0 options:7 << 16 animations:^{
        self.selectBtn.transform = CGAffineTransformMakeTranslation(0, translationY);
        self.fixureLable.transform = CGAffineTransformMakeTranslation(0, translationY);
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, translationY);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)appconfig
{
    // 设置键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

@end
