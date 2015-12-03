//
//  AW_CommenIssureController.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/28.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_CommenIssureController.h"
#import "AW_SuperQuestionCell.h"
#import "AW_SonQuestionCell.h"
#import "AW_QuestionModal.h"
#import "AW_Constants.h"
#import "UIImage+IMB.h"
#import "AW_CommentionViewController.h"
#import "AFNetworking.h"
#import "AW_QuestionListController.h"//问题列表

@interface AW_CommenIssureController ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  @author cao, 15-08-28 10:08:50
 *
 *  常见问题tableView
 */
@property(nonatomic,strong)UITableView * questionTableView;
/**
 *  @author cao, 15-08-28 10:08:20
 *
 *  保存全部数据的数组
 */
@property(nonatomic,strong)NSMutableArray * dataArray;
/**
 *  @author cao, 15-08-28 10:08:40
 *
 *  要显示在界面上的数据数组
 */
@property(nonatomic,strong)NSMutableArray * displayArray;
/**
 *  @author cao, 15-08-28 16:08:50
 *
 *  第一级的cell
 */
@property(nonatomic,strong)AW_SuperQuestionCell * superCell;
@end

@implementation AW_CommenIssureController

#pragma amrk - Private Menthod

-(AW_SuperQuestionCell*)superCell{
    if (!_superCell) {
        _superCell = BundleToObj(@"AW_SuperQuestionCell");
    }
    return _superCell;
}

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(UITableView*)questionTableView{
    if (!_questionTableView) {
        _questionTableView = [[UITableView alloc]init];
        _questionTableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNAV_BAR_HEIGHT);
        _questionTableView.backgroundColor = [UIColor clearColor];
    }
    return _questionTableView;
}

-(NSMutableArray*)displayArray{
    if (!_displayArray) {
        _displayArray = [[NSMutableArray alloc]init];
    }
    return _displayArray;
}

#pragma mark - GetData Menthod
-(void)getAllData{
    __weak typeof(self) weakSelf = self;
    NSArray * tmpArray = @[@"卖家常见问题",@"产品相关",@"订单相关",@"账户相关",@"配送相关"];
    [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * tmpString = obj;
        AW_QuestionModal * modal = [[AW_QuestionModal alloc]init];
        modal.question_id = [NSString stringWithFormat:@"%ld",idx + 1];
        modal.question_title = tmpString;
        modal.question_type = [NSString stringWithFormat:@"%ld",idx + 1];
        modal.level = 1;
        modal.expand = NO;
        [weakSelf.dataArray addObject:modal];
        
        //在这进行常见问题请求
        NSDictionary * dict = @{@"param":@"oftenProblem"};
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            NSArray * commentArray = responseObject[@"info"];
            if ([responseObject[@"code"]intValue] == 0){
              [commentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  NSDictionary * sonDict = obj;
                  if ([sonDict[@"type"]intValue] == [modal.question_type intValue]) {
                      modal.subArray = [[NSMutableArray alloc]init];
                      AW_QuestionModal * sonModal = [[AW_QuestionModal alloc]init];
                      sonModal.question_id = sonDict[@"id"];
                      sonModal.question_title = sonDict[@"title"];
                      sonModal.question_type = sonDict[@"type"];
                      sonModal.question_content = sonDict[@"content"];
                      sonModal.level = 2;
                      sonModal.expand = NO;
                      [modal.subArray addObject:sonModal];
                  }
              }];
                [self.questionTableView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@",[error localizedDescription]);
        }];
    }];
    
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.questionTableView.backgroundColor = HexRGB(0xf6f7f8);
    //添加列表视图
    [self.view addSubview:self.questionTableView];
    self.questionTableView.tableFooterView = [[UIView alloc]init];
    self.questionTableView.dataSource = self;
    self.questionTableView.delegate = self;
    
    //加载数据
    [self getAllData];
    /**
     设置左侧返回按钮
     */
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"常见问题";
    
    // 设置设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x88c244);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    [self.navigationController.navigationBar setShadowImage:shadowImage];//隐藏navgationbar下边的那条线
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //加载数据
    [self reloadDataForDisplaryArray];
}

#pragma mark - ButtonClick Menthod
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ConfigData Menthod
/**
 *  @author cao, 15-08-28 11:08:44
 *
 *  获取要展示的数据
 */
