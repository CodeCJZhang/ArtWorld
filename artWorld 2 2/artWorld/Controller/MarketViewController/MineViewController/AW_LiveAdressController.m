//
//  AW_LiveAdressController.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_LiveAdressController.h"
#import "AW_LiveAdressDataSource.h"

@interface AW_LiveAdressController ()
/**
 *  @author cao, 15-09-27 10:09:14
 *
 *  所在地数据源
 */
@property(nonatomic,strong)AW_LiveAdressDataSource * liveDataSource;
/**
 *  @author cao, 15-09-27 10:09:23
 *
 *  所在地列表
 */
@property(nonatomic,strong)UITableView * liveTableView;
@end

@implementation AW_LiveAdressController

#pragma mark - Private Menthod
-(AW_LiveAdressDataSource*)liveDataSource{
    if (!_liveDataSource) {
        _liveDataSource = [[AW_LiveAdressDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _liveDataSource;
}

-(UITableView*)liveTableView{
    if (!_liveTableView) {
        _liveTableView = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT)];
        _liveTableView.backgroundColor = [UIColor clearColor];
        _liveTableView.dataSource = self.liveDataSource;
        _liveTableView.delegate = self.liveDataSource;
    }
    return _liveTableView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.liveTableView];
    self.liveTableView.tableFooterView = [[UIView alloc]init];
    self.liveDataSource.tableView = self.liveTableView;
    self.liveDataSource.hasLoadMoreFooter = NO;
    self.liveDataSource.hasRefreshHeader = NO;
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    //添加返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"所在地";
    //加载数据
    [self.liveDataSource getData];
    [self.liveDataSource configDisplayData];
    //点击cell的回调
    __weak typeof(self) weakSelf = self;
    self.liveDataSource.didClickedCell = ^(NSString * adressString){
        
        if (adressString.length > 0) {
            //将所在地传到上个界面
            NSLog(@"===%@===",adressString);
            [weakSelf.delegate didClikedCell:adressString];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
