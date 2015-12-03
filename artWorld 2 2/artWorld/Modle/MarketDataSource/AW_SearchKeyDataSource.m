//
//  AW_SearchKeyDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/30.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_SearchKeyDataSource.h"
#import "AFNetworking.h"
#import "AW_PersonSearchCell.h"
#import "AW_PersonSearchModal.h"
#import "UIImageView+WebCache.h"
#import "SearchDataBaseHelper.h"
#import "SVProgressHUD.h"

@interface AW_SearchKeyDataSource()

@end

@implementation AW_SearchKeyDataSource

#pragma mark - GetData Menthod
-(void)getData{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    NSString * user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSLog(@"%@",user_id);
    //在这进行请求
    NSDictionary * dict = @{
                            @"keyWord":self.searchString,
                            @"pageSize":@"10",
                            @"pageNumber":self.currentPage,
                            @"userId":user_id
                            };
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * searchDict = @{@"param":@"searchUser",@"jsonParam":str,@"token":@"android"};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:searchDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSArray * userArray = [responseObject[@"info"]valueForKey:@"data"];
        if (userArray) {
            if (userArray.count > 0) {
                //将搜索关键字存到数据库
                SearchDataBaseHelper * helper = [[SearchDataBaseHelper alloc]init];
                NSMutableArray * tmpArray = [helper queryAllKeyWord];
                if (![tmpArray containsObject:self.searchString]) {
                    [helper addKeyWord:self.searchString];
                }
            }
        }
        if ([responseObject[@"code"]intValue] == 0) {
           [userArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               NSDictionary * dict = obj;
               AW_PersonSearchModal * modal = [[AW_PersonSearchModal alloc]init];
               modal.head_image = dict[@"head_img"];
               modal.nick_name = dict[@"nickname"];
               modal.authentication_state = dict[@"authentication_state"];
               modal.isAttended = dict[@"isAttended"];
               modal.person_id = dict[@"id"];
               [weakSelf.dataArr addObject:modal];
           }];
        }
        //判断是否显示下拉刷新
        if (([weakSelf.currentPage intValue]*10 < [weakSelf.totolPage intValue]) && [weakSelf.totolPage intValue] > 10) {
            self.tableView.footerHidden = NO;
        }else{
            self.tableView.footerHidden = YES;
        }
        [SVProgressHUD dismiss];
        [self dataDidLoad];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

-(void)nextPageData{
    if ([self.totolPage intValue] > 10 && ([self.currentPage intValue]*10 < [self.totolPage intValue])){
        //只有页数大于1时才进行上提分页(将当前页码加上1)
        self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] + 1];
        [self performSelector:@selector(getData)withObject:nil afterDelay:1];
    }
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_PersonSearchModal *modal = self.dataArr[indexPath.row];
    static NSString * cellId = @"searchCell";
    AW_PersonSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.index = indexPath.row;
    if (!cell) {
        cell = BundleToObj(@"AW_PersonSearchCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:modal.head_image] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    cell.nickName.text = [NSString stringWithFormat:@"%@",modal.nick_name];
    if ([modal.authentication_state intValue] == 3) {
        cell.vipImage.hidden = NO;
    }else{
        cell.vipImage.hidden = YES;
    }
    cell.didClickedBtn = ^(NSInteger index){
        NSLog(@"%ld",index);
        AW_PersonSearchModal * modal = self.dataArr[index];
        NSLog(@"%@",modal.person_id);
    };
    //点击关注按钮的回调
    cell.didClickedBtn = ^(NSInteger index){
        AW_PersonSearchModal * tmp = self.dataArr[index];
            if (cell.rightButton.selected == YES) {
                //在这进行添加关注请求
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                NSString * user_id = [user objectForKey:@"user_id"];
                NSDictionary * dict = @{@"personId":modal.person_id,@"userId":user_id};
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
                NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary * attendict = @{@"param":@"addAttention",@"jsonParam":str};
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:ARTSCOME_INT parameters:attendict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSLog(@"%@",responseObject);
                    if ([responseObject[@"code"]intValue] == 0) {
                        //请求成功后改变modal值
                        tmp.isAttended = YES;
                    }
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    NSLog(@"%@",[error localizedDescription]);
                }];
                
            }else if (cell.rightButton.selected == NO){
                
                //在这进行取消关注请求
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                NSString * user_id = [user objectForKey:@"user_id"];
                NSDictionary * dict = @{@"personId":modal.person_id,@"userId":user_id};
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
                NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary * cancleDict = @{@"param":@"cancelAttention",@"jsonParam":str};
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:ARTSCOME_INT parameters:cancleDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSLog(@"%@",responseObject);
                    if ([responseObject[@"code"]intValue] == 0) {
                        //请求成功后改变modal值
                        tmp.isAttended = NO;
                    }
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    NSLog(@"%@",[error localizedDescription]);
                }];
            }
    
    };
    return cell;
}

#pragma mark - UITableViewDelegate Menthod

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
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
