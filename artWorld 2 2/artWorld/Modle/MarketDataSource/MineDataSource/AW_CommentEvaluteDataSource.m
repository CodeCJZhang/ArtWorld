//
//  AW_CommentEvaluteDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_CommentEvaluteDataSource.h"
#import "AW_CommentCell.h"
#import "AW_StoreCommentCell.h"
#import "AW_MyOrderModal.h"
#import "UIImageView+WebCache.h"
#import "Node.h"

@interface AW_CommentEvaluteDataSource()

@end

@implementation AW_CommentEvaluteDataSource

#pragma mark - GetData Menthod
-(void)getData{
    __weak typeof(self) weakSelf = self;
   //对上个界面传过来的modal进行处理
    [self.orderModal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        AW_MyOrderModal * tmpModal = obj;
        AW_CommodityModal * articleModal = tmpModal.CommodityModal;
        //插入分割线
        AW_MyOrderModal * separator = [[AW_MyOrderModal alloc]init];
        separator.rowHeight = 8;
        [weakSelf.dataArr addObject:separator];
        //插入商品
        AW_CommodityModal * sonModal = [[AW_CommodityModal alloc]init];
        AW_MyOrderModal * commodityModal = [[AW_MyOrderModal alloc]init];
        sonModal = articleModal;
        NSLog(@"===%@===",sonModal.clearImageURL);
        sonModal.comment_content = @"";
        sonModal.comment_state = @"1";
        commodityModal.CommodityModal = sonModal;
        commodityModal.rowHeight = 150;
        [weakSelf.dataArr addObject:commodityModal];
    }];
    
    //插入分割线
    AW_MyOrderModal * separatorTwo = [[AW_MyOrderModal alloc]init];
    separatorTwo.rowHeight = 8;
    [weakSelf.dataArr addObject:separatorTwo];
    
    //插入商铺modal
    AW_MyOrderModal * storeModal = [[AW_MyOrderModal alloc]init];
    storeModal.orderId = self.orderModal.OrderStoreModal.orderId;
    AW_StoreModal * tmpModal = [[AW_StoreModal alloc]init];
    storeModal.storeModal = tmpModal;
    NSLog(@"%@",self.orderModal.OrderStoreModal.storeModal.shop_Id);
    tmpModal.shop_Id = self.orderModal.OrderStoreModal.storeModal.shop_Id;
    tmpModal.content_grade = @"3";
    tmpModal.flow_grade = @"3";
    tmpModal.service_attitude = @"3";
    storeModal.rowHeight = 176;
    [weakSelf.dataArr addObject:storeModal];
    
    //插入分割线
    AW_MyOrderModal * separatorT = [[AW_MyOrderModal alloc]init];
    separatorT.rowHeight = 8;
    [weakSelf.dataArr addObject:separatorT];
    NSLog(@"订单id：%@",self.orderModal.orderId);
    [self dataDidLoad];
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyOrderModal * modal = self.dataArr[indexPath.row];
    if (modal.rowHeight == 8) {
        return [self configSeparateCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if (modal.rowHeight == 176){
        return [self configStoreCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if (modal.rowHeight == 150){
        return [self configArticleCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else{
        return nil;
    }
}
#pragma mark - UITableViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyOrderModal * modal  = self.dataArr[indexPath.row];
    return modal.rowHeight;
}

#pragma mark - ConfigTableViewCell Menthod
-(AW_CommentCell*)configArticleCellWithModal:(AW_MyOrderModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  static NSString * cellId = @"articleCell";
    AW_CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_CommentCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if ([modal.CommodityModal.comment_state intValue] == 1) {
        cell.goodLabel.textColor = [UIColor whiteColor];
        cell.middleLabel.textColor = HexRGB(0x88c244);
        cell.badLabel.textColor = [UIColor lightGrayColor];
        cell.middleBtn.selected = NO;
        cell.badBtn.selected = NO;
        cell.goodBtn.selected = YES;
    }
    if ([modal.CommodityModal.comment_state intValue] == 2) {
        cell.goodLabel.textColor = [UIColor redColor];
        cell.middleLabel.textColor = [UIColor whiteColor];
        cell.badLabel.textColor = [UIColor lightGrayColor];
        cell.middleBtn.selected = YES;
        cell.badBtn.selected = NO;
        cell.goodBtn.selected = NO;
    }
    if ([modal.CommodityModal.comment_state intValue] == 3) {
        cell.goodLabel.textColor = [UIColor redColor];
        cell.middleLabel.textColor = HexRGB(0x88c244);
        cell.badLabel.textColor = [UIColor whiteColor];
        cell.middleBtn.selected = NO;
        cell.badBtn.selected = YES;
        cell.goodBtn.selected = NO;
    }
    cell.commentTextView.placeholder = @"请填写评论内容";
//编辑评价内容的回调
    cell.didEditeTextView = ^(NSString * str){
        NSLog(@"%@",str);
        modal.CommodityModal.comment_content = str;
    };
//======================点击评价按钮后的回调=============
    __weak typeof(cell) weakCell = cell;
    cell.didClickCommentBtn = ^(NSInteger index){
        if (index == 1) {
            UIView * v = [weakCell.goodBtn superview];
            UIView *v1 = [v superview];
            UIView * v2 = [v1 superview];
            UIView * v3 = [v2 superview];
            AW_CommentCell * cell = (AW_CommentCell*)[v3 superview];
            cell.goodLabel.textColor = [UIColor whiteColor];
            NSIndexPath * path = [tableView indexPathForCell:cell];

            cell.goodLabel.textColor = [UIColor whiteColor];
            cell.middleLabel.textColor = HexRGB(0x88c244);
            cell.badLabel.textColor = [UIColor lightGrayColor];
            cell.middleBtn.selected = NO;
            cell.badBtn.selected = NO;
            cell.goodBtn.selected = YES;
            modal.CommodityModal.comment_state = @"1";
        }else if(index == 2){
            UIView * v = [weakCell.middleBtn superview];
            UIView *v1 = [v superview];
            UIView * v2 = [v1 superview];
            UIView * v3 = [v2 superview];
            AW_CommentCell * cell = (AW_CommentCell*)[v3 superview];
            cell.goodLabel.textColor = [UIColor redColor];
            NSIndexPath * path = [tableView indexPathForCell:cell];

            cell.goodLabel.textColor = [UIColor redColor];
            cell.middleLabel.textColor = [UIColor whiteColor];
            cell.badLabel.textColor = [UIColor lightGrayColor];
            cell.middleBtn.selected = YES;
            cell.badBtn.selected = NO;
            cell.goodBtn.selected = NO;
            modal.CommodityModal.comment_state = @"2";
        }else if (index == 3){
            UIView * v = [weakCell.badBtn superview];
            UIView *v1 = [v superview];
            UIView * v2 = [v1 superview];
            UIView * v3 = [v2 superview];
            AW_CommentCell * cell = (AW_CommentCell*)[v3 superview];
            NSIndexPath * path = [tableView indexPathForCell:cell];
            //将索引存入数组

            cell.goodLabel.textColor = [UIColor redColor];
            cell.middleLabel.textColor = HexRGB(0x88c244);
            cell.badLabel.textColor = [UIColor whiteColor];
            cell.middleBtn.selected = NO;
            cell.badBtn.selected = YES;
            cell.goodBtn.selected = NO;
            modal.CommodityModal.comment_state = @"3";
        }
    };
    [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:modal.CommodityModal.clearImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    cell.articleDes.text = [NSString stringWithFormat:@"%@",modal.CommodityModal.commodityTyde];
    cell.articlePrice.text = [NSString stringWithFormat:@"￥%.2f",modal.CommodityModal.commodityPrice.floatValue];
    cell.commentTextView.text = [NSString stringWithFormat:@"%@",modal.CommodityModal.comment_content];
    return cell;
}

-(AW_StoreCommentCell*)configStoreCellWithModal:(AW_MyOrderModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"storeCell";
    AW_StoreCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_StoreCommentCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.describeButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * btn = obj;
        if (idx < [modal.storeModal.content_grade intValue]) {
            btn.selected = YES;
        }
    }];
    [cell.deliveryButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton* btn = obj;
        if (idx < [modal.storeModal.flow_grade intValue] ) {
            btn.selected = YES;
        }
    }];
    [cell.seviercesButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton*btn = obj;
        if (idx < [modal.storeModal.service_attitude intValue]) {
            btn.selected = YES;
        }
    }];
//======================点击与描述相符的按钮的回调========================
    __weak typeof(cell) weakCell = cell;
    cell.didClickDescribeBtn = ^(NSInteger index){
        NSLog(@"%ld",index);
         modal.storeModal.content_grade = [NSString stringWithFormat:@"%ld",index];
        [weakCell.describeButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton * btn = obj;
            if (idx+1 <= [modal.storeModal.content_grade intValue]) {
                btn.selected = YES;
            }else if(idx+1 > [modal.storeModal.content_grade intValue]){
                btn.selected = NO;
            }
        }];
    };
//=======================点击与物流相关的按钮的回调=====================
    cell.didClickDeliveryBtn = ^(NSInteger index){
         modal.storeModal.flow_grade = [NSString stringWithFormat:@"%ld",index];
       [weakCell.deliveryButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           UIButton * btn = obj;
           if (idx+1 <= [modal.storeModal.flow_grade intValue]) {
               btn.selected = YES;
           }else if(idx+1 > [modal.storeModal.flow_grade intValue]){
               btn.selected = NO;
           }
       }];
    };
//=======================点击与服务态度相关的按钮的回调=====================
    cell.didClickSericeBtn = ^(NSInteger index){
        modal.storeModal.service_attitude = [NSString stringWithFormat:@"%ld",index];
        [weakCell.seviercesButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton * btn = obj;
            if (idx+1 <= [modal.storeModal.service_attitude intValue]) {
                btn.selected = YES;
            }else if(idx+1 > [modal.storeModal.service_attitude intValue]){
                btn.selected = NO;
            }
        }];
    };
    return cell;
}

-(UITableViewCell*)configSeparateCellWithModal:(AW_MyOrderModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"separateCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
@end
