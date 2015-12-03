//
//  CJSearchController.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJSearchController.h"
#import "CJSearchCell.h"
#import "CJMoreContactPersonController.h"
#import "CJMoreArtContentController.h"
#import "MBProgressHUD+NJ.h"
#import "CJWeiboDetailsController.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "AW_Constants.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#define padding 8
#define padding1 10
#define CJTextFont [UIFont systemFontOfSize:15]

@interface CJSearchController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *contactArr;    //联系人集合
    NSMutableArray *ContentArr;    //艺圈内容集合
    
    NSMutableArray *urlArr;   //图片集
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *returnBtn;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) CJSearchCell *cell;

@end

@implementation CJSearchController

- (void)viewDidLoad { 
    [super viewDidLoad];
    
    _returnBtn.image = [[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _tableview.hidden = YES;
}


#pragma mark - IBAction BtnClick

//返回
- (IBAction)returnBtn:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//搜索Btn
- (IBAction)search_btn:(UIButton *)sender
{
    //当点击搜索时显示结果
    if (_searchBar.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入搜索关键词"];
    }
    else
    {
        [self getContactData];
        [self getArtContentData];
        if (contactArr.count != 0 || ContentArr.count != 0)
        {
            [self.tableview reloadData];
            [_searchBar resignFirstResponder];
            _tableview.hidden = NO;
        }
    }
}


#pragma mark - 请求数据

//请求联系人数据
-(void)getContactData
{
    //请求数据
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"pageSize":@"3", @"pageNumber":@"1", @"keyWord":_searchBar.text};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"searchContacts",@"token":@"android",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             contactArr = [NSArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];

             NSLog(@"请求结果:%@",responseObject);
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

//请求内容数据
-(void)getArtContentData
{
    //请求数据
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"pageSize":@"3", @"pageNumber":@"1", @"keyWord":_searchBar.text};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"searchDynamic",@"token":@"android",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             ContentArr = [NSMutableArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];
             
             //计算出每行高度
             [self countCellHeight];
//             [self.tableview reloadData];
             NSLog(@"请求结果:%@",responseObject);
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}


#pragma mark - 计算行高
//遍历ContentArr数组，计算出每行高度并保存
-(void)countCellHeight
{
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:ContentArr.count];
    
    [ContentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        //遍历数组中元素
        NSMutableDictionary *celldict = [NSMutableDictionary dictionaryWithDictionary:obj];
        NSLog(@"celldict = %@",celldict);
        
        //cell高度
        CGFloat sumH;
        
        //判断类型
        NSString *original_Str = [celldict valueForKey:@"original_dynamic"];
        
            //原文模式
        if ([original_Str isKindOfClass:[NSNull class]])
        {
            //微博内容
            NSString *weibo = [NSString stringWithFormat:@"%@",[celldict valueForKey:@"content"]];
            CGFloat textH = [self countTextHeightWithString:weibo placeHolderWidth:(kSCREEN_WIDTH - padding * 2)];
            
            //图片
            NSMutableArray *imgArr;
            NSString *images = [NSString stringWithFormat:@"%@",[celldict valueForKey:@"clear_img"]];
            if ([images isKindOfClass:[NSNull class]])
            {
                imgArr = nil;
            }
            else
            {
                NSArray *tempArr = [images componentsSeparatedByString:@","];
                imgArr = [NSMutableArray arrayWithArray:tempArr];
                NSInteger i = 1;
                while (i)
                {
                    if ([imgArr containsObject:@""])
                    {
                        [imgArr removeObject:@""];
                    }
                    else{
                        i = 0;
                    }
                }
            }
            
            //计算cell高度
            //一张图片的高度
            CGFloat photoH = (kSCREEN_WIDTH - padding * 4) / 3;
            if ([weibo isKindOfClass:[NSNull class]])//没有正文的情况
            {
                if (imgArr.count > 0 && imgArr.count < 4) //一行图片
                {
                    sumH = photoH + 44 + padding * 3;
                }
                else if (imgArr.count > 3 && imgArr.count < 7) //两行图片
                {
                    sumH = photoH * 2 + 44 + padding * 4;
                }
                else if (imgArr.count > 6 && imgArr.count < 10) //三行图片
                {
                    sumH = photoH * 3 + 44 + padding * 5;
                }
            }
            else //有正文的情况
            {
                if (imgArr.count == 0)  //0行图片
                {
                    sumH = textH + 44 + padding * 2 + 4;
                }
                else if(imgArr.count > 0 && imgArr.count < 4) //一行图片
                {
                    sumH = textH + photoH + 44 + padding * 3 + 4;
                }
                else if (imgArr.count > 3 && imgArr.count < 7) //两行图片
                {
                    sumH = textH + photoH * 2 + 44 + padding * 4 + 4;
                }
                else if (imgArr.count > 6 && imgArr.count < 10) //三行图片
                {
                    sumH = textH + photoH * 3 + 44 + padding * 5 + 4;
                }
            }
        }
        else   //转发模式
        {
            /**################## 转发区域 ##################*/
            //转发文字
            NSString *weibo = [NSString stringWithFormat:@"%@",[celldict valueForKey:@"content"]];
            CGFloat textH = [self countTextHeightWithString:weibo placeHolderWidth:(kSCREEN_WIDTH - padding * 2)];//此高度肯定存在

            /**################## 原文区域 ##################*/
            //原文数据
            NSDictionary *ori_dict = [NSDictionary dictionaryWithDictionary:[celldict valueForKey:@"original_dynamic"]];
            
            //原微博区域高度
            CGFloat oriH;
            //微博原文
            NSString *ori_weibo = [NSString stringWithFormat:@"%@",[ori_dict valueForKey:@"content"]];
            CGFloat ori_textH = [self countTextHeightWithString:ori_weibo placeHolderWidth:(kSCREEN_WIDTH - padding * 4)];  //此高度肯定存在
            
            //图片
            NSMutableArray *imgArr;
            NSString *images = [NSString stringWithFormat:@"%@",[ori_dict valueForKey:@"clear_img"]];
            if ([images isKindOfClass:[NSNull class]])
            {
                imgArr = nil;
            }
            else
            {
                NSArray *tempArr = [images componentsSeparatedByString:@","];
                imgArr = [NSMutableArray arrayWithArray:tempArr];
                NSInteger i = 1;
                while (i)
                {
                    if ([imgArr containsObject:@""])
                    {
                        [imgArr removeObject:@""];
                    }
                    else{
                        i = 0;
                    }
                }
            }
            
            //计算cell高度
            //一张图片的高度
            CGFloat photoH = (kSCREEN_WIDTH - padding * 2 - padding1 * 4) / 3;
            
            if (imgArr.count == 0)  //0行图片
            {
                oriH = ori_textH + padding * 2;
                sumH = oriH + 44 + textH + padding * 3 + 4;
            }
            else if (imgArr.count > 0 && imgArr.count < 4)   //1行图片
            {
                oriH = ori_textH + photoH + padding * 3;
                sumH = oriH + 44 + textH + padding * 3 + 4;
            }
            else if (imgArr.count > 3 && imgArr.count < 7)  //2行图片
            {
                oriH = ori_textH + photoH * 2 + padding * 4;
                sumH = oriH + 44 + textH + padding * 3 + 4;
            }
            else if (imgArr.count > 6 && imgArr.count < 10) //3行图片
            {
                oriH = ori_textH + photoH * 3 + padding * 5;
                sumH = oriH + 44 + textH + padding * 3 + 4;
            }
        }
        
        //把cell高度插入数组中
        NSNumber *cellH = [NSNumber numberWithFloat:sumH];
        [celldict setObject:cellH forKey:@"cellHeight"];
        [tempArr addObject:celldict];
    }];
    
    [ContentArr removeAllObjects];
    ContentArr = [tempArr mutableCopy];
}


