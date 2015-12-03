//
//  ViewController.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/6.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJArtSquareViewController.h"
#import "CJSquareDataSource.h"
#import "CJFriendsDataSource.h"
#import "CJMineDataSource.h"
#import "CJForwardWeiBoController.h"
#import "CJCommentWeiBoController.h"
#import "IMB_Macro.h"
#import "MWPhotoBrowser.h"
#import "CJWeiboDetailsController.h"

//#import "AFNetworking.h"

#define w self.view.frame.size.width
#define h self.view.frame.size.height
#define padding 8

@interface CJArtSquareViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *findBtn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;

//三个tableview的父视图
@property (nonatomic,strong) UIScrollView *scrollview;

//圈子广场列表
@property (nonatomic,strong) UITableView *artTableView;

//朋友动态列表
@property (nonatomic,strong) UITableView *friTableView;

//我的动态列表
@property (nonatomic,strong) UITableView *myTableView;

//艺圈数据源
@property (nonatomic,strong) CJSquareDataSource *artDataSource;

//朋友圈数据源
@property (nonatomic,strong) CJFriendsDataSource *friDataSource;

//我的数据源
@property (nonatomic,strong) CJMineDataSource *myDataSource;

@end

@implementation CJArtSquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _findBtn.image = [[UIImage imageNamed:@"搜索"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _addBtn.image = [[UIImage imageNamed:@"加号"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self artViewDesign];
    
    [self btnClick];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源初始化

-(CJSquareDataSource *)artDataSource
{
    if (!_artDataSource)
    {
        _artDataSource = [[CJSquareDataSource alloc]init];
        __block typeof (self)weakSelf = self;
        _artDataSource.toWeiboDetails = ^(NSString *weibo_Id){
            NSLog(@"%@",weibo_Id);
        CJWeiboDetailsController *weibo = [[CJWeiboDetailsController alloc]init];
        weibo.weiBo_ID = weibo_Id;
        [weakSelf.navigationController pushViewController:weibo animated:YES];
        };
    }
    return _artDataSource;
}

-(CJFriendsDataSource *)friDataSource
{
    if (!_friDataSource)
    {
        _friDataSource = [[CJFriendsDataSource alloc]init];
        _friDataSource.vc = self;
    }
    return _friDataSource;
}

-(CJMineDataSource *)myDataSource
{
    if (!_myDataSource)
    {
        _myDataSource = [[CJMineDataSource alloc]init];
        _myDataSource.vc = self;
    }
    return _myDataSource;
}


#pragma mark - 艺圈的界面配置

- (void)artViewDesign
{
    //配置导航标签UISegmentedControl
    [self.seg addTarget:self action:@selector(SegSelectedClick) forControlEvents:UIControlEventValueChanged];
    CGFloat segMaxY = CGRectGetMaxY(_seg.frame);
    
    
    //配置scrollview
    self.scrollview = [[UIScrollView alloc]init];
    self.scrollview.contentSize = CGSizeMake(3 * w , 0);
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.bounces = NO;
    self.scrollview.delegate = self;
    self.scrollview.frame = CGRectMake(0, segMaxY, w, h - segMaxY - 49);
    [self.view addSubview:self.scrollview];
    
    
    /*
     添加三个tableview进_scrollview中，为三个tableview分别指定数据源
     */
    CGFloat scrollviewH = self.scrollview.frame.size.height;
    
    //圈子广场
    self.artTableView = [[UITableView alloc]init];
    self.artTableView.frame = CGRectMake(0 ,0, w, scrollviewH);
    [self.artTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.artDataSource.tableView = self.artTableView;
    self.artTableView.dataSource = self.artDataSource;
    self.artTableView.delegate = self.artDataSource;
    
    self.artTableView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [_scrollview addSubview:self.artTableView];
    
    //朋友动态
    self.friTableView = [[UITableView alloc]init];
    self.friTableView.frame = CGRectMake(w, 0, w, scrollviewH);
    [self.friTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.friDataSource.tableView = self.friTableView;
//    self.friTableView.dataSource = self.friDataSource;
//    self.friTableView.delegate = self.friDataSource;
    self.friTableView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [_scrollview addSubview:self.friTableView];
    
    //我的动态
    self.myTableView = [[UITableView alloc]init];
    self.myTableView.frame = CGRectMake(w * 2, 0, w, scrollviewH);
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.myDataSource.tableView = self.myTableView;
//    self.myTableView.dataSource = self.myDataSource;
//    self.myTableView.delegate = self.myDataSource;
    self.myTableView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [_scrollview addSubview:self.myTableView];
}

#pragma mark - 转发、评论Btn的点击
-(void)btnClick
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //转发微博界面
    CJForwardWeiBoController *fv = [board instantiateViewControllerWithIdentifier:@"CJForwardWeiBoNC"];
    //评论微博界面
    CJCommentWeiBoController *cv = [board instantiateViewControllerWithIdentifier:@"CJCommentWeiBoNC"];
    
    __weak typeof (self) weakself = self;
    
    //艺圈中的转发、评论按钮点击
    self.artDataSource.artBlock = ^(NSInteger index)
    {
        if (1 == index)
        {
            [weakself.navigationController pushViewController:fv animated:YES];
        }else if (2 == index)
        {
            [weakself.navigationController pushViewController:cv animated:YES];
        }
    };
    //朋友圈中的转发、评论按钮点击
    self.friDataSource.friBlock = ^(NSInteger index)
    {
        if (1 == index)
        {
            [weakself.navigationController pushViewController:fv animated:YES];
        }else if (2 == index)
        {
            [weakself.navigationController pushViewController:cv animated:YES];
        }
    };
    //我的动态中的转发、评论按钮点击
    self.myDataSource.myBlock = ^(NSInteger index)
    {
        if (1 == index)
        {
            [weakself.navigationController pushViewController:fv animated:YES];
        }else if (2 == index)
        {
            [weakself.navigationController pushViewController:cv animated:YES];
        }
    };    
}


#pragma mark - UISegmentedControl点击事件方法

-(void)SegSelectedClick
{
    if (1 == self.seg.selectedSegmentIndex) {
        [self.scrollview setContentOffset:CGPointMake(w, 0) animated:YES];
    }
    else if (2 == self.seg.selectedSegmentIndex)
    {
        [self.scrollview setContentOffset:CGPointMake(w * 2, 0) animated:YES];
    }
    else
    {
        [self.scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

//设置UISegmentedControl的页码
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = _scrollview.contentOffset.x / _scrollview.frame.size.width;
    _seg.selectedSegmentIndex = page;
}


@end
