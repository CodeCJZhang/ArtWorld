//
//  AW_AddNewAttentionController.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_AddNewAttentionController.h"
#import "AW_Constants.h"
#import "AW_AddAttentionCell.h"
#import "Node.h"
#import "AW_SearchPersonController.h"//搜索控制器
#import "AW_CheckPhonePersonController.h" //查看手机联系人控制器

@interface AW_AddNewAttentionController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * addAttentionTableView;
@end

@implementation AW_AddNewAttentionController

-(UITableView*)addAttentionTableView{
    if (!_addAttentionTableView) {
        _addAttentionTableView = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH , kSCREEN_HEIGHT-kNAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _addAttentionTableView.tableFooterView = [[UIView alloc]init];
        _addAttentionTableView.dataSource = self;
        _addAttentionTableView.delegate = self;
        _addAttentionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _addAttentionTableView.bounces = NO;
    }
    return _addAttentionTableView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.addAttentionTableView];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.addAttentionTableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"添加新关注";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        static NSString * separateId = @"separateCell";
        UITableViewCell * separate = [tableView dequeueReusableCellWithIdentifier:separateId];
        if (!separate) {
            separate = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:separateId];
            separate.selectionStyle = UITableViewCellSelectionStyleNone;
            separate.backgroundColor = [UIColor clearColor];
            separate.contentView.backgroundColor = [UIColor clearColor];
        }
        return separate;
    }else {
        static NSString * cell2 = @"cell2";
        AW_AddAttentionCell * cellTwo = [tableView dequeueReusableCellWithIdentifier:cell2];
        if (!cellTwo) {
            cellTwo = [[NSBundle mainBundle]loadNibNamed:@"AW_AddAttentionCell" owner:self options:nil][0];
            cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
            cellTwo.backgroundColor = [UIColor whiteColor];
            cellTwo.contentView.backgroundColor = [UIColor whiteColor];
        }
        //点击cell后的回调
        cellTwo.didclickButton = ^(NSInteger index){
            if (index == 1) {
                AW_SearchPersonController * searchController = [[AW_SearchPersonController alloc]init];
                searchController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:searchController animated:YES];
            }else if (index == 2){
                AW_CheckPhonePersonController * checkController = [[AW_CheckPhonePersonController alloc]init];
                checkController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:checkController animated:YES];
            }
        };
        return cellTwo;
    }
}
#pragma mark - UITableViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 8;
    }else {
        return 84;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
