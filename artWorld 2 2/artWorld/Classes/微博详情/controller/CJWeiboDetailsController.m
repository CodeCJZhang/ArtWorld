//
//  CJWeiboDetailsController.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/23.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJWeiboDetailsController.h"
#import "CJWeiboDetailsCells.h"
#import "CJParameter.h"
#import "CJSendListDataSource.h"
#import "CJCommentListDataSource.h"
#import "CJPraiseDataSource.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"

#define w self.view.frame.size.width
#define h self.view.frame.size.height
#define padding 8
#define NavigationBarH 64
#define headAndFootView 30

@interface CJWeiboDetailsController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

{
    NSMutableDictionary *weibo;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong)  UISegmentedControl *headerView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UITableView *sendView;

@property (nonatomic,strong) UITableView *commentView;

@property (nonatomic,strong) UITableView *priseView;

@property (nonatomic,strong) CJSendListDataSource *sendDataSouce;

@property (nonatomic,strong) CJCommentListDataSource *commentDataSouce;

@property (nonatomic,strong) CJPraiseDataSource *praiseDataSource;

@property (nonatomic,strong) CJParameter *parameter;

@property (nonatomic,strong) CJWeiboDetailsCells *cell;

@property (nonatomic,assign) CGFloat cellH;

@end

@implementation CJWeiboDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewDesign];
    weibo = [[NSMutableDictionary alloc]init];
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"微博详情";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick2)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

-(void)backClick2
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据

-(void)getData
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"id":self.weiBo_ID};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"getDynamic",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             weibo = [responseObject valueForKey:@"info"];
             NSLog(@"weibo = %@",weibo);
             NSLog(@"请求结果:%@",responseObject);
             
             [self count4CellH];
             [self.tableView reloadData];
         }
     }
     failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"错误提示：%@",error);
     }];
}

-(void)count4CellH
{
    [weibo valueForKey:@"content"];
}

#pragma mark - 数据源初始化

-(CJSendListDataSource *)sendDataSouce
{
    if (!_sendDataSouce)
    {
        _sendDataSouce = [[CJSendListDataSource alloc]init];
    }
    return _sendDataSouce;
}

-(CJCommentListDataSource *)commentDataSouce
{
    if (!_commentDataSouce)
    {
        _commentDataSouce = [[CJCommentListDataSource alloc]init];
    }
    return _commentDataSouce;
}

-(CJPraiseDataSource *)praiseDataSource
{
    if (!_praiseDataSource)
    {
        _praiseDataSource = [[CJPraiseDataSource alloc]init];
    }
    return _praiseDataSource;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"WeiboDetails";
    _cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!_cell)
    {
        _cell = [[CJWeiboDetailsCells alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    _parameter = [[CJParameter alloc]init];
    
    _parameter.icon = [weibo valueForKey:@"head_img"];
    
    _parameter.name = [weibo valueForKey:@"nickname"];
    
    _parameter.isVIP = [[weibo valueForKey:@"authentication_state"] integerValue];
    
    _parameter.time = [weibo valueForKey:@"create_time"];
    
    _parameter.weiBo = [weibo valueForKey:@"content"];
    
    _parameter.photoes = [weibo valueForKey:@"clear_img"];
    
    _parameter.address = [weibo valueForKey:@"location"];
    
    _cell = [_cell createCellWithParameter:_parameter];
    
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cell.preservesSuperviewLayoutMargins = NO;
    _cell.separatorInset = UIEdgeInsetsZero;
    _cell.layoutMargins = UIEdgeInsetsZero;
    
    return _cell;
}

#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"_cellH = %f",_cellH);
    if (indexPath.section == 0)
    {
        return 100;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return headAndFootView;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return h - NavigationBarH - headAndFootView * 2;
    }
    return 0;
}

#pragma mark - 头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"转发:0",@"评论:0",@"赞:0",nil];
    _headerView = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _headerView.frame = CGRectMake(0, 0, w, headAndFootView);
    _headerView.tintColor = [UIColor lightGrayColor];
    _headerView.selectedSegmentIndex = 0;
    [_headerView addTarget:self action:@selector(SegSelectedClick) forControlEvents:UIControlEventValueChanged];

    return _headerView;
}

