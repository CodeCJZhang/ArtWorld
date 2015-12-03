//
//  CJFriendsListController.m
//  artWorld
//
//  Created by 张晓旭 on 15/10/30.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "CJFriendsListController.h"
#import "MBProgressHUD+NJ.h"
#import "CJFriendCell.h"
#import "IMB_Macro.h"
#import "AW_Constants.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#define padding 8
#define viewW self.view.frame.size.width
#define viewH self.view.frame.size.height

@interface CJFriendsListController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    NSArray *friendArr;
}

@property (nonatomic,strong) UITableView *friendsList;

@property (nonatomic,strong) UISearchBar *seaBar;

@property (nonatomic,strong) CJFriendCell *friCell;

@end

@implementation CJFriendsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"好友列表";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成"  style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick)];
    [doneBtn setTintColor:[UIColor colorWithRed:118.0/255 green:187.0/255 blue:44.0/255 alpha:1.0]];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    [self viewDesign];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self request];
}

-(NSMutableArray *)friends
{
    if (!_friends)
    {
        _friends = [NSMutableArray array];
    }
    return _friends;
}

- (void)request {
    //接口数据：
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    NSDictionary *fieldDic = @{@"userId":user_id};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"getAttAllByUser",@"token":@"",@"jsonParam":str};
    NSLog(@"str = %@",str);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             friendArr = [responseObject valueForKey:@"info"];
             [self.friendsList reloadData];
             NSLog(@"请求结果:%@",responseObject);
             NSLog(@"friendArr = %@", friendArr);
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

#pragma mark - 界面搭建

-(void)viewDesign
{
    CGFloat fixedNum = 44;
    //搜索框
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, viewW - fixedNum, fixedNum)];
    searchBar.placeholder = @"请输入关键字";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _seaBar = searchBar;
    [self.view addSubview:searchBar];
    
    //搜索按钮
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchBar.frame), 64, fixedNum, fixedNum)];
    [searchBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    //好友列表
    CGFloat friendsListY = CGRectGetMaxY(searchBar.frame);
    _friendsList = [[UITableView alloc]initWithFrame:CGRectMake(0, friendsListY, viewW, viewH - friendsListY) style:UITableViewStylePlain];
    _friendsList.tableFooterView = [[UIView alloc]init];
    _friendsList.delegate = self;
    _friendsList.dataSource = self;
    [self.view addSubview:_friendsList];
}


#pragma mark - Btn click

//返回Btn
-(void)backBtnClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"放弃@好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

//完成Btn
-(void)doneBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//搜索Btn
-(void)searchBtnClick
{
    if (_seaBar.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入关键字"];
    }
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"friendArr.count = %ld",friendArr.count);
    return friendArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"friendcell";
    CJFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CJFriendCell" owner:nil options:nil] firstObject];
    }
    
    //头像
    NSString *iconStr = [friendArr[indexPath.row] valueForKey:@"head_img"];
    NSURL *url = [NSURL URLWithString:iconStr];
    [cell.icon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
    
    //昵称
    cell.name.text = [friendArr[indexPath.row] valueForKey:@"nickname"];
    
    _friCell = cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJFriendCell *selectcell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectcell.selectImg.hidden == YES)
    {
        selectcell.tag = indexPath.row;
        [self.friends addObject:selectcell.name];
        selectcell.selectImg.hidden = NO;
    }
    else
    {
        for (NSMutableArray *arr in self.friends)
        {
           
        }
        [self.friends removeObjectAtIndex:0];
        selectcell.selectImg.hidden = YES;
    }
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //让键盘失去第一响应者
    [self.view endEditing:YES];
}

@end
