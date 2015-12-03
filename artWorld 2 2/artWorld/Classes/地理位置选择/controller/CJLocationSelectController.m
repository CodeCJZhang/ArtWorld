//
//  CJLocationSelectController.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/31.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJLocationSelectController.h"
#import "CJLocationSelectCell.h"
#import "CJContatc.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface CJLocationSelectController ()<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,copy) NSMutableArray *location;

@property (nonatomic,strong) BMKLocationService *locService;

@end

@implementation CJLocationSelectController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"位置选择";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClickBtn)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _locService.distanceFilter = 100;
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //判断是否为第一次选择地址，若是第一次则默认第一行被选中
    if (_lastIndexPath == nil)
    {
        _lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)location
{
    if (!_location) {
        _location = [NSMutableArray array];
    }
    return _location;
}

- (void)backClickBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BaiDuMap delegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude); //调试代码，勿删
    
    //发起反向地理编码检索
    BMKGeoCodeSearch *_searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    if([_searcher reverseGeoCode:reverseGeoCodeSearchOption])
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error {
//    NSLog(@"result ==*********==  %@",result.poiList);  //调试代码
    
    if (_location.count != 0)
    {
        [_location removeAllObjects];
    }
    
    _location = [result.poiList mutableCopy];
    [self.tableView reloadData];
    
//    for (int i = 0;i < _location.count; i ++)  //调试代码，勿删
//    {
//        BMKPoiInfo *info = _location[i];
//        NSLog(@"_location____%@",info.address);
//    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _location.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"location";
    CJLocationSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        if (0 == indexPath.row)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"CJLocationSelectCell" owner:nil options:nil][0];
            //条件：此次不是第一次选择位置，并且上次选的位置不是第一行
            if (_lastIndexPath != nil && _lastIndexPath.row != 0)
            {
                cell.selectImage.image = nil;
            }
        }
        else
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"CJLocationSelectCell" owner:nil options:nil][1];
            BMKPoiInfo * info = _location[indexPath.row - 1];
            cell.place.text = info.address;
            cell.area.text = info.city;
            
            //条件：此次不是第一次选择位置，并且让上次被选中行处于选中状态
            if (indexPath.row == _lastIndexPath.row)
            {
                UIImage *image = [UIImage imageNamed:@"写微博--城市选择"];
                cell.selectImage.image = image;
            }
            else
            {
                cell.selectImage.image = nil;
            }
        }
        cell.preservesSuperviewLayoutMargins = NO;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //让上次被选中行变为非选中状态
    CJLocationSelectCell *lastSelectCell = (CJLocationSelectCell *)[tableView cellForRowAtIndexPath:_lastIndexPath];
    lastSelectCell.selectImage.image = nil;
    
    //让当前被点击行变为选中状态
    UIImage *image = [UIImage imageNamed:@"写微博--城市选择"];
    CJLocationSelectCell *clickCell = (CJLocationSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
    clickCell.selectImage.image = image;
    
    //保存当前选中行索引
    _lastIndexPath = indexPath;
    
    //选中行地址传递
    NSString *address = clickCell.place.text;       //获取当前选中行地址
    CJContatc *c = [[CJContatc alloc]init];
    c.address = address;
    c.indexPath = indexPath;
    
    if ([self.delegate respondsToSelector:@selector(locationSelectControllerAddAddress: contatc:)])
    {
        [self.delegate locationSelectControllerAddAddress:self contatc:c];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

@end
