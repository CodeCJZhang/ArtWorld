//
//  AW_OtherInfoController.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_OtherInfoController.h"
#import "UIImage+IMB.h"

@interface AW_OtherInfoController ()

/**
 *  @author cao, 15-11-23 14:11:09
 *
 *  信息列表
 */
@property(nonatomic,strong)UITableView * infoTableView;

@end

@implementation AW_OtherInfoController

#pragma mark - Private Menthod
-(UITableView*)infoTableView{
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc]initWithFrame:Rect(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT - kNAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _infoTableView.backgroundColor = [UIColor clearColor];
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _infoTableView;
}

-(AW_OtherInfoDataSource*)infoDataSource{
    if (!_infoDataSource) {
        _infoDataSource = [[AW_OtherInfoDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _infoDataSource;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.infoTableView];
    self.infoTableView.delegate = self.infoDataSource;
    self.infoTableView.dataSource = self.infoDataSource;
    self.infoDataSource.hasLoadMoreFooter = NO;
    self.infoDataSource.hasRefreshHeader = NO;
    self.infoDataSource.tableView = self.infoTableView;
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //取消回弹效果
    self.infoTableView.bounces = NO;
    self.navigationItem.title = @"个人资料";
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    // 设置设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x71c930);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    [self.navigationController.navigationBar setShadowImage:shadowImage];
    //获取数据
    [self.infoDataSource getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClicked Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
