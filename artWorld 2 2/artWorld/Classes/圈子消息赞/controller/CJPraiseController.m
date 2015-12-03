//
//  CJPraiseController.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJPraiseController.h"
#import "CJPraiseCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "AW_Constants.h"
#import "MBProgressHUD+NJ.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "CJUtilityTools.h"


@interface CJPraiseController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *praiseArray;
}

//页码
@property (nonatomic,copy) NSString *pageNumber;

//数据总数量
@property (nonatomic,assign) NSInteger totalNumber;

@end

@implementation CJPraiseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收到的赞";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    _pageNumber = @"1";
    [self request];
}

//退出界面
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 请求数据
- (void)request
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    
    NSDictionary *fieldDic = @{@"userId":user_id, @"pageSize":@"10", @"pageNumber":_pageNumber};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"getUserDynamicByGood",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             _totalNumber = [[responseObject[@"info"] valueForKey:@"totalNumber"] integerValue];
             praiseArray = [NSMutableArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];
             
             NSLog(@"请求结果:%@",responseObject);
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

    return praiseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Praise";
    CJPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CJPraiseCell" owner:nil options:nil]firstObject];
    }
    //当前行数据
    NSDictionary *cellDict = [NSDictionary dictionaryWithDictionary:praiseArray[indexPath.row]];
    
    //头像
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"head_img"]]];
    [cell.icon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
    
    //昵称
    cell.name.text = [NSString stringWithFormat:@"%@",[cellDict valueForKey:@"nickname"]];
    
    //认证
    NSInteger state = [[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"authentication_state"]] integerValue];
    if (state == 3)
    {
        cell.vip.hidden = NO;
    } else {
        cell.vip.hidden = YES;
    }
    
    //时间
    cell.time.text = [CJUtilityTools timeStampWithTimeStr:[cellDict valueForKey:@"create_time"]];
    
    //被赞微博原数据
    NSDictionary *ori_Dict = [NSDictionary dictionaryWithDictionary:[cellDict valueForKey:@"original_dynamic"]];
    
    //微博照片
    NSString *imageStr = [NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"clear_img"]];
    NSArray *imgArr = [CJUtilityTools imageUrlArrWithUrlStr:imageStr];
    if (imgArr.count != 0)
    {
        [cell.image sd_setImageWithURL:imgArr[0] placeholderImage:PLACE_HOLDERIMAGE];
    }
    else{
        NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"head_img"]]];
        [cell.image sd_setImageWithURL:url1 placeholderImage:PLACE_HOLDERIMAGE];
    }
    
    //at了谁
    NSString *at = @"@";
    cell.atLable.text = [at stringByAppendingString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"nickname"]]];
    
    //微博正文
    cell.content.text = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"content"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

@end
