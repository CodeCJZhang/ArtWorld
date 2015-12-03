//
//  AW_ArtCommentDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/29.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ArtCommentDataSource.h"
#import "AW_ArtCommentModal.h"//评论modal
#import "AW_ArtCommentCell.h"//评论cell
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "CJUtilityTools.h"

@interface AW_ArtCommentDataSource()

/**
 *  @author cao, 15-10-29 18:10:02
 *
 *  总页数
 */
@property(nonatomic,copy)NSString * totalPage;
/**
 *  @author cao, 15-10-29 23:10:05
 *
 *  带回复的cell
 */
@property(nonatomic,strong)AW_ArtCommentCell * commentWithReplyCell;
/**
 *  @author cao, 15-10-29 23:10:08
 *
 *  不带回复的cell
 */
@property(nonatomic,strong)AW_ArtCommentCell * commentWithoutReplyCell;

@end

@implementation AW_ArtCommentDataSource

-(AW_ArtCommentCell*)commentWithReplyCell{
    if (!_commentWithReplyCell) {
        _commentWithReplyCell = [[NSBundle mainBundle]loadNibNamed:@"_commentWithReplyCell" owner:self options:nil][1];
    }
    return _commentWithReplyCell;
}

-(AW_ArtCommentCell*)commentWithoutReplyCell{
    if (!_commentWithoutReplyCell) {
        _commentWithoutReplyCell = BundleToObj(@"AW_ArtCommentCell");
    }
    return _commentWithoutReplyCell;
}

#pragma mark - GetData Menthod
-(void)refreshData{
    if (self.dataArr.count > 0) {
        [self.dataArr removeAllObjects];
    }
    self.currentPage = @"1";
    [self performSelector:@selector(getCommentData) withObject:nil afterDelay:1];
}

-(void)nextPageData{
    //只有页数大于1时才进行上提分页(将当前页码加上1)
    self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] + 1];
    NSLog(@"当前的页数:%@",self.currentPage);
    if ([self.totalPage intValue] > 10 && ([self.currentPage intValue]*10 <[self.totalPage intValue])){
        [self performSelector:@selector(getCommentData) withObject:nil afterDelay:1];
    }
}

