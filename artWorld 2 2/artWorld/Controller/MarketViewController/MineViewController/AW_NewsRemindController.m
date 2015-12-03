//
//  AW_NewsRemindController.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/28.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_NewsRemindController.h"
#import "AW_NewsRemindDataSource.h"

@interface AW_NewsRemindController ()
/**
 *  @author cao, 15-08-28 18:08:42
 *
 *  消息提醒数据源
 */
@property(nonatomic,strong)AW_NewsRemindDataSource * dataSource;
/**
 *  @author cao, 15-08-28 18:08:53
 *
 *  消息提醒列表
 */
@property(nonatomic,strong)UITableView * newsRemindTableView;

@end

@implementation AW_NewsRemindController

#pragma mark - Private Menthod
-(AW_NewsRemindDataSource*)dataSource{
    if (!_dataSource) {
        _dataSource = [[AW_NewsRemindDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _dataSource;
}

-(UITableView*)newsRemindTableView{
    if (!_newsRemindTableView) {
        _newsRemindTableView = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT)];
    }
    return _newsRemindTableView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    //获取数据
    [self.dataSource getData];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.newsRemindTableView];
    self.newsRemindTableView.backgroundColor = HexRGB(0xf6f7f8);
    self.newsRemindTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsRemindTableView.bounces = NO;
    self.newsRemindTableView.tableFooterView = [[UIView alloc]init];
    self.newsRemindTableView.dataSource = self.dataSource;
    self.newsRemindTableView.delegate = self.dataSource;
    self.dataSource.tableView  = self.newsRemindTableView;
    self.dataSource.hasLoadMoreFooter = NO;
    self.dataSource.hasRefreshHeader = NO;
    
    self.navigationItem.title = @"消息提醒";
    /**
     设置左侧返回按钮
     */
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClick Menthod
/**
 *  @author cao, 15-08-27 21:08:37
 *
 *  返回上一级界面
 */
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
