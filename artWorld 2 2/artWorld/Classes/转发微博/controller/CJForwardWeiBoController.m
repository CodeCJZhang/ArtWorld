//
//  CJForwardWeiBoController.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJForwardWeiBoController.h"
#import "IQKeyboardManager.h"
#import "MBProgressHUD+NJ.h"
#import "CJLocationSelectController.h"
#import "CJContatc.h"
#import "CJFriendsListController.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"

@interface CJForwardWeiBoController ()<CJLocationSelectControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>

//取消Btn
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;

//确定Btn
@property (weak, nonatomic) IBOutlet UIBarButtonItem *okBtn;

//微博文本
@property (weak, nonatomic) IBOutlet UITextView *weiBoText;

//占位文字
@property (weak, nonatomic) IBOutlet UILabel *holderLable;

//显示位置Btn
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

//转发微博的父视图
@property (weak, nonatomic) IBOutlet UIView *faOfWBView;

//底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//原文图片
@property (weak, nonatomic) IBOutlet UIImageView *ori_image;

//@朋友文本
@property (weak, nonatomic) IBOutlet UILabel *atFriend;

//原微博
@property (weak, nonatomic) IBOutlet UILabel *ori_weiBo;

//@朋友文本到图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *atToImage;

//@朋友文本到左边间隙
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *atToPadding;

//临时存储逆传得到的cell索引
@property (nonatomic,strong) NSIndexPath *indexPath;

@end

@implementation CJForwardWeiBoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self appconfig];
    
    [_cancelBtn setTintColor:[UIColor colorWithRed:118.0/255 green:187.0/255 blue:44.0/255 alpha:1.0]];
    [_okBtn setTintColor:[UIColor colorWithRed:118.0/255 green:187.0/255 blue:44.0/255 alpha:1.0]];
    
    _weiBoText.layer.cornerRadius = 5.0;
    _weiBoText.layer.borderWidth = 1.0;
    _weiBoText.layer.borderColor = [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0] CGColor];
    
    _addressBtn.layer.cornerRadius = 5.0;
    _addressBtn.layer.borderWidth = 1.0;
    _addressBtn.layer.borderColor = [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0] CGColor];
    
    _weiBoText.delegate = self;
    //注册键盘尺寸监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction Btn触发

//取消Btn
- (IBAction)cancelBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//确认Btn
- (IBAction)confirmBtn:(id)sender
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    //接口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"id":@"", @"content":@"", @"location":@"", @"atUserIds":@"", @"dynamic_user_id":@"", @"forward_id":@""};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"addDynamicForward",@"token":@"",@"jsonParam":str};
    NSLog(@"str = %@",str);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             NSLog(@"请求结果:%@",responseObject);
             [MBProgressHUD showSuccess:@"转发成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

//收回键盘
- (IBAction)resignResponder:(UIControl *)sender
{
    [self.view endEditing:YES];
}

//添加地址
- (IBAction)addAddress:(UIButton *)sender {
    CJLocationSelectController *lc = [[CJLocationSelectController alloc]init];
    lc.navigationItem.title = @"位置选择";
    [self.navigationController pushViewController:lc animated:YES];
}

//添加话题
- (IBAction)addTopic:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入话题内容" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    
    // 弹出UIAlertView
    [alert show];
}

//@2联系人列表
- (IBAction)toContacts:(UIButton *)sender {
    CJFriendsListController *fc = [[CJFriendsListController alloc]init];
    [self.navigationController pushViewController:fc animated:YES];
}


#pragma mark - CJLocationSelectControllerDelegate

-(void)locationSelectControllerAddAddress:(CJLocationSelectController *)locationSelectController contatc:(CJContatc *)contatc
{
    _indexPath = contatc.indexPath;
    if (contatc.address == nil)
    {
        [_addressBtn setTitle:@"显示位置" forState:UIControlStateNormal];
    }else{
        [_addressBtn setTitle:contatc.address forState:UIControlStateNormal];
    }
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (_weiBoText.text.length != 0)
    {
        _holderLable.hidden = YES;
    }
    else
    {
        _holderLable.hidden = NO;
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
        [weibo appendString:[NSString stringWithFormat:@"%@",_weiBoText.text]];
        //在微博正文中光标位置插入 话题 内容
        NSInteger location =_weiBoText.selectedRange.location;
        NSRange range = _weiBoText.selectedRange;
        [weibo insertString:topic atIndex:location];
        //添加话题后的微博正文返回给微博
        _weiBoText.text = [weibo copy];
        
        //空话题时 光标位置
        NSInteger location1 = range.location;
        range.location = location1 + 1;
        if (requestStr.length == 0)
        {
            [_weiBoText setSelectedRange:range];
        }
        [self textViewDidChange:_weiBoText];
    }
}


#pragma mark - 键盘处理

//监听键盘
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