#pragma mark - 计算文字所占高度
-(CGFloat)countTextHeightWithString:(NSString *)string placeHolderWidth:(CGFloat)width
{
    NSDictionary *dict = @{NSFontAttributeName:CJTextFont};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    CGSize textSize = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    CGFloat textH = textSize.height;
    return textH;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *identifier = @"search";
        CJSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"CJSearchCell" owner:nil options:nil][1];
        }
        //取出当前行数据
        NSDictionary *temp = [NSDictionary dictionaryWithDictionary:contactArr[indexPath.row]];
        
        //头像
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[temp valueForKey:@"head_img"]]];
        [cell.contactsIcon sd_setImageWithURL:iconUrl placeholderImage:PLACE_HOLDERIMAGE];
        
        //昵称
        NSString *name = [NSString stringWithFormat:@"%@",[temp valueForKey:@"nickname"]];
        cell.contactsName.text = name;
        
        //认证
       NSString *state = [NSString stringWithFormat:@"%@",[temp valueForKey:@"authentication_state"]];
        if ([state integerValue] == 3)
        {
            cell.vip.hidden = NO;
        }
        else
        {
            cell.vip.hidden = YES;
        }
        
        //关注
        NSString *attention = [NSString stringWithFormat:@"%@",[temp valueForKey:@"isAttended"]];
        if ([attention boolValue] == YES)
        {
            [cell.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }
        else
        {
            [cell.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
        
        _cell = cell;
    }
    else if (indexPath.section == 1)
    {
        //取出当前行数据
        NSDictionary *temp = [NSDictionary dictionaryWithDictionary:ContentArr[indexPath.row]];
        //动态类型
        NSString *original_Str = [temp valueForKey:@"original_dynamic"];
        
        //原文模式
        if ([original_Str isKindOfClass:[NSNull class]])
        {
            static NSString *identifier = @"search1";
            CJSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if ( cell == nil)
            {
                cell = [[NSBundle mainBundle] loadNibNamed:@"CJSearchCell" owner:nil options:nil][2];
            }
            //头像
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[temp valueForKey:@"head_img"]]];
            [cell.weiboIcon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
            
            //昵称
            cell.weiboName.text = [NSString stringWithFormat:@"%@",[temp valueForKey:@"nickname"]];
            
            //认证
            NSString *state = [NSString stringWithFormat:@"%@",[temp valueForKey:@"authentication_state"]];
            if ([state integerValue] == 3)
            {
                cell.weiboVIP.hidden = NO;
            } else {
                cell.weiboVIP.hidden = YES;
            }
            
            //时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            double timestamp = [[NSString stringWithFormat:@"%@",[temp valueForKey:@"create_time"]] doubleValue] / 1000;
            NSTimeInterval interval = timestamp;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
            NSString *time = [formatter stringFromDate:date];
            cell.weiboTime.text = time;
            
            //正文
            NSString *content = [NSString stringWithFormat:@"%@",[temp valueForKey:@"content"]];
            
            //图片
            NSString *images = [NSString stringWithFormat:@"%@",[temp valueForKey:@"clear_img"]];
            if (images.length != 0)
            {
                NSArray *tempArr = [images componentsSeparatedByString:@","];
                urlArr = [NSMutableArray arrayWithArray:tempArr];
                NSInteger i = 1;
                while (i)
                {
                    if ([urlArr containsObject:@""])
                    {
                        [urlArr removeObject:@""];
                    }
                    else{
                        i = 0;
                    }
                }
            }
            else
            {
                urlArr = nil;
            }
            
            _cell = cell;
            
            [self hasText:content imageArray:urlArr];
        }
        //转发模式
        else
        {
            static NSString *identifier = @"search2";
            CJSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if ( cell == nil)
            {
                cell = [[NSBundle mainBundle] loadNibNamed:@"CJSearchCell" owner:nil options:nil][3];
            }
            //头像
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[temp valueForKey:@"head_img"]]];
            [cell.s_icon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
            
            //昵称
            cell.s_name.text = [NSString stringWithFormat:@"%@",[temp valueForKey:@"nickname"]];
            
            //认证
            NSString *state = [NSString stringWithFormat:@"%@",[temp valueForKey:@"authentication_state"]];
            if ([state integerValue] == 3)
            {
                cell.s_vip.hidden = NO;
            } else {
                cell.s_vip.hidden = YES;
            }
            
            //时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            double timestamp = [[NSString stringWithFormat:@"%@",[temp valueForKey:@"create_time"]] doubleValue] / 1000;
            NSTimeInterval interval = timestamp;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
            NSString *time = [formatter stringFromDate:date];
            cell.s_time.text = time;
            
            //转发文字
            cell.s_weibo.text = [NSString stringWithFormat:@"%@",[temp valueForKey:@"content"]];
            
            //原文数据
            NSDictionary *ori_dict =[NSDictionary dictionaryWithDictionary:[temp valueForKey:@"original_dynamic"]];
            //原文
            NSString *content = [NSString stringWithFormat:@"%@",[ori_dict valueForKey:@"content"]];
            
            //原文图片
            NSString *images = [NSString stringWithFormat:@"%@",[ori_dict valueForKey:@"clear_img"]];
            if (images.length != 0)
            {
                NSArray *tempArr = [images componentsSeparatedByString:@","];
                urlArr = [NSMutableArray arrayWithArray:tempArr];
                NSInteger i = 1;
                while (i)
                {
                    if ([urlArr containsObject:@""])
                    {
                        [urlArr removeObject:@""];
                    }
                    else{
                        i = 0;
                    }
                }
            }
            else
            {
                urlArr = nil;
            }
            
            _cell = cell;
            
            [self designCellWithText:content photoArray:urlArr];
        }
    }
    
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cell.preservesSuperviewLayoutMargins = NO;
    _cell.separatorInset = UIEdgeInsetsZero;
    _cell.layoutMargins = UIEdgeInsetsZero;
    
    return _cell;
}


