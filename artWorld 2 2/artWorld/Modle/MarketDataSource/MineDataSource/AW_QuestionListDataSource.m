//
//  AW_QuestionListDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/10.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_QuestionListDataSource.h"
#import "AW_QuestionModal.h"
#import "AFNetworking.h"
#import "AW_SonQuestionCell.h"

@interface AW_QuestionListDataSource()

@end

@implementation AW_QuestionListDataSource

#pragma mark - GetData Menthod
-(void)getData{
    __weak typeof(self) weakSelf = self;
    NSDictionary * dict = @{
                         @"id":self.column_id,
                         @"pageSize":@"10",
                         @"pageNumber":self.currentPage,
                        };
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * questionDict = @{@"param":@"oftenProblemByType",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:questionDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSArray * tmpArray = [responseObject[@"info"]valueForKey:@"data"];
        if ([responseObject[@"code"]intValue] == 0) {
           [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               NSDictionary * sonDict = obj;
               AW_QuestionModal * modal = [[AW_QuestionModal alloc]init];
               modal.question_id = sonDict[@"id"];
               modal.question_title = sonDict[@"title"];
               modal.question_type = sonDict[@"type"];
               modal.question_content = sonDict[@"content"];
               [weakSelf.dataArr addObject:modal];
           }];
            if (([weakSelf.currentPage intValue]*10 < [weakSelf.totolPage intValue]) && [weakSelf.totolPage intValue] > 10) {
                self.tableView.footerHidden = NO;
            }else{
                self.tableView.footerHidden = YES;
            }
            [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

-(void)refreshData{
    self.currentPage = @"1";
    if (self.dataArr.count > 0) {
        [self.dataArr removeAllObjects];
    }
    [self performSelector:@selector(getData) withObject:nil afterDelay:1];
}

-(void)nextPageData{
    NSLog(@"当前的页数:%@",self.currentPage);
    if ([self.totolPage intValue] > 10 && ([self.currentPage intValue]*10 <[self.totolPage intValue])){
        //只有页数大于1时才进行上提分页(将当前页码加上1)
        self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] + 1];
        [self performSelector:@selector(getData) withObject:nil afterDelay:1];
    }
}

#pragma mark - UITabeleViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AW_QuestionModal * modal = self.dataArr[indexPath.row];
   static NSString * cellId = @"questionCell";
    AW_SonQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_SonQuestionCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.sonQuestion.text = [NSString stringWithFormat:@"%@",modal.question_title];
    return cell;
}

#pragma mark - UITableViewDelegate Menthod
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_QuestionModal * modal = self.dataArr[indexPath.row];
    self.questionModal = modal;
    if (_didClickedCell) {
        _didClickedCell(_questionModal);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0f;
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
