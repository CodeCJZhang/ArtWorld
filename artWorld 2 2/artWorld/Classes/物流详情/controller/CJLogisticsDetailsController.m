//
//  CJLogisticsDetailsController.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/31.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJLogisticsDetailsController.h"
#import "CJLogisticsDetailsCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "AW_Constants.h"
#import "MBProgressHUD+NJ.h"
#import "UIImageView+WebCache.h"
#import "CJUtilityTools.h"


@interface CJLogisticsDetailsController ()

{
    NSDictionary *logisticsDetailsDict;
    NSArray *jsonDataArr;
}

@property (nonatomic,strong) CJLogisticsDetailsCell *cell;

@property (nonatomic,assign) NSInteger state;

@property (nonatomic,assign) NSInteger i;

@end

@implementation CJLogisticsDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"物流详情";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(logBackClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    _i = 1;
    self.tableView.separatorStyle = NO;
    [self request];
}

//退出界面
-(void)logBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)request
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    
    NSDictionary *fieldDic = @{@"userId":user_id, @"newsId":_newsId, @"orderId":_orderId};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"getlogisticsNewsDetails",@"token":@"android",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             logisticsDetailsDict = [NSDictionary dictionaryWithDictionary:responseObject[@"info"]];
             
             NSLog(@"请求结果:%@",responseObject);
             
             //物流数据
             NSString *json = [logisticsDetailsDict objectForKey:@"json"];
             if ([json isKindOfClass:[NSNull class]])
             {
                 jsonDataArr = nil;
                 _state = 10;
             }
             else
             {
                 NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
                 NSError *err;
                 id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                 NSLog(@"%@",jsonDict);
                 if (err == nil)
                 {
                     jsonDataArr = [NSArray arrayWithArray:[jsonDict[@"lastResult"] valueForKey:@"data"]];
                 }
                 
                 //物流状态
                 _state = [[jsonDict[@"lastResult"] valueForKey:@"state"] integerValue];
             }
             
             [self.tableView reloadData];
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return jsonDataArr.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *identifier = @"details1";
        CJLogisticsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"CJLogisticsDetailsCell" owner:nil options:nil][0];
        }
        //物流对象字典
        NSDictionary *deliverDict = [NSDictionary dictionaryWithDictionary:[logisticsDetailsDict valueForKey:@"deliver"]];
        //物流名称
        NSString *logisticsName = [NSString stringWithFormat:@"%@",[deliverDict valueForKey:@"logistics_name"]];
        cell.logisticsName.text = logisticsName;
        
        //物流图标
        if ([logisticsName isEqualToString:@"圆通"])
        {
            cell.icon.image = [UIImage imageNamed:@"yuantong"];
        }
        else if ([logisticsName isEqualToString:@"中通"])
        {
            cell.icon.image = [UIImage imageNamed:@"zhongtong"];
        }else if ([logisticsName isEqualToString:@"申通"])
        {
            cell.icon.image = [UIImage imageNamed:@"shentong"];
        }else if ([logisticsName isEqualToString:@"EMS"])
        {
            cell.icon.image = [UIImage imageNamed:@"EMS"];
        }else if ([logisticsName isEqualToString:@"顺丰"])
        {
            cell.icon.image = [UIImage imageNamed:@"shunfeng"];
        }
        
        //运单编号
        cell.waybillNumber.text = [NSString stringWithFormat:@"%@",[deliverDict valueForKey:@"logistics_code"]];
        
        //物流状态
        switch (_state) {
            case 0:
                cell.logisticsState.text = @"在途中";
                break;
            case 1:
                cell.logisticsState.text = @"已揽收";
                break;
            case 2:
                cell.logisticsState.text = @"疑难";
                break;
            case 3:
                cell.logisticsState.text = @"已签收";
                break;
            case 4:
                cell.logisticsState.text = @"退签";
                break;
            case 5:
                cell.logisticsState.text = @"同城派送中";
                break;
            case 6:
                cell.logisticsState.text = @"退回";
                break;
            case 7:
                cell.logisticsState.text = @"转单";
                break;
            default:
                cell.logisticsState.text = @"";
                break;
        }
        
        _cell = cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *identifier = @"details2";
        CJLogisticsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"CJLogisticsDetailsCell" owner:nil options:nil][1];
        }
        //商品列表数组
        NSDictionary *artsDict = [NSDictionary dictionaryWithDictionary:[logisticsDetailsDict valueForKey:@"arts"][0]];
        
        //商品图片
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[artsDict valueForKey:@"clear_img"]]];
        [cell.goodsImage sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
        
        //商品名称
        cell.goodsName.text = [NSString stringWithFormat:@"%@",[artsDict valueForKey:@"commodity_name"]];
        
        //商品描述
        NSString *designStr = [NSString stringWithFormat:@"%@",[artsDict valueForKey:@"commodity_attr"]];
        if ([designStr isEqualToString:@"<null>"])
        {
            cell.goodsDesign.text = @"";
        } else {
            cell.goodsDesign.text = designStr;
        }
        
        //商品价格
        NSString *goodsPrice = [@"¥"stringByAppendingString:[NSString stringWithFormat:@"%@",[artsDict valueForKey:@"price"]]];
        cell.goodPrice.text = goodsPrice;
        
        //商品数量
        NSString *goodsNum = [@"x"stringByAppendingString:[NSString stringWithFormat:@"%@",[artsDict valueForKey:@"number"]]];
        cell.goodsNum.text = goodsNum;
        
        _cell = cell;
    }
    else if (indexPath.row == 2)
    {
        static NSString *identifier = @"details3";
        CJLogisticsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"CJLogisticsDetailsCell" owner:nil options:nil][2];
        }
        //当前行数据
        cell.state1.text = [NSString stringWithFormat:@"%@",[jsonDataArr[0] valueForKey:@"context"]];
        cell.time1.text = [NSString stringWithFormat:@"%@",[jsonDataArr[0] valueForKey:@"ftime"]];
        
        _cell = cell;
    }
    else if (indexPath.row == (jsonDataArr.count + 1))
    {
        static NSString *identifier = @"details5";
        CJLogisticsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"CJLogisticsDetailsCell" owner:nil options:nil][4];
        }
        //最后一行数据
        cell.state3.text = [NSString stringWithFormat:@"%@",[[jsonDataArr lastObject] valueForKey:@"context"]];
        cell.time3.text = [NSString stringWithFormat:@"%@",[[jsonDataArr lastObject] valueForKey:@"ftime"]];
    
        _cell = cell;
    }
    else
    {
        static NSString *identifier = @"details4";
        CJLogisticsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"CJLogisticsDetailsCell" owner:nil options:nil][3];
        }
        if (_i > 0 && _i < (jsonDataArr.count - 1))
        {
            cell.state2.text = [NSString stringWithFormat:@"%@",[jsonDataArr[_i] valueForKey:@"context"]];
            cell.time2.text = [NSString stringWithFormat:@"%@",[jsonDataArr[_i] valueForKey:@"ftime"]];
            _i++;
        }
    
        _cell = cell;
    }
    
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return _cell;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return 84;
            break;
        case 1:
            return 123;
            break;
        case 2:
            return 104;
            break;
    }
    return 66;
}

@end
