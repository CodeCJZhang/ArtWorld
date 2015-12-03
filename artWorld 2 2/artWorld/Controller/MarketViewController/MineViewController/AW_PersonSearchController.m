//
//  AW_PersonSearchController.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/14.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_PersonSearchController.h"
#import "AW_keywordSearchView.h"
#import "AW_Constants.h"
#import "AW_SearchStringCell.h"//搜索关键字cell
#import "MBProgressHUD.h"

@interface AW_PersonSearchController ()
<UITableViewDataSource,UITableViewDelegate>
/**
 *  @author cao, 15-10-28 14:10:25
 *
 *  关键字列表
 */
@property(nonatomic,strong)UITableView * keywordTable;
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
@end

@implementation AW_PersonSearchController
-(NSMutableArray*)searchArray{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc]init];
    }
    return _searchArray;
}

-(UITableView*)keywordTable{
    if (!_keywordTable) {
        _keywordTable = [[UITableView alloc]init];
        _keywordTable.delegate = self;
        _keywordTable.dataSource = self;
        _keywordTable.tableFooterView = [[UIView alloc]init];
    }
    return _keywordTable;
}

-(AW_keywordSearchView*)searchView{
    if (!_searchView) {
        _searchView = [[NSBundle mainBundle]loadNibNamed:@"AW_keywordSearchView" owner:self options:nil][1];
        _searchView.searchTextField.placeholder = @"用户昵称/手机号/真实姓名";
        _searchView.backgroundColor = [UIColor whiteColor];
    }
    return _searchView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearchView];
    [self addKeywordTable];
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.keywordTable.backgroundColor = [UIColor clearColor];
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
    
}

#pragma mark - AddSearchView Menthod
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
            //将搜索关键字传到下一个界面(并且将搜索关键字插入数组)
            if (![weakSelf.searchArray containsObject:searchString]) {
                [weakSelf.searchArray insertObject:searchString atIndex:0];
                [weakSelf.keywordTable reloadData];
            }
            
        }
    };
}

-(void)addKeywordTable{
    [self.view addSubview:self.keywordTable];
    self.keywordTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keywordTable attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keywordTable attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keywordTable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.keywordTable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
}

#pragma mark - ButtonClicked Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString * searchString = self.searchArray[indexPath.row];
    NSLog(@"searchString==%@==",searchString);
    
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

#pragma mark - ShowMessage Menthod
- (void)showHUDWithMessage:(NSString*)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //hud.mode = MBProgressHUDModeCustomView;
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
