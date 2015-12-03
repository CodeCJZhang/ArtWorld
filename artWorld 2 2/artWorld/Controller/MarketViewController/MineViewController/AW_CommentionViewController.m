//
//  AW_CommentionViewController.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/28.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_CommentionViewController.h"
#import "AW_Constants.h"
#import "AFNetworking.h"

@interface AW_CommentionViewController ()
/**
 *  @author cao, 15-11-10 11:11:56
 *
 *  问题详情
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;
/**
 *  @author cao, 15-11-10 11:11:53
 *
 *  问题内容
 */
@property(nonatomic,copy)NSString * question_content;
/**
 *  @author cao, 15-11-10 11:11:32
 *
 *  问题标题
 */
@property(nonatomic,copy)NSString * question_title;
/**
 *  @author cao, 15-11-10 11:11:48
 *
 *  问题标题
 */
@property (weak, nonatomic) IBOutlet UILabel *question_Title;

@end

@implementation AW_CommentionViewController

#pragma mark - GetData Menthod
-(void)getData{
    //在这获取数据
    __weak typeof(self) weakSelf = self;
    NSDictionary * dict = @{@"id":self.question_id};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * sonDict = @{@"param":@"oftenProblemDetails",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:sonDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
    if ([responseObject[@"code"]intValue] == 0) {
        NSDictionary * questionDict = responseObject[@"info"];
        weakSelf.question_content = questionDict[@"content"];
        weakSelf.question_title = questionDict[@"title"];
      }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = HexRGB(0xf6f7f8);
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
     //添加返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"常见问题";
    //设置边框颜色
 
    self.textView.layer.borderColor =HexRGB(0xf2f2f2).CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 4;
    self.textView.clipsToBounds = YES;

    //获取数据
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.textView.text = [NSString stringWithFormat:@"%@",self.question_content];
    self.question_Title.text = [NSString stringWithFormat:@"%@",self.question_title];
}

#pragma mark - ButtonClick Menthod
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
