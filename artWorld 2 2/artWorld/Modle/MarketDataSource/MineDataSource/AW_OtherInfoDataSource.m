//
//  AW_OtherInfoDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_OtherInfoDataSource.h"
#import "AFNetworking.h"
#import "AW_PersonalInformationModal.h"
#import "AW_OtherTopInfoCell.h"
#import "AW_OtherMiddleInfoCell.h"
#import "AW_OtherBottomInfoCell.h"
#import "UIImageView+WebCache.h"
#import "AW_Constants.h"

@interface AW_OtherInfoDataSource()
/**
 *  @author cao, 15-11-23 15:11:30
 *
 *  底部cell
 */
@property(nonatomic,strong)AW_OtherBottomInfoCell * bottomCell;

@end

@implementation AW_OtherInfoDataSource

-(AW_OtherBottomInfoCell*)bottomCell{
    if (!_bottomCell) {
        _bottomCell = BundleToObj(@"AW_OtherBottomInfoCell");
    }
    return _bottomCell;
}

#pragma mark - getData Menthod
-(void)getData{
    __weak typeof(self) weakSelf = self;
    //在这进行个人资料请求
    NSDictionary * dict = @{@"userId":self.user_id};
    NSError * error  = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * infoDict = @{@"param":@"ownData",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:infoDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
            //用户信息
            NSDictionary*userDict = [responseObject[@"info"]valueForKey:@"user"];
          //个人偏好数组
            NSArray*hobbyArray = [responseObject[@"info"]valueForKey:@"hobby"];
            NSArray * dataArray = @[@"上部cell",@"",@"中部cell",@"",@"下部cell",@""];
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString * str = obj;
                if ([str isEqualToString:@"上部cell"]) {
                    AW_PersonalInformationModal * topModal = [[AW_PersonalInformationModal alloc]init];
                    topModal.head_img = userDict[@"head_img"];
                    topModal.nickname = userDict[@"nickname"];
                    topModal.rowHeight = 124;
                    topModal.cellType = @"topCell";
                    [weakSelf.dataArr addObject:topModal];
                }else if ([str isEqualToString:@"中部cell"]){
                    AW_PersonalInformationModal * middleModal = [[AW_PersonalInformationModal alloc]init];
                    middleModal.birthday = userDict[@"birthday"];
                    middleModal.province_name = userDict[@"province_name"];
                    middleModal.city_name = userDict[@"city_name"];
                    middleModal.hometown_province_name = userDict[@"hometown_province_name"];
                    middleModal.hometown_city_name = userDict[@"hometown_city_name"];
                    middleModal.personal_label = userDict[@"personal_label"];
                    NSMutableString * string = [[NSMutableString alloc]init];
                    if (hobbyArray.count > 0) {
                        [hobbyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict = obj;
                            NSString * str = dict[@"name"];
                            [string appendString:str];
                            [string appendString:@","];
                        }];
                    }
                    middleModal.hobbyString = [string copy];
                    middleModal.rowHeight = 220;
                    middleModal.cellType = @"middleCell";
                    [weakSelf.dataArr addObject:middleModal];
                }else if ([str isEqualToString:@"下部cell"]){
                    AW_PersonalInformationModal * bottomModal = [[AW_PersonalInformationModal alloc]init];
                    bottomModal.signature = userDict[@"signature"];
                    bottomModal.synopsis = userDict[@"synopsis"];
                    bottomModal.rowHeight = [self.bottomCell heightWithString:bottomModal.synopsis];
                    bottomModal.cellType = @"bottomCell";
                    [weakSelf.dataArr addObject:bottomModal];
                }else if ([str isEqualToString:@""]){
                    AW_PersonalInformationModal * separator = [[AW_PersonalInformationModal alloc]init];
                    separator.rowHeight = kMarginBetweenCompontents;
                    separator.cellType = @"separatorCell";
                    [weakSelf.dataArr addObject:separator];
                }
                [self dataDidLoad];
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

#pragma mark - TbaleViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_PersonalInformationModal * modal = self.dataArr[indexPath.row];
    if ([modal.cellType isEqualToString:@"topCell"]) {
        return [self configTopCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if ([modal.cellType isEqualToString:@"middleCell"]){
        return [self configMiddleCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if ([modal.cellType isEqualToString:@"bottomCell"]){
        return [self configBottomCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else{
        return [self configSeparateCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
}

#pragma mark - UitableViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_PersonalInformationModal * modal = self.dataArr[indexPath.row];
    return modal.rowHeight;
}

#pragma mark - ConfigTableViewcell Menthod
-(AW_OtherTopInfoCell*)configTopCellWithModal:(AW_PersonalInformationModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_OtherTopInfoCell *cell;
    static NSString * cellId = @"top";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_OtherTopInfoCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.head_img sd_setImageWithURL:[NSURL URLWithString:modal.head_img] placeholderImage:PLACE_HOLDERIMAGE];
    if (![modal.nickname isKindOfClass:[NSNull class]]) {
        cell.nickname.text = [NSString stringWithFormat:@"%@",modal.nickname];
    }
    return cell;
}

-(AW_OtherMiddleInfoCell*)configMiddleCellWithModal:(AW_PersonalInformationModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_OtherMiddleInfoCell *cell;
    static NSString * cellId = @"middle";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_OtherMiddleInfoCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (![modal.birthday isKindOfClass:[NSNull class]]) {
        cell.birthday.text = [NSString stringWithFormat:@"%@",modal.birthday];
    }
    if (![modal.hometown_city_name isKindOfClass:[NSNull class]]) {
        NSString * str = [modal.hometown_province_name stringByAppendingString:modal.hometown_city_name];
        cell.homeTown.text = [NSString stringWithFormat:@"%@",str];
    }
    if (![modal.city_name isKindOfClass:[NSNull class]]) {
        NSString * str = [modal.province_name stringByAppendingString:modal.city_name];
        cell.liveAdress.text = [NSString stringWithFormat:@"%@",str];
    }
    if (![modal.personal_label isKindOfClass:[NSNull class]]) {
        cell.person_label.text = [NSString stringWithFormat:@"%@",modal.personal_label];
    }
    if (![modal.hobbyString isKindOfClass:[NSNull class]]) {
        cell.preference.text = [NSString stringWithFormat:@"%@",modal.hobbyString];
    }
    return cell;
}

-(AW_OtherBottomInfoCell*)configBottomCellWithModal:(AW_PersonalInformationModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_OtherBottomInfoCell * cell;
    static NSString * cellId = @"bottom";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_OtherBottomInfoCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (![modal.signature isKindOfClass:[NSNull class]]) {
        cell.person_singure.text = [NSString stringWithFormat:@"%@",modal.signature];
    }
    if (![modal.synopsis isKindOfClass:[NSNull class]]) {
        cell.persondescribe.text = [NSString stringWithFormat:@"%@",modal.synopsis];
    }
    return cell;
}

-(UITableViewCell *)configSeparateCellWithModal:(AW_PersonalInformationModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"separate";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}




@end