-(void)getCommentData{
    __weak typeof(self) weakSelf = self;
   //在这进行请求
    NSDictionary * dict = @{
                          @"id":self.Art_id,
                          @"pageSize":@"10",
                          @"pageNumber":self.currentPage,
                        };
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * commentDict = @{@"param":@"getCommodityCom",@"jsonParam":string};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:commentDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        //将总页数记录下来
        weakSelf.totalPage = [responseObject[@"info"]valueForKey:@"totalNumber"];
        NSArray * commentArray = [responseObject[@"info"]valueForKey:@"data"];
            if ([responseObject[@"code"]intValue] == 0) {
                
                [commentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary * dict = obj;
                if (dict[@"reply"]) {
                    AW_ArtCommentModal * modal = [[AW_ArtCommentModal alloc]init];
                    modal.comment_id = dict[@"id"];
                    modal.nickname = dict[@"nickname"];
                    modal.head_img = dict[@"head_img"];
                    modal.evaluation = dict[@"evaluation"];
                    modal.content = dict[@"content"];
                    modal.comment_time = dict[@"comment_time"];
                    modal.cellType = @"commentWithoutReply";
                    modal.rowHeight = [weakSelf commentWithoutReplyHeightWithModal:modal];
                    [weakSelf.dataArr addObject:modal];
                }else{
                    AW_ArtCommentModal * modal = [[AW_ArtCommentModal alloc]init];
                    modal.comment_id = dict[@"id"];
                    modal.nickname = dict[@"nickname"];
                    modal.head_img = dict[@"head_img"];
                    modal.evaluation = dict[@"evaluation"];
                    modal.content = dict[@"content"];
                    modal.comment_time = dict[@"comment_time"];
                    modal.reply = dict[@"reply"];
                    modal.cellType = @"commentWithReply";
                    modal.rowHeight = [weakSelf commentWithoutReplyHeightWithModal:modal];
                    [weakSelf.dataArr addObject:modal];
                }
            }];
            if (([weakSelf.currentPage intValue]*10 < [weakSelf.totalPage intValue]) && [weakSelf.totalPage intValue] > 10) {
                weakSelf.tableView.footerHidden = NO;
            }
            [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
}

#pragma mark - CalculationHeight Menthod
-(CGFloat)commentWithReplyCellHeightWithModal:(AW_ArtCommentModal*)modal{
    self.commentWithReplyCell.comment_label.preferredMaxLayoutWidth = kSCREEN_WIDTH - 16;
    self.commentWithReplyCell.reply.preferredMaxLayoutWidth = kSCREEN_WIDTH - 16;
    self.commentWithReplyCell.comment_label.text = modal.content;
    self.commentWithReplyCell.reply.text = modal.reply;
    [self.commentWithReplyCell.comment_label sizeToFit];
    [self.commentWithReplyCell.reply sizeToFit];
    [self.commentWithReplyCell.contentView layoutIfNeeded];
    [self.commentWithReplyCell layoutIfNeeded];
    
    CGSize size = [self.commentWithReplyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

-(CGFloat)commentWithoutReplyHeightWithModal:(AW_ArtCommentModal*)modal{
    self.commentWithoutReplyCell.comment_label.preferredMaxLayoutWidth = kSCREEN_WIDTH - 16;
    if (modal.content) {
        self.commentWithoutReplyCell.comment_label.text = [NSString stringWithFormat:@"%@",modal.content];
    }
    [self.commentWithoutReplyCell.comment_label sizeToFit];
    [self.commentWithoutReplyCell.contentView layoutIfNeeded];
    [self.commentWithoutReplyCell layoutIfNeeded];
    
    CGSize size = [self.commentWithoutReplyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_ArtCommentModal * modal;
    if (self.dataArr.count > 0) {
       modal = self.dataArr[indexPath.row];
    }
    if ([modal.cellType isEqualToString:@"commentWithReply"]) {
        return [self configCommentCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if ([modal.cellType isEqualToString:@"commentWithoutReply"]){
        return [self configCommentWithoutReplyCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_ArtCommentModal * modal;
    if (self.dataArr.count > 0) {
        modal = self.dataArr[indexPath.row];
    }
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

#pragma mark - ConfigCell Menthod

-(AW_ArtCommentCell*)configCommentCellWithModal:(AW_ArtCommentModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"commentCell";
    AW_ArtCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"AW_ArtCommentCell" owner:self options:nil][1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString * currentTime = [CJUtilityTools timeStampWithTimeStr:modal.comment_time];
    NSLog(@"%@",currentTime);
    
    [cell.head_img sd_setImageWithURL:[NSURL URLWithString:modal.head_img] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    cell.comment_time.text = [NSString stringWithFormat:@"%@",currentTime];
    cell.comment_name.text = [NSString stringWithFormat:@"%@",modal.nickname];
    if (![modal.content isKindOfClass:[NSNull class]]) {
        cell.comment_label.text = [NSString stringWithFormat:@"%@",modal.content];
    }
    if ([modal.evaluation floatValue] == 0) {
        modal.evaluation = @"5";
        [cell floatForStarViewWith:@"5"];
    }else{
       [cell floatForStarViewWith:modal.evaluation];
    }
    
    NSLog(@"%@",modal.reply);
    cell.reply.text = [NSString stringWithFormat:@"【店主回复】: %@",modal.reply];
    return cell;
}

-(AW_ArtCommentCell*)configCommentWithoutReplyCellWithModal:(AW_ArtCommentModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"commentCell";
    AW_ArtCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell){
        cell = BundleToObj(@"AW_ArtCommentCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString * currentTime = [CJUtilityTools timeStampWithTimeStr:modal.comment_time];
    NSLog(@"%@",currentTime);
    [cell.head_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",modal.head_img]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    if (modal.comment_time) {
        cell.comment_time.text = [NSString stringWithFormat:@"%@",currentTime];
    }
    if (modal.nickname) {
        cell.comment_name.text = [NSString stringWithFormat:@"%@",modal.nickname];
    }
    if (![modal.content isKindOfClass:[NSNull class]]) {
        cell.comment_label.text = [NSString stringWithFormat:@"%@",modal.content];
    }
    if ([modal.evaluation floatValue] == 0) {
        modal.evaluation = @"5";
        [cell floatForStarViewWith:@"5"];
    }else{
        [cell floatForStarViewWith:modal.evaluation];
    }
   return cell;
}

@end