#pragma mark - cell 布局排版

//转发模式
-(void)designCellWithText:(NSString *)text photoArray:(NSArray *)photoArray
{
    NSInteger photoCount = photoArray.count;
    
    if (text)
    {
        _cell.ori_weibo.text = text;
        _cell.ori_weibo.hidden = NO;
        _cell.photoToWeibo.priority = 999;
        _cell.photoToTop.priority = 998;
    }
    else
    {
        _cell.ori_weibo.hidden = YES;
        _cell.photoToWeibo.priority = 998;
        _cell.photoToTop.priority = 999;
    }
    
    if (photoCount == 0)
    {
        _cell.bottomToWeibo.priority = 999;
        _cell.bottomToFirst.priority = 998;
        _cell.bottomToSecond.priority = 997;
        _cell.bottomToThird.priority = 996;
    }
    else if (photoCount > 0 && photoCount < 4)
    {
        _cell.bottomToFirst.priority = 999;
        _cell.bottomToSecond.priority = 998;
        _cell.bottomToThird.priority = 997;
        _cell.bottomToWeibo.priority = 996;
    }
    else if (photoCount > 3 && photoCount < 7)
    {
        _cell.bottomToSecond.priority = 999;
        _cell.bottomToThird.priority = 998;
        _cell.bottomToFirst.priority = 997;
        _cell.bottomToWeibo.priority = 996;
    }
    else if (photoCount > 6 && photoCount < 10)
    {
        _cell.bottomToThird.priority = 999;
        _cell.bottomToSecond.priority = 998;
        _cell.bottomToFirst.priority = 997;
        _cell.bottomToWeibo.priority = 996;
    }
    
    //隐藏无图片的button
    [_cell.photoArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = obj;
        if (idx < photoCount)
        {
            button.hidden = NO;
        }
        else
        {
            button.hidden = YES;
        }
    }];
    
    //为button附加图片
    if (photoCount > 0 && photoCount < 10)
    {
        for (NSInteger i = 0; i < photoCount; i++)
        {
            UIButton *btn = _cell.photoArr[i];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:photoArray[i]] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE];
        }
    }
}

