//
//  CJCommentMessageController.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJCommentMessageController.h"
#import "CJCommentMessageCell.h"
#import "CJReplyController.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "AW_Constants.h"
#import "MBProgressHUD+NJ.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "CJUtilityTools.h"

#define padding 8

@interface CJCommentMessageController ()

{
    NSMutableArray *commentArray;
}

//页码
@property (nonatomic,copy) NSString *pageNumber;

//数据总数量
@property (nonatomic,assign) NSInteger totalNumber;

@end

@implementation CJCommentMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论消息";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
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
    NSDictionary *JsonDic = @{@"param":@"getRespondCommentByUser",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             _totalNumber = [[responseObject[@"info"] valueForKey:@"totalNumber"] integerValue];
             NSArray *newArr = [NSArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];
             
             NSLog(@"请求结果:%@",responseObject);
             [self countCellHeightWithDataArray:newArr];
             [self.tableView reloadData];
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

#pragma mark - 计算cell行高
- (void)countCellHeightWithDataArray:(NSArray *)array
{
    commentArray = [NSMutableArray arrayWithCapacity:array.count];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //当前行数据字典
        NSMutableDictionary *cellDict = [NSMutableDictionary dictionaryWithDictionary:obj];
        
        //cell高度
        CGFloat sumH;
        //固定高度
        CGFloat fixedH = 161.0;
        
        //一次回复
        if ([[cellDict valueForKey:@"respond_comment"] isKindOfClass:[NSNull class]])
        {
            //计算评论文本高度
            CGFloat contentH = [CJUtilityTools countTextHeightWithString:[CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]]] placeHolderWidth:(kSCREEN_WIDTH - padding * 2)];
            
            sumH = fixedH + contentH;
        }
        else   //二次回复
        {
            //最新回复文字⬇️
            //可变原始串
            NSMutableString *replyContent = [[NSMutableString alloc] initWithString:@"回复@:"];
            //被回复人
            NSString *name = [NSString stringWithFormat:@"%@",[cellDict valueForKey:@"respond_user_name"]];
            //回复文字
            NSString *content = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]]];
            //串拼接
            [replyContent insertString:name atIndex:3];
            [replyContent appendString:content];
            //计算最新回复文本高度
            CGFloat contentH = [CJUtilityTools countTextHeightWithString:replyContent placeHolderWidth:(kSCREEN_WIDTH - padding * 2)];
            
            //上次回复数据字典⬇️
            NSDictionary *res_Dict = [NSDictionary dictionaryWithDictionary:[cellDict valueForKey:@"respond_comment"]];
            //可变原始串@
            NSMutableString *contentStr = [[NSMutableString alloc] initWithString:@"@"];
            //回复人
            NSString *nickname = [NSString stringWithFormat:@"%@",[res_Dict valueForKey:@"nickname"]];
            //被回复人
            NSString *res_name = [NSString stringWithFormat:@"%@",[res_Dict valueForKey:@"respond_user_name"]];
            //固定串
            NSMutableString *tempStr1 = [[NSMutableString alloc] initWithString:@"回复:"];
            [tempStr1 insertString:res_name atIndex:2];
            //上次回复文字
            NSString *last_content = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[res_Dict valueForKey:@"content"]]];
            //多串拼接
            [contentStr appendString:nickname];
            [contentStr appendString:tempStr1];
            [contentStr appendString:last_content];
            
            //计算上次回复文本高度
            CGFloat res_ContentH = [CJUtilityTools countTextHeightWithString:contentStr placeHolderWidth:(kSCREEN_WIDTH - padding * 4)];
            
            sumH = fixedH + contentH + res_ContentH;
        }
        
        //把cell高度插入数组中
        NSNumber *cellH = [NSNumber numberWithFloat:sumH];
        [cellDict setObject:cellH forKey:@"cellHeight"];
        [commentArray addObject:cellDict];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CommentMessage";
    CJCommentMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CJCommentMessageCell" owner:nil options:nil]firstObject];
    }
    //当前行数据
    NSDictionary *cellDict = [NSDictionary dictionaryWithDictionary:commentArray[indexPath.row]];
    
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
    }
    else{
        cell.vip.hidden = YES;
    }
    
    //时间
    cell.time.text = [CJUtilityTools timeStampWithTimeStr:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"create_time"]]];
    

        //评论模式
    if ([[cellDict valueForKey:@"respond_comment"] isKindOfClass:[NSNull class]])
    {
        cell.content.text = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]]];
        
        //约束设置
        cell.imageToTop.priority = 999;
        cell.imageToReply.priority = 998;
        
        //上次回复文本
        cell.respond_content.text = nil;
        cell.respond_content.hidden = YES;
    }
    else    //回复模式
    {
        //上次回复数据字典
        NSDictionary *res_Dict = [NSDictionary dictionaryWithDictionary:[cellDict valueForKey:@"respond_comment"]];
        
        //被回复人
        NSString *respond_name = [cellDict valueForKey:@"respond_user_name"];
        NSMutableString *respond_Str = [[NSMutableString alloc] initWithString:@"回复@:"];
        [respond_Str insertString:respond_name atIndex:3];
        NSString *content = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]]];
        [respond_Str appendString:content];
        cell.content.text = respond_Str;
        
        //约束设置
        cell.imageToReply.priority = 999;
        cell.imageToTop.priority = 998;
        
        //上次回复文本⬇️
        //可变原始串@
        NSMutableString *contentStr = [[NSMutableString alloc] initWithString:@"@"];
        //回复人
        NSString *nickname = [NSString stringWithFormat:@"%@",[res_Dict valueForKey:@"nickname"]];
        //固定串
        NSMutableString *tempStr1 = [[NSMutableString alloc] initWithString:@"回复:"];
        //被回复人
        NSString *res_name = [NSString stringWithFormat:@"%@",[res_Dict valueForKey:@"respond_user_name"]];
        //串拼接
        [tempStr1 insertString:res_name atIndex:2];
        //上次回复文字
        NSString *res_Content = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[res_Dict valueForKey:@"content"]]];
        //多串拼接
        [contentStr appendString:nickname];
        [contentStr appendString:tempStr1];
        [contentStr appendString:res_Content];
        
        cell.respond_content.text = contentStr;
        cell.respond_content.hidden = NO;
    }
    
    //微博原数据字典
    NSDictionary *ori_Dict = [NSDictionary dictionaryWithDictionary:[cellDict valueForKey:@"original_dynamic"]];
    
    //原微博图片
    NSArray *imageArr = [CJUtilityTools imageUrlArrWithUrlStr:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"clear_img"]]];
    //博主头像
    NSURL *ori_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"head_img"]]];
    if (imageArr.count != 0)
    {
        [cell.ori_image sd_setImageWithURL:imageArr[0] placeholderImage:PLACE_HOLDERIMAGE];
    } else {
        [cell.ori_image sd_setImageWithURL:ori_url placeholderImage:PLACE_HOLDERIMAGE];
    }
    
    //原微博at谁
    NSString *at = [@"@" stringByAppendingString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"nickname"]]];
    cell.atLable.text = at;
    
    //原微博正文
    cell.ori_content.text = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"content"]]];
    
    //回复按钮点击
    __block typeof (self)weakSelf = self;
    cell.toReply = ^(){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CJReplyController *rc = [mainStoryboard instantiateViewControllerWithIdentifier:@"CJReplyNC"];
        rc.weiBo_ID =[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"id"]];
        rc.respond_comment_id = [NSString stringWithFormat:@"%@",[cellDict valueForKey:@"id"]];
        rc.respond_user_id = [NSString stringWithFormat:@"%@",[cellDict valueForKey:@"user_id"]];
        [weakSelf.navigationController pushViewController:rc animated:YES];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[commentArray[indexPath.row] valueForKey:@"cellHeight"] floatValue];
}

@end
