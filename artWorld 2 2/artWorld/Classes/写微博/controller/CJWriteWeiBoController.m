//
//  CJWriteWeiBoController.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/17.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJWriteWeiBoController.h"
#import "IQKeyboardManager.h"
#import "CJLocationSelectController.h"
#import "CJContatc.h"
#import "MBProgressHUD+NJ.h"
#import "CJFriendsListController.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
//#import "MBProgressHUD+NJ.h"
//#import "AW_CheckPhonePersonController.h"

@interface CJWriteWeiBoController ()<CJLocationSelectControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>

//返回Btn
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;

//发送
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBtn;

//编辑微博内容
@property (weak, nonatomic) IBOutlet UITextView *weiBoText;

//请输入内容(占位) lable
@property (weak, nonatomic) IBOutlet UILabel *placeHoderLable;

//底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//地理位置选择按钮
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

//临时存储逆传得到的cell索引
@property (nonatomic,strong) NSIndexPath *indexPath;


@end

@implementation CJWriteWeiBoController

- (void)viewDidLoad {
    [super viewDidLoad];
    _weiBoText.delegate = self;
    _weiBoText.layer.borderColor = [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0] CGColor];
    _weiBoText.layer.borderWidth = 1.0;
    _weiBoText.layer.cornerRadius = 6.0;
    [_backBtn setImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [_sendBtn setTintColor:[UIColor colorWithRed:118.0/255 green:187.0/255 blue:44.0/255 alpha:1.0]];
    
    [self appconfig];
    
    //注册键盘尺寸监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (_weiBoText.text.length != 0)
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
    if (alertView.tag == 1)  //添加话题
    {
        if (buttonIndex == 1) //确认按钮
        {
            //获取alertView中输入的文字
            UITextField *textfield=[alertView textFieldAtIndex:0];
            NSString * requestStr=textfield.text;
            //生命字符串 ##
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
    else if (alertView.tag == 2)  //选择照片方式
    {
        if (buttonIndex == 1)   //手机相册选
        {
            NSLog(@"//手机相册选");
        }
        else if (buttonIndex == 2)  //呼出照相机
        {
            NSLog(@"//呼出照相机");
        }
    }
    else if (alertView.tag == 3)  // 是否继续编辑微博
    {
        if (buttonIndex == 1)  //放弃编辑微博
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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


#pragma mark - IBAction:按钮触发

//push到位置选择界面
- (IBAction)toLocationSelect:(UIButton *)sender
{
    CJLocationSelectController *lsc = [[CJLocationSelectController alloc]init];
    [self.navigationController pushViewController:lsc animated:YES];
}

//返回
- (IBAction)backBtn:(UIBarButtonItem *)sender
{
    if (_weiBoText.text.length == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"放弃发微博吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 3;
        [alertView show];
    }
}

//发表Btn
- (IBAction)publishBtn:(UIBarButtonItem *)sender
{
    //用户ID
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    
    //地址
    NSString *addStr = _addressBtn.titleLabel.text;
    
    //微博中被at的好友的id，多个id用英文逗号分隔
    
    
    //图片文件
    
    
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"content":_weiBoText.text, @"location":addStr, @"atUserIds":@"", @"fileList":@""};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"addDynamic",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {

             [MBProgressHUD showSuccess:@"发表成功"];
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

//唤出相册或照相机
- (IBAction)callImage:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"从手机相册选择", @"照相机",nil];
    alert.tag = 2;
    [alert show];
}

//设置话题
- (IBAction)setTopic:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入话题内容" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    
    // 弹出UIAlertView
    [alert show];
}

//@联系人列表
- (IBAction)toContacts:(UIButton *)sender
{
    CJFriendsListController * friendsList = [[CJFriendsListController alloc]init];
    [self.navigationController pushViewController:friendsList animated:YES];
    
}

//点击空白处撤销键盘
- (IBAction)resignResponder:(UIControl *)sender
{
    [self.view endEditing:YES];
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
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, translationY);
        self.addressBtn.transform = CGAffineTransformMakeTranslation(0, translationY);
    } completion:^(BOOL finished) {

    }];
}

-(void)appconfig
{
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}


#pragma mark - prepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CJLocationSelectController *locationSC = (CJLocationSelectController *)segue.destinationViewController;
    locationSC.delegate = self;
    
    locationSC.lastIndexPath = _indexPath;
}

@end
