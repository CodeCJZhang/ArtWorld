//
//  AW_SelectColorDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/18.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SelectColorDataSource.h"
#import "AW_ArticleDetileCell.h"
#import "AW_DescribeLabelCell.h"
#import "AW_ColorSelectCell.h"
#import "AW_PresentArticleViewModal.h" //弹出商品详情modal
#import "UIImageView+WebCache.h"
#import "AW_MyShopCartModal.h"

@interface AW_SelectColorDataSource()
/**
 *  @author cao, 15-09-19 11:09:27
 *
 *  计算labelCell高度
 */
@property(nonatomic,strong)AW_DescribeLabelCell * labelCell;
/**
 *  @author cao, 15-09-20 10:09:35
 *
 *  记录选中的btn是哪一个
 */
@property(nonatomic,strong)NSMutableArray * selectColorBtnArray;
@end

@implementation AW_SelectColorDataSource

-(AW_DescribeLabelCell*)labelCell{
    if (!_labelCell) {
        _labelCell = BundleToObj(@"AW_DescribeLabelCell");
    }
    return _labelCell;
}

-(NSMutableArray*)selectColorBtnArray{
    if (!_selectColorBtnArray) {
        _selectColorBtnArray = [[NSMutableArray alloc]init];
    }
    return _selectColorBtnArray;
}

