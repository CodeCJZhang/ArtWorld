//
//  AW_CheckPhonePersonController.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_CheckPhonePersonController.h"
#import "AW_CheckPhoneDataSource.h"
#import "AW_Constants.h"
#import "MBProgressHUD.h"

@interface AW_CheckPhonePersonController ()
/**
 *  @author cao, 15-09-15 19:09:44
 *
 *  查看手机联系人控制器
 */
@property(nonatomic,strong)AW_CheckPhoneDataSource * checkDataSource;
/**
 *  @author cao, 15-09-15 19:09:00
 *
 *  查看手机联系人列表
 */
@property(nonatomic,strong)UITableView * checkTableView;

@end

@implementation AW_CheckPhonePersonController

#pragma mark - Private Menthod
-(AW_CheckPhoneDataSource*)checkDataSource{
    if (!_checkDataSource) {
        _checkDataSource = [[AW_CheckPhoneDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _checkDataSource;
}

-(UITableView*)checkTableView{
    if (!_checkTableView) {
        _checkTableView = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT)];
        _checkTableView.delegate = self.checkDataSource;
        _checkTableView.dataSource = self.checkDataSource;
        _checkTableView.backgroundColor = [UIColor clearColor];
        //设置右侧索引的文本颜色
        _checkTableView.sectionIndexColor = HexRGB(0x88c244);
        _checkTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _checkTableView.allowsSelection = YES;
        _checkTableView.sectionIndexTrackingBackgroundColor = HexRGBAlpha(0x000000, 0.3);
    }
    return _checkTableView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    [self.view addSubview:self.checkTableView];
    self.checkDataSource.hasLoadMoreFooter = NO;
    self.checkDataSource.hasRefreshHeader = NO;
    self.checkDataSource.tableView = self.checkTableView;
    self.checkTableView.tableFooterView = [[UIView alloc]init];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //获取数据
    [self.checkDataSource getData];
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"查看手机联系人";
    //点击section索引的回调
    __weak typeof(self) weakSelf = self;
    self.checkDataSource.didClickedSectionIndex = ^(NSString * sectionStrint){
            [weakSelf showWithMessage:sectionStrint];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClick Menthod
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ShowMessage Menthod
-(void)showWithMessage:(NSString *)message{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.mode = MBProgressHUDModeCustomView;
    hub.labelFont = [UIFont boldSystemFontOfSize:27];
    hub.labelText = message;
    hub.minShowTime = 0.5;
    hub.color = HexRGB(0x88c244);
    hub.userInteractionEnabled = NO;
    hub.removeFromSuperViewOnHide = YES;
    [hub hide:YES afterDelay:0.8];
  
}

@end
