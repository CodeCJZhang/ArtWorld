//
//  AW_LiveCityController.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/14.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_LiveCityController.h"
#import "AW_Constants.h"
#import "AW_ProvncesCell.h"
#import "AW_CityModal.h"
#import "AFNetworking.h"
#import "AW_MyInformationViewController.h"//个人信息控制器

@interface AW_LiveCityController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  @author cao, 15-11-07 11:11:02
 *
 *  城市列表
 */
@property(nonatomic,strong)UITableView * cityTableView;
/**
 *  @author cao, 15-11-07 11:11:04
 *
 *  城市数组
 */
@property(nonatomic,strong)NSMutableArray * cityArray;

@end

@implementation AW_LiveCityController


#pragma mark - Private Menthod
-(UITableView*)cityTableView{
    if (!_cityTableView) {
        _cityTableView =[[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT)];
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
    }
    return _cityTableView;
}

-(NSMutableArray*)cityArray{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc]init];
    }
    return _cityArray;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    [self.view addSubview:self.cityTableView];
    self.cityTableView.tableFooterView = [[UIView alloc]init];
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = self.provinceModal.Province_name;
    
    //在这进行城市请求
    NSDictionary * dict = @{@"id":self.provinceModal.Province_id};
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * cityDict = @{@"param":@"getCity",@"jsonParam":string};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:cityDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
            //先将分类数组的数据清空
            if (self.cityArray.count > 0) {
                [self.cityArray removeAllObjects];
            }
            //城市请求成功就将城市数据存入modal
            [responseObject[@"info"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * cityDict = obj;
                AW_CityModal * modal = [[AW_CityModal alloc]init];
                modal.city_id = cityDict[@"id"];
                modal.city_name = cityDict[@"name"];
                [self.cityArray addObject:modal];
            }];
            [self.cityTableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cityArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_CityModal * modal = self.cityArray[indexPath.row];
    AW_ProvncesCell * cell;
    static NSString * cellId = @"cityCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ProvncesCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.provinceCell.text = [NSString stringWithFormat:@"%@",modal.city_name];
    return cell;
}

#pragma mark - UITableViewDelegate Menthod

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AW_CityModal * modal = self.cityArray[indexPath.row];
    AW_MyInformationViewController * controller = [self.navigationController.viewControllers objectAtIndex:1];
    //代理属性传回去
    self.delegate = controller;
    [_delegate didClickedLiveAdressCityCell:self.provinceModal city:modal];
    
    [self.navigationController popToViewController:controller animated:YES];
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

@end