-(void)reloadDataForDisplaryArray{
    NSMutableArray * tmpArray = [[NSMutableArray alloc]init];
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AW_QuestionModal * modal = obj;
        NSLog(@"%@",modal.question_title);
        [tmpArray addObject:modal];
        /**
         *  @author cao, 15-08-28 11:08:21
         *
         *  如果是展开的状态，就遍历孩子数组中的元素
         */
        if (modal.expand){
            [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                AW_QuestionModal *secondModal = obj;
                [tmpArray addObject:secondModal];
            }];
        }
    }];
    self.displayArray = [tmpArray mutableCopy];
    [self.questionTableView reloadData];
}
/**
 *  @author cao, 15-08-28 11:08:22
 *
 *  修改cell的打开或关闭的状态
 *
 *  @param index 索引位置
 */
-(void)reloadDataForDispalyArrayChangeAt:(NSInteger)index{
    NSMutableArray * tmpArray = [[NSMutableArray alloc]init];
    NSInteger row = 0;
    for (AW_QuestionModal * modal in self.dataArray ) {
        [tmpArray addObject:modal];
        if (row == index) {
            modal.expand = !modal.expand;
        }
        ++row;
        if (modal.expand) {
            for (AW_QuestionModal * secondModal in modal.subArray) {
                [tmpArray addObject:secondModal];
                if (row == index) {
                    secondModal.expand = !secondModal.expand;
                }
                ++row;
            }
        }
    }
    self.displayArray = nil;
    self.displayArray = [NSMutableArray arrayWithArray:tmpArray];
    [self.questionTableView reloadData];
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.displayArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * superCellId = @"superCell";
    static NSString * childCellId = @"childCell";
    
    AW_QuestionModal * modal = self.displayArray[indexPath.row];
    if (modal.level == 1) {
        AW_SuperQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:superCellId];
        if (!cell) {
            cell = BundleToObj(@"AW_SuperQuestionCell");
        }
        NSLog(@"%@",modal.question_title);
        cell.superQuestion.text = [NSString stringWithFormat:@"%@",modal.question_title];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = HexRGB(0xf6f7f8);
        cell.contentView.backgroundColor = HexRGB(0xf6f7f8);
        //点击更多问题按钮的回调
        __weak typeof(cell) weakCell = cell;
        cell.didClickedMoreBtn = ^(NSInteger index){
            UIView * v1 = [weakCell.moreQuestionBtn superview];
            AW_SuperQuestionCell * supCell = (AW_SuperQuestionCell*)[v1 superview];
            NSIndexPath * tmpPath = [tableView indexPathForCell:supCell];
            AW_QuestionModal * tmpModal = self.displayArray[tmpPath.row];
            NSLog(@"%@",tmpModal.question_title);
            //进入问题列表界面
            AW_QuestionListController * listController = [[AW_QuestionListController alloc]init];
            listController.questionDataSource.column_id = tmpModal.question_id;
            listController.questionDataSource.column_Title = tmpModal.question_title;
            [self.navigationController pushViewController:listController animated:YES];
        };
        return cell;
    } else if(modal.level ==2){
        AW_SonQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:childCellId];
        if (!cell) {
            cell = BundleToObj(@"AW_SonQuestionCell");
        }
        cell.sonQuestion.text = [NSString stringWithFormat:@"%@",modal.question_title];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
     return nil;
    }
}

#pragma mark - UITableViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_QuestionModal * modal = self.displayArray[indexPath.row];
    if (modal.level==1) {
        return 40.0f;
    }else {
        return 35.0f;
    }
}
/**
 *  @author cao, 15-08-28 12:08:23
 *
 *  处理cell的选中事件
 *
 *  @param tableView
 *  @param indexPath
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AW_QuestionModal * modal = self.displayArray[indexPath.row];
    if (modal.level == 1) {
        //修改cell的状态，关闭或者打开
        [self reloadDataForDispalyArrayChangeAt:indexPath.row];
    }else if(modal.level == 2){
        AW_CommentionViewController * commentViewController = [[AW_CommentionViewController alloc]init];
        commentViewController.question_id = modal.question_id;
        [self.navigationController pushViewController:commentViewController animated:YES];
    }  
}
//让分割线显示完全
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