//原文模式
-(void)hasText:(NSString*)text imageArray:(NSArray *)imageArray
{
    NSInteger arrCount = imageArray.count;
    
    if (text)
    {
        _cell.weiboDesc.text = text;
        _cell.weiboDesc.hidden = NO;
        _cell.photoToDesc.priority = 999;
        _cell.photoToIcon.priority = 998;
    }
    else {
        _cell.weiboDesc.hidden = YES;
        _cell.photoToDesc.priority = 998;
        _cell.photoToIcon.priority = 999;
    }
    
    //隐藏无图片的button
    [_cell.photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = obj;
        if (idx < arrCount)
        {
            button.hidden = NO;
        }
        else
        {
            button.hidden = YES;
        }
    }];
    
    //为button附加图片
    if (arrCount > 0 && arrCount < 10)
    {
        for (NSInteger i = 0; i < arrCount; i++)
        {
            UIButton *btn = _cell.photoArray[i];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageArray[i]] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE];
        }
    }
}


#pragma mark - UITableViewDelegate

//头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CJSearchCell *headerCell = [[[NSBundle mainBundle]loadNibNamed:@"CJSearchCell" owner:nil options:nil]firstObject];

    if (0 == section)
    {
        headerCell.cellHeadLable.text = @"联系人";
    }
    else
    {
        headerCell.cellHeadLable.text = @"艺圈内容";
    }
    return headerCell;
}

//脚视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CJSearchCell *footCell = [[[NSBundle mainBundle]loadNibNamed:@"CJSearchCell" owner:nil options:nil]lastObject];
    
    if (section == 0)
    {
        [footCell.cellFootBtn setTitle:@"更多联系人" forState:UIControlStateNormal];
    }
    else
    {
        [footCell.cellFootBtn setTitle:@"更多艺圈内容" forState:UIControlStateNormal];
    }
    
    //push到更多联系人
    __block typeof (self)weakSelf = self;
    footCell.toMoreContact = ^(){
        CJMoreContactPersonController *cp = [[CJMoreContactPersonController alloc]init];
        cp.keyWord = weakSelf.searchBar.text;
        [weakSelf.navigationController pushViewController:cp animated:YES];
    };
    
    //push到更多艺圈内容
    footCell.toMoreContent = ^(){
        CJMoreArtContentController *ac = [[CJMoreArtContentController alloc]init];
        ac.keyWord = weakSelf.searchBar.text;
        [weakSelf.navigationController pushViewController:ac animated:YES];
    };
    
    return footCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 44;
    }
    else
    {
        return [[ContentArr[indexPath.row] valueForKey:@"cellHeight"] floatValue];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0)
    {
        CJWeiboDetailsController *wdc = [[CJWeiboDetailsController alloc]init];
        
        [self.navigationController pushViewController:wdc animated:YES];
    }
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //让键盘失去第一响应者
    [self.view endEditing:YES];
}


@end
