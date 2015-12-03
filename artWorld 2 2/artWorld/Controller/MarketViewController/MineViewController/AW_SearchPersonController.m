//
//  AW_SearchPersonController.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/29.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_SearchPersonController.h"
#import "AW_keywordSearchView.h"
#import "AW_Constants.h"
#import "AW_SearchStringCell.h"//搜索关键字cell
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AW_SearchKeyDataSource.h"
#import "SearchDataBaseHelper.h"

@interface AW_SearchPersonController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  @author cao, 15-10-28 14:10:25
 *
 *  关键字列表
 */
@property(nonatomic,strong)UITableView * keywordTable;
/**
 *  @author cao, 15-11-29 19:11:04
 *
 *  搜索结果列表
 */
@property(nonatomic,strong)UITableView * searchResultTable;
/**
 *  @author cao, 15-10-28 14:10:28
 *
 *  搜索视图
 */
@property(nonatomic,strong)AW_keywordSearchView * searchView;
/**
 *  @author cao, 15-10-28 14:10:13
 *
 *  搜索数组
 */
@property(nonatomic,strong)NSMutableArray * searchArray;
/**
 *  @author cao, 15-11-30 14:11:02
 *
 *  搜索结果数据源
 */
@property(nonatomic,strong)AW_SearchKeyDataSource * searchDataSource;

@end

@implementation AW_SearchPersonController

#pragma mark - Private Mennthod
-(AW_SearchKeyDataSource*)searchDataSource{
    if (!_searchDataSource) {
        _searchDataSource = [[AW_SearchKeyDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _searchDataSource;
}

-(NSMutableArray*)searchArray{
    if (!_searchArray) {
        SearchDataBaseHelper * helper = [[SearchDataBaseHelper alloc]init];
        NSMutableArray * tmpArray = [helper queryAllKeyWord];
        if (tmpArray.count > 0) {
            _searchArray = [NSMutableArray arrayWithArray:tmpArray];
        }else{
        _searchArray = [[NSMutableArray alloc]init];
        }
    }
    return _searchArray;
}

-(UITableView*)keywordTable{
    if (!_keywordTable) {
        _keywordTable = [[UITableView alloc]init];
        _keywordTable.delegate = self;
        _keywordTable.dataSource = self;
          _keywordTable.separatorColor = HexRGB(0xe6e6e6);
        _keywordTable.tableFooterView = [[UIView alloc]init];
    }
    return _keywordTable;
}

-(UITableView*)searchResultTable{
    if (!_searchResultTable) {
        _searchResultTable = [[UITableView alloc]init];
        _searchResultTable.tableFooterView = [[UIView alloc]init];
        _searchResultTable.hidden = YES;
        _searchResultTable.separatorColor = HexRGB(0xe6e6e6);
    }
    return _searchResultTable;
}

-(AW_keywordSearchView*)searchView{
    if (!_searchView) {
        _searchView = BundleToObj(@"AW_keywordSearchView");
        _searchView.backgroundColor = [UIColor whiteColor];
    }
    return _searchView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearchView];
    [self addKeyTableView];
    [self addSearchResultTableView];
    self.searchResultTable.dataSource = self.searchDataSource;
    self.searchResultTable.delegate = self.searchDataSource;
    self.searchDataSource.tableView = self.searchResultTable;
    self.searchDataSource.hasLoadMoreFooter = YES;
    self.searchDataSource.hasRefreshHeader = NO;
    self.searchDataSource.currentPage = @"1";
    //设置搜索关键字列表为可见，搜索结果列表不可见
    self.searchResultTable.hidden = YES;
    self.keywordTable.hidden = NO;
    
    self.searchView.searchTextField.placeholder = @"用户昵称/手机号/真实姓名";
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.keywordTable.backgroundColor = [UIColor clearColor];
    self.searchResultTable.backgroundColor = [UIColor clearColor];
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"搜索";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AddView Menthod
-(void)addSearchView{
    [self.view addSubview:self.searchView];
    self.searchView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.searchView addConstraint:[NSLayoutConstraint constraintWithItem:self.searchView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45]];
    //点击搜索按钮的回调
    __weak typeof(self) weakSelf = self;
    self.searchView.didClickedSearchBtn = ^(NSString * searchString){
        NSLog(@"搜索关键字：%@",searchString);
        if (searchString.length == 0) {
            [weakSelf showHUDWithMessage:@"请输入搜索关键字"];
        }else{
            weakSelf.searchDataSource.searchString = searchString;
            [weakSelf.searchDataSource getData];
            weakSelf.keywordTable.hidden = YES;
            weakSelf.searchResultTable.hidden = NO;    
        }
    };
}

-(void)addKeyTableView{
    [self.view addSubview:self.keywordTable];
    self.keywordTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keywordTable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keywordTable attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keywordTable attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keywordTable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

-(void)addSearchResultTableView{
    [self.view addSubview:self.searchResultTable];
    self.searchResultTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchResultTable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchResultTable attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchResultTable attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchResultTable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

#pragma mark - UITableViewDelegate Menthod
    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.searchArray.count;
    }
    
    -(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSString * string = self.searchArray[indexPath.row];
        static NSString * cellId = @"searchStringCell";
        AW_SearchStringCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = BundleToObj(@"AW_SearchStringCell");
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.searchString.text = string;
        return cell;
    }
    
#pragma mark - UITableViewDataSource Menthod
    -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSString * str = self.searchArray[indexPath.row];
        self.searchDataSource.searchString = str;
        [self.searchDataSource getData];
        self.keywordTable.hidden = YES;
        self.searchResultTable.hidden = NO;
    }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 35;
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
    
    
#pragma mark - ButtonClicked Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    self.searchResultTable.hidden = YES;
    self.keywordTable.hidden = NO;
}

#pragma mark - ShowMessage Menthod
    - (void)showHUDWithMessage:(NSString*)msg{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = msg;
        hud.labelFont = [UIFont boldSystemFontOfSize:13];
        hud.margin = 10.f;
        hud.cornerRadius = 4.0;
        hud.yOffset = 150.f;
        hud.alpha = 0.9;
        hud.userInteractionEnabled = NO;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
    
@end
