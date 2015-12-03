//
//  CJReplyController.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJReplyController.h"
#import "IQKeyboardManager.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "MBProgressHUD+NJ.h"
#import "CJUtilityTools.h"


@interface CJReplyController ()<UITextViewDelegate,UIAlertViewDelegate>

//取消Btn
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;

//确定Btn
@property (weak, nonatomic) IBOutlet UIBarButtonItem *okBtn;

//回复文本
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

//占位lable
@property (weak, nonatomic) IBOutlet UILabel *placeHoderLable;

//底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation CJReplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_cancelBtn setTintColor:[UIColor colorWithRed:118.0/255 green:187.0/255 blue:44.0/255 alpha:1.0]];
    [_okBtn setTintColor:[UIColor colorWithRed:118.0/255 green:187.0/255 blue:44.0/255 alpha:1.0]];
    
    _inputTextView.layer.cornerRadius = 3.0;
    _inputTextView.delegate = self;
    
    [self appconfig];
    //注册键盘尺寸监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (_inputTextView.text.length != 0)
    {
        _placeHoderLable.hidden = YES;
    } else {
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

        NSMutableString *topic = [[NSMutableString alloc]initWithCapacity:10];
        [topic setString:@"##"];

        [topic insertString:requestStr atIndex:1];

        NSMutableString *weibo = [[NSMutableString alloc]init];
        [weibo appendString:[NSString stringWithFormat:@"%@",_inputTextView.text]];

        NSInteger location =_inputTextView.selectedRange.location;
        NSRange range = _inputTextView.selectedRange;
        [weibo insertString:topic atIndex:location];

        _inputTextView.text = [weibo copy];
        
        NSInteger location1 = range.location;
        range.location = location1 + 1;
        if (requestStr.length == 0)
        {
            [_inputTextView setSelectedRange:range];
        }
        [self textViewDidChange:_inputTextView];
    }
}


#pragma mark - IBAction BtnClick

//取消
- (IBAction)cancelBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//确定btn(上传数据)
- (IBAction)okBtnClick:(UIBarButtonItem *)sender
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];

# warning 话题需处理
    NSString *content = [CJUtilityTools convertToCommonEmoticons:_inputTextView.text];
    
    NSDictionary *fieldDic = @{@"userId":user_id, @"id":_weiBo_ID, @"respond_comment_id":_respond_comment_id, @"respond_user_id":_respond_user_id, @"content":content};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"addDynamicCommentRespond",@"token":@"android",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             NSLog(@"请求结果:%@",responseObject);
             [MBProgressHUD showSuccess:@"回复成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

//TextView放弃第一响应者
- (IBAction)resignResponder {
    [self.view endEditing:YES];
}

//add话题
- (IBAction)addTopic {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入话题内容" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    [alert show];
}


#pragma mark - 键盘设置
-(void)keyboardWillChange:(NSNotification *)notification
{
    //获取键盘Y值
    NSDictionary *dict = notification.userInfo;
    CGRect keyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    
    //获取动画执行时间
    CGFloat duration = [dict[UIKeyboardAnimationCurveUserInfoKey]doubleValue];
    
    //计算要移动的距离
    CGFloat translationY = keyboardY - self.view.frame.size.height - 64;
    [UIView animateWithDuration:duration delay:0 options:7 << 16 animations:^{
        _bottomView.transform = CGAffineTransformMakeTranslation(0, translationY);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)appconfig
{
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

@end