#pragma mark - 尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h - NavigationBarH - headAndFootView * 2)];
    CGFloat footViewH = footView.frame.size.height;
    footView.backgroundColor = [UIColor redColor];
    
    //尾视图中加scrollview
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, w, footViewH)];
    _scrollView.backgroundColor = [UIColor grayColor];
    _scrollView.contentSize = CGSizeMake(3 * w , 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [footView addSubview:_scrollView];
    
    //scrollView中添加三个tableview
    //转发视图
    _sendView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, w, footViewH) style:UITableViewStylePlain];
    
    self.sendDataSouce.weiBo_ID = self.weiBo_ID;
    NSLog(@"_sendDataSouce.weiBo_ID = %@",self.sendDataSouce.weiBo_ID);
    self.sendDataSouce.tableView = _sendView;
    _sendView.dataSource = self.sendDataSouce;
    _sendView.delegate = self.sendDataSouce;
    [self.sendDataSouce getData];
    
    _sendView.tableFooterView = [[UIView alloc]init];
    _sendView.bounces = NO;
    
    [_scrollView addSubview:_sendView];
    
    //评论视图
    _commentView = [[UITableView alloc]initWithFrame:CGRectMake(w, 0, w, footViewH) style:UITableViewStylePlain];
    
    self.commentDataSouce.weiBo_ID = self.weiBo_ID;
    self.commentDataSouce.tableView = _commentView;
    _commentView.dataSource = self.commentDataSouce;
    _commentView.delegate = self.commentDataSouce;
    [self.commentDataSouce getData];
    
    _commentView.tableFooterView = [[UIView alloc]init];
    _commentView.bounces = NO;
    
    [_scrollView addSubview:_commentView];
    
    //赞视图
    _priseView = [[UITableView alloc]initWithFrame:CGRectMake(w * 2, 0, w, footViewH) style:UITableViewStylePlain];
    
    self.praiseDataSource.weiBo_ID = self.weiBo_ID;
    self.praiseDataSource.tableView = _priseView;
    _priseView.delegate = self.praiseDataSource;
    _priseView.dataSource = self.praiseDataSource;
    [self.praiseDataSource getData];
    
    _priseView.tableFooterView = [[UIView alloc]init];
    _priseView.bounces = NO;
    
    [_scrollView addSubview:_priseView];
    
    
    return footView;
}


#pragma mark - 界面搭建
-(void)viewDesign
{
    //底部视图
    CGFloat bottomViewH = headAndFootView;
    CGFloat bottomViewY = h - bottomViewH;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomViewY, w, bottomViewH)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    bottomView.layer.borderWidth = 1;
    bottomView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    bottomView.layer.cornerRadius = 1;
    [self.view addSubview:bottomView];
    
    CGFloat btnW = (w - 2) / 3;
    CGFloat btnH = bottomView.frame.size.height;
    UIColor *btnTitleColor = [UIColor grayColor];
    
    //转发Btn
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitle:@"转发" forState:UIControlStateNormal];
    [sendBtn setImage:[UIImage imageNamed:@"转发"] forState:UIControlStateNormal];
    [sendBtn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [bottomView addSubview:sendBtn];
    
    //评论Btn
    UIButton *commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnW + 1, 0, btnW, btnH)];
    commentBtn.backgroundColor = [UIColor whiteColor];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"评论1"] forState:UIControlStateNormal];
    [commentBtn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [bottomView addSubview:commentBtn];
    
    //赞Btn
    UIButton *praiseBtn = [[UIButton alloc]initWithFrame:CGRectMake((btnW + 1) * 2, 0, btnW, btnH)];
    praiseBtn.backgroundColor = [UIColor whiteColor];
    [praiseBtn setTitle:@"赞" forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"赞1"] forState:UIControlStateNormal];
    [praiseBtn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [bottomView addSubview:praiseBtn];
    
    
    //微博详情视图
    CGFloat tableViewY = NavigationBarH;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableViewY, w, h - tableViewY - bottomViewH)];
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UISegmentedControl点击事件方法

-(void)SegSelectedClick
{
    if (1 == _headerView.selectedSegmentIndex) {
        [_scrollView setContentOffset:CGPointMake(w, 0) animated:YES];
    }
    else if (2 == _headerView.selectedSegmentIndex)
    {
        [_scrollView setContentOffset:CGPointMake(w * 2, 0) animated:YES];
    }
    else
    {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    _headerView.selectedSegmentIndex = page;
}

@end
