//
//  AW_MineMainDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MineMainDataSource.h"
#import "AW_MinetopCell.h"
#import "AW_MineOrderCell.h"
#import "AW_MineShopCell.h"
#import "AW_MineOtherCell.h"
#import "AW_MineQuestionCell.h"
#import "AW_UserModal.h"//我的主界面modal
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "AW_ApplyedCell.h"

@interface AW_MineMainDataSource()
/**
 *  @author cao, 15-11-04 10:11:51
 *
 *  是否是vip
 */
@property(nonatomic,copy)NSString * authentication_state;

@end

@implementation AW_MineMainDataSource

#pragma mark - GetData Menthod

-(void)getData{
    __weak typeof(self) weakSelf = self;
    //在这进行请求(插入数据)
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{@"userId":user_id};
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * idString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * mineDict = @{@"param":@"ownInfo",@"jsonParam":idString};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:mineDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
            NSDictionary * infoDict = responseObject[@"info"];
            NSString * authentication_state = infoDict[@"authentication_state"];
            NSString * shop_state = infoDict[@"shop_state"];
            self.shop_state = shop_state;
            NSLog(@"%@",self.shop_state);
            //将申请认证状态记录下来
            self.authentication_state = authentication_state;
            NSArray * textArray = @[@"infoCell",@"",@"orderCell",@"shopCellSeparator",@"shopCell",@"",@"collectCell",@"applyCellSeparator",@"applyCell",@"",@"quesTionCell",@""];
            [textArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString * string = obj;
                if ([string isEqualToString:@"infoCell"]) {
                    AW_UserModal * modal = [[AW_UserModal alloc]init];
                    modal.head_img = infoDict[@"head_img"];
                    modal.nickname = infoDict[@"nickname"];
                    modal.signature = infoDict[@"signature"];
                    modal.works_num = infoDict[@"works_num"];
                    modal.dynamic_num = infoDict[@"dynamic_num"];
                    modal.concern_num = infoDict[@"concern_num"];
                    modal.fan_num = infoDict[@"fan_num"];
                    modal.rowHeight = 130;
                    modal.cellType = @"infoCell";
                    modal.shop_state = infoDict[@"shop_state"];
                    modal.authentication_state = infoDict[@"authentication_state"];
                    [weakSelf.dataArr addObject:modal];
                }else if ([string isEqualToString:@"orderCell"]){
                    AW_UserModal * modal = [[AW_UserModal alloc]init];
                    modal.waitPayUnreadNum = infoDict[@"waitPayUnreadNum"];
                    modal.waitReceiveUnreadNum = infoDict[@"waitReceiveUnreadNum"];
                    modal.waitCommentUnreadNum = infoDict[@"waitCommentUnreadNum"];
                    modal.waitSendOutUnreadNum = infoDict[@"waitSendOutUnreadNum"];
                    modal.rowHeight = 55;
                    modal.cellType = @"orderCell";
                    [weakSelf.dataArr addObject:modal];
                }else if ([string isEqualToString:@"shopCell"]){
                    AW_UserModal * modal = [[AW_UserModal alloc]init];
                    modal.rowHeight = 45;
                    modal.cellType = @"shopCell";
                    if ([shop_state intValue] == 3) {
                        [weakSelf.dataArr addObject:modal];
                    }
                }else if ([string isEqualToString:@"collectCell"]){
                    AW_UserModal * modal =[[AW_UserModal alloc]init];
                    modal.rowHeight = 135;
                    modal.cellType = @"collectionCell";
                    [weakSelf.dataArr addObject:modal];
                }else if([string isEqualToString:@"applyCell"]&& !( [shop_state intValue] == 3)){
                    
                    AW_UserModal * modal = [[AW_UserModal alloc]init];
                    modal.cellType = @"applyCell";
                    modal.shop_state = shop_state;
                    modal.authentication_state = authentication_state;
                    modal.rowHeight = 45;
                    [weakSelf.dataArr addObject:modal];
                }else if ([string isEqualToString:@"quesTionCell"]){
                    AW_UserModal * modal = [[AW_UserModal alloc]init];
                    modal.rowHeight = 135;
                    modal.cellType = @"qurstionCell";
                    [weakSelf.dataArr addObject:modal];
                }else if([string isEqualToString:@"shopCellSeparator"]){
                    AW_UserModal * modal = [[AW_UserModal alloc]init];
                    modal.rowHeight = kMarginBetweenCompontents;
                    modal.cellType = @"separatorCell";
                    if ([shop_state intValue] == 3) {
                        [weakSelf.dataArr addObject:modal];
                    }
                }else if ([string isEqualToString:@"applyCellSeparator"]){
                    AW_UserModal * modal = [[AW_UserModal alloc]init];
                    modal.rowHeight = kMarginBetweenCompontents;
                    modal.cellType = @"separatorCell";
                    if (!([shop_state intValue] == 3)) {
                        [weakSelf.dataArr addObject:modal];
                    }
                }else if([string isEqualToString:@""]){
                    AW_UserModal * modal = [[AW_UserModal alloc]init];
                    modal.cellType = @"separatorCell";
                    modal.rowHeight = kMarginBetweenCompontents;
                    [weakSelf.dataArr addObject:modal];
                }
            }];
            [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
 
}