#pragma mark - GetData Menthod
-(void)getData{
#warning 测试数据。。。。。。。。。
    __weak typeof(self) weakSelf = self;
    NSArray * array = @[@"topCell",@"separator",@"产品详情",@"labelCell1",@"尺寸 :",@"颜色 :",@"工艺 :",@"创作理念 :",@"labelCell2",@"产地 :",@"发货地 :",@"separator"];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            if (idx == 0) {
            AW_CommodityModal * commidityModal = [[AW_CommodityModal alloc]init];
                NSLog(@"===%@====",weakSelf.shopCartModal.commodityModal.commodityTyde);
                commidityModal.clearImageURL = weakSelf.shopCartModal.commodityModal.clearImageURL;
                commidityModal.commodityTyde = weakSelf.shopCartModal.commodityModal.commodityTyde;
            AW_PresentArticleViewModal * modal = [[AW_PresentArticleViewModal alloc]init];
            modal.articleModal = commidityModal;
            modal.rowHeight = 125;
            modal.type = @"topCell";
                
            [weakSelf.dataArr addObject:modal];
            }else if ([obj isEqualToString:@"separator"]){
                AW_PresentArticleViewModal * modal = [[AW_PresentArticleViewModal alloc]init];
                modal.rowHeight = kMarginBetweenCompontents;
                modal.type = @"separatorCell";
                [weakSelf.dataArr addObject:modal];
            }else if ([obj isEqual:@"labelCell1"]){
                AW_PresentArticleViewModal * modal = [[AW_PresentArticleViewModal alloc]init];
                modal.presentArticleDetail = @"每一件收藏品都是一种文化的独立存在，都在记录着一段独特的历史，《艺术品鉴》旨在以物为线，串起包括历史、人文、艺术、民俗等文化门类在内的中国传统文化要素。格物致知，以物及人、及文、及事、及史，进而推动对中国传统文化与当代人文、艺术的传承、弘扬、发展及海内外文化交流，带动现世以收藏鉴赏为主导的主流文化现象，唤起人们对传统文化的认知与觉悟";
                modal.rowHeight = [self.labelCell labelHeightWith:modal.presentArticleDetail]+21;
                modal.type = @"produceDetailCell";
                [weakSelf.dataArr addObject:modal];
            }else if([obj isEqual:@"labelCell2"]){
                AW_PresentArticleViewModal * modal = [[AW_PresentArticleViewModal alloc]init];
                modal.createIdea = @"每一件收藏品都是一种文化的独立存在，都在记录着一段独特的历史，《艺术品鉴》旨在以物为线，串起包括历史、人文、艺术、民俗等文化门类在内的中国传统文化要素。格物致知，以物及人、及文、及事、及史";
                modal.rowHeight = [self.labelCell labelHeightWith:modal.createIdea]+21;
                modal.type = @"createIdeaCell";
                [weakSelf.dataArr addObject:modal];
            }else{
                AW_PresentArticleViewModal * modal = [[AW_PresentArticleViewModal alloc]init];
                modal.rowHeight = 40;
                modal.leftLabelString = obj;
                if (idx == 6||idx == 9 ) {
                    modal.hasSeparate = YES;
                }
                if (idx == 4 || idx == 5||idx == 6||idx == 9) {
                    modal.hasTopSeparator = YES;
                }
                modal.type = @"articleCell";
                [weakSelf.dataArr addObject:modal];
            }
        }
    }];
    [self dataDidLoad];
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_PresentArticleViewModal * modal = self.dataArr[indexPath.row];
    
    if (modal.rowHeight == 125) {
        return [self configProduceTopCellWithModal:modal.articleModal tableView:tableView indexPath:indexPath];
    }else if (modal.rowHeight == 8){
        return [self configSeparatorCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if (indexPath.row == 2){
        return [self configProduceDetailCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if (indexPath.row == 3 ){
        return [self configDetailLabel1CellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if (indexPath.row == 8 ){
        return [self configDetailLabel2CellWithModal:modal tableView:tableView indexPath:indexPath];
    }else {
       return  [self configDetailCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_PresentArticleViewModal *modal = self.dataArr[indexPath.row];
    return modal.rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_PresentArticleViewModal * modal = self.dataArr[indexPath.row];
    if (modal.leftLabelString.length > 0) {
        NSLog(@"====%@====",modal.leftLabelString);
    }
}

#pragma mark - ConfigTableViewCell Menthod
-(AW_ArticleDetileCell*)configDetailCellWithModal:(AW_PresentArticleViewModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
   static NSString * cellId = @"detailCell";
    AW_ArticleDetileCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ArticleDetileCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.leftString.text = modal.leftLabelString;
    if (modal.hasSeparate) {
        [cell hasButtomSeparate:YES];
    }else{
        [cell hasButtomSeparate:NO];
    }
    if (modal.hasTopSeparator) {
        [cell hasTopSeparate:YES];
    }else{
        [cell hasTopSeparate:NO];
    }
    return cell;
}

-(AW_ArticleDetileCell*)configProduceDetailCellWithModal:(AW_PresentArticleViewModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"otherDetailCell";
    AW_ArticleDetileCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AW_ArticleDetileCell" owner:self options:nil][1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(AW_ColorSelectCell*)configProduceTopCellWithModal:(AW_CommodityModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
     static NSString * cellId = @"topCell";
    AW_ColorSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ColorSelectCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.selectColorBtnArray containsObject:[NSNumber numberWithInteger:1]]) {
        cell.redBtn.selected = YES;
        cell.blueBtn.selected = NO;
        cell.grayBtn.selected = NO;
    }else if ([self.selectColorBtnArray containsObject:[NSNumber numberWithInteger:2]]){
        cell.redBtn.selected = NO;
        cell.blueBtn.selected = YES;
        cell.grayBtn.selected = NO;
    }else if ([self.selectColorBtnArray containsObject:[NSNumber numberWithInteger:3]]){
        cell.redBtn.selected = NO;
        cell.blueBtn.selected = NO;
        cell.grayBtn.selected = YES;
    }
    //点击颜色选择按钮的回调
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    cell.didClickColorBtn = ^(NSInteger index){
        if (index == 1) {
            if (weakCell.redBtn.selected == YES) {
                [weakSelf.selectColorBtnArray addObject:[NSNumber numberWithInteger:1]];
                if ([weakSelf.selectColorBtnArray containsObject:[NSNumber numberWithInteger:2]]) {
                    [weakSelf.selectColorBtnArray removeObject:[NSNumber numberWithInteger:2]];
                }
                if ([weakSelf.selectColorBtnArray containsObject:[NSNumber numberWithInteger:3]]) {
                    [weakSelf.selectColorBtnArray removeObject:[NSNumber numberWithInteger:3]];
                }
            }else if (weakCell.redBtn.selected == NO){
                if ([weakSelf.selectColorBtnArray containsObject:[NSNumber numberWithInteger:1]]) {
                    [weakSelf.selectColorBtnArray removeObject:[NSNumber numberWithInteger:1]];
                }
            }
        }else if (index == 2){
            if (weakCell.blueBtn.selected == YES) {
                [weakSelf.selectColorBtnArray addObject:[NSNumber numberWithInteger:2]];
                if ([weakSelf.selectColorBtnArray containsObject:[NSNumber numberWithInteger:1]]) {
                    [weakSelf.selectColorBtnArray removeObject:[NSNumber numberWithInteger:1]];
                }
                if ([weakSelf.selectColorBtnArray containsObject:[NSNumber numberWithInteger:3]]) {
                    [weakSelf.selectColorBtnArray removeObject:[NSNumber numberWithInteger:3]];
                }
            }else if (weakCell.blueBtn.selected == NO){
                if ([weakSelf.selectColorBtnArray containsObject:[NSNumber numberWithInteger:2]]) {
                    [weakSelf.selectColorBtnArray removeObject:[NSNumber numberWithInteger:2]];
                }
            }
        }else if (index == 3){
            if (weakCell.grayBtn.selected == YES) {
                [weakSelf.selectColorBtnArray addObject:[NSNumber numberWithInteger:3]];
                if ([weakSelf.selectColorBtnArray containsObject:[NSNumber numberWithInteger:1]]) {
                    [weakSelf.selectColorBtnArray removeObject:[NSNumber numberWithInteger:1]];
                }
                if ([weakSelf.selectColorBtnArray containsObject:[NSNumber numberWithInteger:2]]) {
                    [weakSelf.selectColorBtnArray removeObject:[NSNumber numberWithInteger:2]];
                }
            }else if (weakCell.blueBtn.selected == NO){
                if ([weakSelf.selectColorBtnArray containsObject:[NSNumber numberWithInteger:3]]) {
                    [weakSelf.selectColorBtnArray removeObject:[NSNumber numberWithInteger:3]];
                }
            }
        }
    };
    cell.artDescribe.text = modal.commodityTyde;
    [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.clearImageURL]];
    return cell;
}

-(AW_DescribeLabelCell*)configDetailLabel1CellWithModal:(AW_PresentArticleViewModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"produceDetailCell1";
    AW_DescribeLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_DescribeLabelCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.detailLabel.text = modal.presentArticleDetail;
    [cell labelHeightWith:modal.presentArticleDetail];
    return cell;
}

-(AW_DescribeLabelCell*)configDetailLabel2CellWithModal:(AW_PresentArticleViewModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"produceDetailCell2";
    AW_DescribeLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_DescribeLabelCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.detailLabel.text = modal.createIdea;
    [cell labelHeightWith:modal.createIdea];
    return cell;
}

-(UITableViewCell*)configSeparatorCellWithModal:(AW_PresentArticleViewModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"separatorCell";
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
