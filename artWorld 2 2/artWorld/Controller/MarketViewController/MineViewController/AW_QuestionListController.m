//
//  AW_QuestionListController.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/10.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_QuestionListController.h"
#import "AW_Constants.h"
#import "AW_CommentionViewController.h"

@interface AW_QuestionListController ()
/**
 *  @author cao, 15-11-10 14:11:53
 *
 *  问题列表
 */
@property(nonatomic,strong)UITableView * questionTabeView;
@end

@implementation AW_QuestionListController

#pragma mark - Private Menthod
-(UITableView*)questionTabeView{
    if (!_questionTabeView) {
        _questionTabeView = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT)];
    }
    return _questionTabeView;
}

-(AW_QuestionListDataSource*)questionDataSource{
    if (!_questionDataSource) {
        _questionDataSource = [[AW_QuestionListDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
        }];
    }
    return _questionDataSource;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.questionTabeView];
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.questionTabeView.delegate = self.questionDataSource;
    self.questionTabeView.dataSource = self.questionDataSource;
    self.questionTabeView.tableFooterView = [[UIView alloc]init];
    self.questionDataSource.tableView = self.questionTabeView;
    self.questionDataSource.hasLoadMoreFooter = YES;
    self.questionDataSource.hasRefreshHeader = YES;
    self.questionTabeView.backgroundColor = [UIColor clearColor];
    /**
     设置左侧返回按钮
     */
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //点击cell的回调
    __weak typeof(self) weakSelf = self;
    self.questionDataSource.didClickedCell = ^(AW_QuestionModal * modal){
        AW_CommentionViewController * controller = [[AW_CommentionViewController alloc]init];
        controller.question_id = modal.question_id;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.navigationItem.title = self.questionDataSource.column_Title;
}
#pragma mark - ButtonClicked Menthod
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