-(void)refreshData{
    
        if (self.dataArr.count > 0) {
            [self.dataArr removeAllObjects];
        }

    [self performSelector:@selector(getData) withObject:nil afterDelay:1];
}

#pragma mark - UITableViewDataSource Menthod

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_UserModal * modal;
    if (self.dataArr.count > 0) {
      modal = self.dataArr[indexPath.row];
    }
        if ([modal.cellType isEqualToString:@"infoCell"]){
            return [self configMineCellWithModal:modal tableView:tableView indexPath:indexPath];
        }else if([modal.cellType isEqualToString:@"orderCell"]){
            return [self configOrderMessageCellWithModal:modal tableView:tableView indexPath:indexPath];
        }else if([modal.cellType isEqualToString:@"shopCell"]){
            return [self configShopCellWithModal:modal tableView:tableView indexPath:indexPath];
        }else if([modal.cellType isEqualToString:@"collectionCell"]){
            return [self configOtherCellWithModal:modal tableView:tableView indexPath:indexPath];
        }else if([modal.cellType isEqualToString:@"applyCell"]){
            return [self configApplyCellWithModal:modal tableView:tableView indexPath:indexPath];
        }else if([modal.cellType isEqualToString:@"qurstionCell"]){
            return [self configQuestionCellWithModal:modal tableView:tableView indexPath:indexPath];
        }else{
            return [self configSeparatorCellWithModal:modal tableView:tableView indexPath:indexPath];
        }
}

#pragma mark - UITableViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_UserModal * modal;
    if (self.dataArr.count > 0) {
        modal = self.dataArr[indexPath.row];
    }
    
    return modal.rowHeight;
}

#pragma mark - ConfigTableViewCell Menthod

-(AW_MinetopCell*)configMineCellWithModal:(AW_UserModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"mineCell";
    AW_MinetopCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        if ([modal.shop_state intValue] == 3) {
          cell = BundleToObj(@"AW_MinetopCell");
        }else{
          cell = [[NSBundle mainBundle]loadNibNamed:@"AW_MinetopCell" owner:self options:nil][1];
        }
    }
    [cell configSeparatorWith:modal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:modal.head_img]placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    [cell.mineName setTitle:[NSString stringWithFormat:@"%@",modal.nickname] forState:UIControlStateNormal];
    if (![modal.signature isKindOfClass:[NSNull class]]) {
        cell.mineDescribe.text = [NSString stringWithFormat:@"%@",modal.signature];
    }
    cell.mineProduceNum.text = [NSString stringWithFormat:@"%@",modal.works_num];
    cell.mineDynamicNum.text = [NSString stringWithFormat:@"%@",modal.dynamic_num];
    cell.myAttentionNum.text = [NSString stringWithFormat:@"%@",modal.concern_num];
    cell.mineFansName.text = [NSString stringWithFormat:@"%@",modal.fan_num];
    if ([self.authentication_state intValue] == 3) {
        cell.vipimage.hidden = NO;
    }else{
        cell.vipimage.hidden = YES;
    }
    //点击按钮的回调
    cell.didClickKindBtn = ^(NSInteger index){
        if (_didClickHeadViewBtn) {
            _didClickHeadViewBtn(index);
        }
    };
    //点击按钮的回调，没有作品时
    cell.didClicjedBtns = ^(NSInteger index){
        if (_didClickedBtnsWithoutProduce) {
            _didClickedBtnsWithoutProduce(index);
        }
    };
    return cell;
}

