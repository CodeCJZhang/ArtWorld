//
//  AW_LiveProvinceController.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/14.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_LiveProvinceController.h"
#import "AW_Constants.h"
#import "AW_ProvncesCell.h"
#import "AW_ProvinceModal.h"
#import "AFNetworking.h"
#import "AW_LiveCityController.h"

@interface AW_LiveProvinceController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  @author cao, 15-11-07 10:11:48
 *
 *  省份列表
 */
@property(nonatomic,strong)UITableView * provinceTable;
/**
 *  @author cao, 15-11-07 11:11:50
 *
 *  省份数组
 */
@property(nonatomic,strong)NSMutableArray * provinceArray;

@end

@implementation AW_LiveProvinceController

#pragma mark - Private Menthod
-(UITableView *)provinceTable{
    if (!_provinceTable) {
        _provinceTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT)];
        _provinceTable.delegate = self;
        _provinceTable.dataSource = self;
    }
    return _provinceTable;
}

-(NSMutableArray*)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [[NSMutableArray alloc]init];
    }
    return _provinceArray;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.provinceTable];
    self.provinceTable.tableFooterView = [[UIView alloc]init];
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.navigationItem.title = @"所在地";
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //在这进行省份请求
    NSDictionary * dict = @{};
    NSError *error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * provinceDict = @{@"param":@"getProvince",@"jsonParam":string};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:provinceDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]integerValue] == 0) {
            //插入其他省份
            [responseObject[@"info"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * dict = obj;
                AW_ProvinceModal *modal = [[AW_ProvinceModal alloc]init];
                modal.Province_id = dict[@"id"];
                modal.Province_name = dict[@"name"];
                //modal.hasCity = [dict[@"pid"]boolValue];
                [self.provinceArray addObject:modal];
            }];
            [self.provinceTable reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource Menthod

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.provinceArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_ProvinceModal * modal = self.provinceArray[indexPath.row];
    AW_ProvncesCell * cell;
    static NSString * cellID = @"provinceCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = BundleToObj(@"AW_ProvncesCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.provinceCell.text = [NSString stringWithFormat:@"%@",modal.Province_name];
    return cell;
}

#pragma mark - UITableViewdelegate Menthod
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    AW_ProvinceModal * modal = self.provinceArray[indexPath.row];
    AW_LiveCityController * controller = [[AW_LiveCityController alloc]init];
    controller.provinceModal = modal;
    [self.navigationController pushViewController:controller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

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
}


@end
