//
//  AW_LiveAdressDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_LiveAdressDataSource.h"
#import "AW_AdressModal.h"
#import "AW_LiveAdressCell.h"

@interface AW_LiveAdressDataSource()
/**
 *  @author cao, 15-09-27 11:09:51
 *
 *  展示在界面上的数据的数组
 */
@property(nonatomic,strong)NSArray * disPalyArray;
@end
@implementation AW_LiveAdressDataSource

#pragma mark - GetData Menthod
-(void)getData{
    __weak typeof(self) weakSelf = self;
    NSArray * tmpArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
    [tmpArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * dict = obj;
        AW_AdressModal * supAdressModal = [[AW_AdressModal alloc]init];
        supAdressModal.liveAdress = dict[@"state"];
        supAdressModal.level = 1;
        supAdressModal.rowHeight = 45;
        supAdressModal.expand = NO;
        NSArray * tmpArray = dict[@"cities"];
        NSMutableArray * sonAdressArray = [[NSMutableArray alloc]init];
        
        [tmpArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString * string = obj;
            AW_AdressModal * sonModal = [[AW_AdressModal alloc]init];
            sonModal.liveAdress = string;
            sonModal.belongProvince = supAdressModal.liveAdress;
            sonModal.level = 2;
            sonModal.rowHeight = 45;
            sonModal.expand = NO;
            sonModal.subArray = nil;
            [sonAdressArray addObject:sonModal];
        }];
        supAdressModal.subArray = [NSMutableArray arrayWithArray:sonAdressArray];
        [weakSelf.dataArr addObject:supAdressModal];
    }];
}

#pragma mark - Config   DisplayData  Menthod
//获取要展示在界面上的数据集合
-(void)configDisplayData{
    NSMutableArray * tmpArray = [[NSMutableArray alloc]init];
    [self.dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AW_AdressModal * adressModal = obj;
        [tmpArray addObject:adressModal];
        //如果是展开状态就遍历孩子数组中的元素
        if (adressModal.expand) {
            [adressModal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                AW_AdressModal * sonModal = obj;
                [tmpArray addObject:sonModal];
            }];
        }
    }];
    self.disPalyArray = [NSArray arrayWithArray:tmpArray];
    NSLog(@"==%ld==",self.disPalyArray.count);
    [self.tableView reloadData];
}

//修改cell的打开或关闭的状态
-(void)reloadDataForDispalyArrayChangeAt:(NSInteger)index{
    NSMutableArray * tmpArray = [[NSMutableArray alloc]init];
    NSInteger row = 0;
    for (AW_AdressModal * modal in self.dataArr) {
        [tmpArray addObject:modal];
        if (row == index) {
            modal.expand = !modal.expand;
        }
        ++row;
        if (modal.expand) {
            for (AW_AdressModal *sonModal in modal.subArray) {
                [tmpArray addObject:sonModal];
            }
        }
    }
    self.disPalyArray = [NSArray arrayWithArray:tmpArray];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.disPalyArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_AdressModal * modal = self.disPalyArray[indexPath.row];
    static NSString * superCellId = @"superCell";
    static NSString * sonCellId = @"sonCell";
    if (modal.level == 1) {
        AW_LiveAdressCell * cell = [tableView dequeueReusableCellWithIdentifier:superCellId];
        if (!cell) {
            cell = BundleToObj(@"AW_LiveAdressCell");
            cell.liveAdressLabel.text = modal.liveAdress;
            cell.contentView.backgroundColor = HexRGB(0xf6f7f8);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else if (modal.level == 2){
        AW_LiveAdressCell * cell = [tableView dequeueReusableCellWithIdentifier:sonCellId];
        if (!cell) {
            cell = BundleToObj(@"AW_LiveAdressCell");
            cell.liveAdressLabel.text = modal.liveAdress;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDelegate Menthod
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //展开或关闭cell
    [self reloadDataForDispalyArrayChangeAt:indexPath.row];
    //点击cell的回调
    AW_AdressModal * modal = self.disPalyArray[indexPath.row];
    NSMutableString * tmpString = [[NSMutableString alloc]init];
    if (modal.belongProvince) {
        tmpString = [modal.belongProvince copy];
        tmpString = [[tmpString stringByAppendingString:modal.liveAdress] copy];
        NSLog(@"===%@===",tmpString);
    }
    _adressString = tmpString;
    if (_didClickedCell) {
        _didClickedCell(_adressString);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_AdressModal * modal = self.disPalyArray[indexPath.row];
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