-(AW_MineOrderCell*)configOrderMessageCellWithModal:(AW_UserModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"orderMessageCell";
    AW_MineOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_MineOrderCell");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.waitPayLabel.text = [NSString stringWithFormat:@"%@",modal.waitPayUnreadNum];
    cell.waitDeliveryLabel.text = [NSString stringWithFormat:@"%@",modal.waitSendOutUnreadNum];
    cell.waitReceiveLabel.text = [NSString stringWithFormat:@"%@",modal.waitReceiveUnreadNum];
    cell.waitEvaluteLabel.text = [NSString stringWithFormat:@"%@",modal.waitCommentUnreadNum];
    cell.didClickKindBtn = ^(NSInteger index){
        if (_didClickOrderViewBtn) {
            _didClickOrderViewBtn(index);
        };
    
    };
    if ([modal.waitPayUnreadNum boolValue] == 0) {
        cell.waitPayView.hidden =YES;
    }else{
        cell.waitPayView.hidden =NO;
    }
    if ([modal.waitSendOutUnreadNum boolValue]== 0) {
        cell.waitDeliveryView.hidden =YES;
    }else{
        cell.waitDeliveryView.hidden =NO;
    }
    if ([modal.waitReceiveUnreadNum boolValue]== 0) {
        cell.waitReceiveView.hidden =YES;
    }else{
        cell.waitReceiveView.hidden =NO;
    }
    if ([modal.waitCommentUnreadNum boolValue]== 0) {
        cell.waitEvaluteView.hidden =YES;
    }else{
        cell.waitEvaluteView.hidden =NO;
    }
    return cell;
}
-(AW_MineShopCell*)configShopCellWithModal:(AW_UserModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"shopCell";
    AW_MineShopCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_MineShopCell");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.didClickStoreBtn = ^(NSInteger index){
        if (_didClickStoreBtn) {
            _didClickStoreBtn(index);
        }
    };
    return cell;
}

-(AW_ApplyedCell*)configApplyCellWithModal:(AW_UserModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
   static NSString * cellId = @"applyCell";
    AW_ApplyedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
       if (!([modal.authentication_state intValue] == 3)){
            cell = [[NSBundle mainBundle]loadNibNamed:@"AW_ApplyedCell" owner:self options:nil][1];
        }else if ([modal.authentication_state intValue] == 3 && !([modal.shop_state intValue] == 3)){
            cell = [[NSBundle mainBundle]loadNibNamed:@"AW_ApplyedCell" owner:self options:nil][2];
        }
    }
    if ([modal.shop_state intValue] == 0) {
        cell.openShopLabel.text = [NSString stringWithFormat:@"申请开店"];
    }else if([modal.shop_state intValue] == 1){
        cell.openShopLabel.text = [NSString stringWithFormat:@"申请中,请耐心等待..."];
    }else if ([modal.shop_state intValue] == 2){
        cell.openShopLabel.text = [NSString stringWithFormat:@"申请失败,请重新申请"];
    }
    
    if ([modal.authentication_state intValue] == 0) {
        cell.certificationLabel.text = [NSString stringWithFormat:@"申请认证"];
    }else if ([modal.authentication_state intValue] == 1){
       cell.certificationLabel.text = [NSString stringWithFormat:@"认证中,请耐心等待..."];
    }else if ([modal.authentication_state intValue] == 2){
        cell.certificationLabel.text = [NSString stringWithFormat:@"认证失败,请重新认证"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //点击申请认证或申请开店按钮的回调
    cell.didClickedcertificationBtn = ^(){
        if (_didClickedCertificationBtn) {
            _didClickedCertificationBtn();
        }
    };
    cell.didClickedOpenShopBtn = ^(){
        if (_didClickedOpenShopBtn) {
            _didClickedOpenShopBtn();
        }
    };
    return cell;
}

-(AW_MineOtherCell*)configOtherCellWithModal:(AW_UserModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
   static NSString * cellId = @"otherCell";
    AW_MineOtherCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
    cell = BundleToObj(@"AW_MineOtherCell");
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.didClickKindBtn = ^(NSInteger index){
        if (_didClickOtherCellBtn) {
            _didClickOtherCellBtn(index);
        }
    };
    return cell;
}

-(AW_MineQuestionCell*)configQuestionCellWithModal:(AW_UserModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
   static NSString * cellId = @"questinoCell";
    AW_MineQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_MineQuestionCell");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.didClickKindBtn = ^(NSInteger index){
        if (_didClickBottomCellBtn) {
            _didClickBottomCellBtn(index);
        }
    };
    return cell;
}

-(UITableViewCell*)configSeparatorCellWithModal:(Node *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"separateCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

@end
