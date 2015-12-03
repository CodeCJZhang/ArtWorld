//
//  AW_NewsRemindDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/28.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_NewsRemindDataSource.h"
#import "AW_NewsRemindCell.h"
#import "AW_NewsRemindModal.h"

@implementation AW_NewsRemindDataSource

#pragma mark - GetData Menthod
-(void)getData{
    __weak typeof(self) weakSelf = self;
    NSArray * tmpArray = @[@"商城消息提醒",@"圈子消息提醒",@"即时通讯消息提醒"];
    
    [tmpArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString  * string = obj;
        AW_NewsRemindModal * seperate = [[AW_NewsRemindModal alloc]init];
        seperate.rowHeight = kMarginBetweenCompontents;
        seperate.isSeparate = YES;
        [weakSelf.dataArr addObject:seperate];
        
        AW_NewsRemindModal * modal = [[AW_NewsRemindModal alloc]init];
        modal.rowHeight = 44;
        modal.newsRemindString = string;
        [weakSelf.dataArr addObject:modal];
    }];
    [self dataDidLoad];
}


#pragma mark - UITableViewDataSource Menthod

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_NewsRemindModal * modal = self.dataArr[indexPath.row];
    if (modal.isSeparate == YES) {
        static NSString * cellId = @"seperateCell";
        UITableViewCell *  cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
        static NSString * cellId = @"newsCell";
        AW_NewsRemindCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = BundleToObj(@"AW_NewsRemindCell");
        }
        cell.newsLabel.text = modal.newsRemindString;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_NewsRemindModal * modal = self.dataArr[indexPath.row];
    return modal.rowHeight;
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
