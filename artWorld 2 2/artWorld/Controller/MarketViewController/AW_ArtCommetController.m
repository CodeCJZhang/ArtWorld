//
//  AW_ArtCommetController.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/29.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ArtCommetController.h"

@interface AW_ArtCommetController ()
/**
 *  @author cao, 15-10-29 17:10:02
 *
 *  评论列表
 */
@property(nonatomic,strong)UITableView * commentTable;

@end

@implementation AW_ArtCommetController

#pragma mark - Init Menthod
-(UITableView*)commentTable{
    if (!_commentTable) {
        _commentTable = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT)];
        _commentTable.delegate = self.commentDataSource;
        _commentTable.dataSource = self.commentDataSource;
        _commentTable.tableFooterView = [[UIView alloc]init];
        _commentTable.separatorColor = HexRGB(0xe6e6e6);
    }
    return _commentTable;
}

-(AW_ArtCommentDataSource*)commentDataSource{
    if (!_commentDataSource) {
        _commentDataSource = [[AW_ArtCommentDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
        _commentDataSource.tableView = self.commentTable;
        _commentDataSource.hasLoadMoreFooter = YES;
        _commentDataSource.hasRefreshHeader = YES;
    }
    return _commentDataSource;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.commentTable];
    self.commentDataSource.currentPage = @"1";
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.commentTable.backgroundColor = [UIColor clearColor];
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"评论详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ButtonClick Menthod
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
