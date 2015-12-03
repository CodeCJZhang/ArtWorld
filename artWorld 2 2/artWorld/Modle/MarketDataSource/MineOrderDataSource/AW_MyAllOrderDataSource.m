//
//  AW_MyAllOrderDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//
#import "AW_MyAllOrderDataSource.h"
#import "AW_MyOrderModal.h"//我的订单模型
#import "UIImageView+WebCache.h"
#import "AW_OrderArticleCell.h"
#import "AW_OrderStateCell.h"
#import "AW_OrderStoreCell.h"
#import "AW_StoreModal.h"//店铺modal
#import "AW_CommodityModal.h"//商品modal
#import "AFNetworking.h"

@interface AW_MyAllOrderDataSource()

@end
@implementation AW_MyAllOrderDataSource

#pragma mark - GetData  Menthod

-(void)getTextData{
    __weak typeof(self) weakSelf = self;
//在这进行请求
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{
                            @"userId":user_id,
                            @"pageSize":@"10",
                            @"pageNumber":self.currentPage,
                            @"type":@"0",
                          };
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * orderDict = @{@"jsonParam":str,@"token":@"android",@"param":@"getOrderList"};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:orderDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
            //将页码总数记录下来
            weakSelf.totolPage = [responseObject[@"info"] valueForKey:@"totalNumber"];
            NSLog(@"%@",weakSelf.totolPage);
            NSArray * dataArrray = [responseObject[@"info"]valueForKey:@"data"];
            [dataArrray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * storeDict = obj;
                
                //插入分割线
                AW_MyOrderModal * separate = [[AW_MyOrderModal alloc]init];
                separate.rowHeight = kMarginBetweenCompontents;
                separate.level = idx;
                [weakSelf.dataArr addObject:separate];
                
                //插入店铺modal
                AW_StoreModal * sonStoreModal = [[AW_StoreModal alloc]init];
                AW_MyOrderModal * storeModal = [[AW_MyOrderModal alloc]init];
                storeModal.orderId = storeDict[@"id"];
                NSLog(@"%@",storeModal.orderId);
                sonStoreModal.shop_Id = storeDict[@"shop_id"];
                sonStoreModal.shoper_id = storeDict[@"user_id"];
                sonStoreModal.shop_Name = storeDict[@"shop_name"];
                sonStoreModal.shoper_IM_Id = storeDict[@"shop_phone"];
                sonStoreModal.totalPrice = storeDict[@"price"];
                sonStoreModal.freight = storeDict[@"freight"];
                sonStoreModal.state = storeDict[@"state"];
                storeModal.rowHeight = 35;
                storeModal.storeModal = sonStoreModal;
                [weakSelf.dataArr addObject:storeModal];
                
                NSArray * artArray = storeDict[@"arts"];
                NSMutableArray * tmpArray = [[NSMutableArray alloc]init];
               [artArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   NSDictionary * artDict = obj;
                   //插入艺术品modal
                   AW_CommodityModal * sonArticleModal = [[AW_CommodityModal alloc]init];
                   AW_MyOrderModal * articleModal = [[AW_MyOrderModal alloc]init];
                   sonArticleModal.ID = artDict[@"id"];
                   sonArticleModal.commodity_Id = artDict[@"commodity_id"];
                   sonArticleModal.commodity_Name = artDict[@"commodity_name"];
                   sonArticleModal.commodityTyde = artDict[@"commodity_attr"];
                   sonArticleModal.commodityPrice = artDict[@"price"];
                   sonArticleModal.commodityNumber = artDict[@"number"];
                   sonArticleModal.clearImageURL = artDict[@"clear_img"];
                   sonArticleModal.fuzzyImageURL = artDict[@"fuzzy_img"];
                   articleModal.rowHeight = 96;
                   articleModal.CommodityModal = sonArticleModal;
                   [tmpArray addObject:articleModal];
                   [weakSelf.dataArr addObject:articleModal];
               }];
                //插入底部的编辑订单modal
                AW_MyOrderModal * editeOrserModal = [[AW_MyOrderModal alloc]init];
                editeOrserModal.totalPrice = storeDict[@"price"];
                editeOrserModal.deliveryPrice = storeDict[@"freight"];
                editeOrserModal.totalNumber = [NSString stringWithFormat:@"%ld",artArray.count];
                editeOrserModal.orderState = storeDict[@"state"];
                editeOrserModal.orderId = storeDict[@"id"];
                editeOrserModal.rowHeight = 70;
                editeOrserModal.separateModal = separate;
                editeOrserModal.OrderStoreModal = storeModal;
                editeOrserModal.subArray = [tmpArray copy];
                [weakSelf.dataArr addObject:editeOrserModal];
            }];
            NSLog(@"当前页数%@",self.currentPage);
            NSLog(@"总页数：%@",self.totolPage);
            //判断是否显示下拉刷新
            if (([weakSelf.currentPage intValue]*10 < [weakSelf.totolPage intValue]) && [weakSelf.totolPage intValue] > 10) {
                self.tableView.footerHidden = NO;
            }else{
                self.tableView.footerHidden = YES;
            }
            [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息新：%@",[error localizedDescription]);
    }];
}
   
/**
 *  @author cao, 15-09-17 19:09:58
 *
 *  刷新数据
 */
-(void)refreshData{
    if (self.dataArr.count > 0) {
        [self.dataArr removeAllObjects];
    }
   self.currentPage = @"1";
   [self getTextData];
  
}
//加载下一页数据
-(void)nextPageData{
    
    NSLog(@"当前的页数:%@",self.currentPage);
    if ([self.totolPage intValue] > 10 && ([self.currentPage intValue]*10 < [self.totolPage intValue])){
        //只有页数大于1时才进行上提分页(将当前页码加上1)
        self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] + 1];
        [self performSelector:@selector(getTextData) withObject:nil afterDelay:1];
    }
}

#pragma mark - UITableViewDelegate  Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyOrderModal * orderModal;
    if (self.dataArr.count > 0) {
        orderModal  = self.dataArr[indexPath.row];
    }
    if (orderModal.rowHeight == kMarginBetweenCompontents) {
        return [self configSeparatorCellWithModal:orderModal tableView:tableView indexPath:indexPath];
    }else if (orderModal.rowHeight == 35){
        if ([orderModal.storeModal.state intValue] == 1) {
            return [self configOrderStoreCellWithModal:orderModal tableView:tableView indexPath:indexPath orderState:@"待付款"];
        }else if ([orderModal.storeModal.state intValue] == 2){
            return [self configOrderStoreCellWithModal:orderModal tableView:tableView indexPath:indexPath orderState:@"买家已付款"];
        }else if ([orderModal.storeModal.state intValue] == 3){
            return [self configOrderStoreCellWithModal:orderModal tableView:tableView indexPath:indexPath orderState:@"卖家已发货"];
        }else if ([orderModal.storeModal.state intValue] == 4){
            return [self configOrderStoreCellWithModal:orderModal tableView:tableView indexPath:indexPath orderState:@"交易成功"];
        }else if ([orderModal.storeModal.state intValue] == 5){
            return [self configOrderStoreCellWithModal:orderModal tableView:tableView indexPath:indexPath orderState:@"交易成功"];
        }else if ([orderModal.storeModal.state intValue] == 6){
           return [self configOrderStoreCellWithModal:orderModal tableView:tableView indexPath:indexPath orderState:@"交易关闭"];
        }else{
            return nil;
        }
    }else if (orderModal.rowHeight == 70){
        if ([orderModal.orderState intValue] == 1) {
            return [self configOrderStateCellWithModal:orderModal tableView:tableView indexPath:indexPath index:0];
        }else if ([orderModal.orderState intValue] == 2){
            return [self configOrderStateCellWithModal:orderModal tableView:tableView indexPath:indexPath index:1];
            
        }else if ([orderModal.orderState intValue] == 3){
            return [self configOrderStateCellWithModal:orderModal tableView:tableView indexPath:indexPath index:2];
        }else if ([orderModal.orderState intValue] == 4){
            return [self configOrderStateCellWithModal:orderModal tableView:tableView indexPath:indexPath index:3];
        }else if ([orderModal.orderState intValue] == 5){
            return [self configOrderStateCellWithModal:orderModal tableView:tableView indexPath:indexPath index:4];
        }else if ([orderModal.orderState intValue] == 6){
            return [self configOrderStateCellWithModal:orderModal tableView:tableView indexPath:indexPath index:5];
        }else{
            return nil;
        }
    }else{
        return [self configOrderArticleCellWithModal:orderModal tableView:tableView indexPath:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyOrderModal * modal;
    if (self.dataArr.count > 0) {
         modal = self.dataArr[indexPath.row];
    }
    return modal.rowHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[AW_OrderArticleCell class]]) {
        AW_MyOrderModal * modal = self.dataArr[indexPath.row];
        _modal = modal.CommodityModal;
        NSLog(@"%d",modal.CommodityModal.isCollected);
        if (_didClickedCell) {
            _didClickedCell(_modal);
        }
    }
}

#pragma mark - ConfigTableViewCell Menthod
-(AW_OrderStoreCell*)configOrderStoreCellWithModal:(AW_MyOrderModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath orderState:(NSString*)orderState{
    AW_OrderStoreCell * cell;
    static NSString * cellId = @"OrderStoreCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_OrderStoreCell");
    }
    cell.orderStateLabel.text = [NSString stringWithFormat:@"%@",orderState];
    cell.articleStoreName.text = [NSString stringWithFormat:@"%@",modal.storeModal.shop_Name];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(AW_OrderArticleCell*)configOrderArticleCellWithModal:(AW_MyOrderModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_OrderArticleCell *cell;
    static NSString * cellId = @"OrderStateCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_OrderArticleCell");
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //判断网络状态和是否开启了省流量模式
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"patternState"]isEqualToString:@"yes"]&&[[user objectForKey:@"NetState"]isEqualToString:@"切换到WWAN网络"]) {
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.CommodityModal.fuzzyImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    }else{
       [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.CommodityModal.clearImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    }
    
    cell.articleName.text = [NSString stringWithFormat:@"%@",modal.CommodityModal.commodity_Name];
    if (![modal.CommodityModal.commodityTyde isKindOfClass:[NSNull class]]) {
        cell.articleDescribe.text = [NSString stringWithFormat:@"%@",modal.CommodityModal.commodityTyde];
    }
    cell.articlePrice.text = [NSString stringWithFormat:@"￥%.2f",modal.CommodityModal.commodityPrice.floatValue];
    cell.articleNum.text = [NSString stringWithFormat:@"x%@",modal.CommodityModal.commodityNumber];
    return cell;
}

-(AW_OrderStateCell*)configOrderStateCellWithModal:(AW_MyOrderModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
    AW_OrderStateCell * cell;
    static NSString * cellId = @"OrderStateCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AW_OrderStateCell" owner:self options:nil][index];
    }
    //点击待付款cell上的按钮的回调
    __weak typeof(cell) weakCell = cell;
    cell.didClickedWaitPayCellBtns = ^(NSInteger index){
        AW_MyOrderModal * tmpModal;
        if (index == 1) {
            UIView * v = [weakCell.connectBtn superview];
            UIView * v1 = [v superview];
            AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
            NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
            tmpModal = self.dataArr[path.row];
            
        }else if (index == 2){
            UIView * v = [weakCell.cancleBtn superview];
            UIView * v1 = [v superview];
            AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
            NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
            tmpModal = self.dataArr[path.row];
            
        }else if (index == 3){
            UIView * v = [weakCell.paymentBtn superview];
            UIView * v1 = [v superview];
            AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
            NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
            tmpModal = self.dataArr[path.row];
        }
        _orderModal = tmpModal;
        if (_didClickedPayMentButtons) {
            _didClickedPayMentButtons(_orderModal,index);
        }
    };
    //点击提醒发货按钮的回调
    __weak typeof(cell) weakTmpCell = cell;
    cell.didClickRemindBtn = ^(){
        UIView * v = [weakTmpCell.remindSnedBtn superview];
        UIView * v1 = [v superview];
        AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
        NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
        AW_MyOrderModal * tmpModal = self.dataArr[path.row];
        _orderModal = tmpModal;
            if (_didClickedRemindBtn) {
                _didClickedRemindBtn(_orderModal);
            }
    };
    //点击待收货cell上的按钮的回调
    cell.didClickedWaitReceiveCellBtns = ^(NSInteger index){
        AW_MyOrderModal * tmpModal;
        if (index == 1) {
            UIView * v = [weakCell.lookDeliveryBtn superview];
            UIView * v1 = [v superview];
            AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
            NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
            tmpModal = self.dataArr[path.row];
            
        }else if (index == 2){
            UIView * v = [weakCell.confirmDeliveryBtn superview];
            UIView * v1 = [v superview];
            AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
            NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
            tmpModal = self.dataArr[path.row];
        }
        _orderModal = tmpModal;
        if (_didClickedReceiveButtons) {
            _didClickedReceiveButtons(_orderModal,index);
        }
    };
    //点击待评价cell上的按钮的回调
    cell.didClickedWaitEvaluteCellBtns = ^(NSInteger index){
          AW_MyOrderModal* tmpModal;
            if (index == 1) {
                UIView * v = [weakTmpCell.deleteOrderBtn superview];
                UIView * v1 = [v superview];
                AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
                NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
                tmpModal = self.dataArr[path.row];
                
            }else if (index == 2){
                UIView * v = [weakTmpCell.lookDeliveryBtn superview];
                UIView * v1 = [v superview];
                AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
                NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
                tmpModal = self.dataArr[path.row];
                
            }else if (index == 3){
                UIView * v = [weakTmpCell.evaluteBtn superview];
                UIView * v1 = [v superview];
                AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
                NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
                tmpModal = self.dataArr[path.row];
            }
        _orderModal = tmpModal;
        if (_didClickEvaluteCellButtons) {
            _didClickEvaluteCellButtons(_orderModal,index);
        }
        
    };
    //点击交易成功cell上的按钮的回调
    cell.didClickedOrderSucessCellBtns = ^(NSInteger index){
        AW_MyOrderModal * tmpModal;
        if (index == 1) {
            UIView * v = [weakTmpCell.deleteOrderBtn superview];
            UIView * v1 = [v superview];
            AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
            NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
            tmpModal = self.dataArr[path.row];
            
        }else if (index == 2){
            UIView * v = [weakTmpCell.lookDeliveryBtn superview];
            UIView * v1 = [v superview];
            AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
            NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
            tmpModal = self.dataArr[path.row];
        }
        _orderModal = tmpModal;
        if (_didClickedOrderSucessCellBtn) {
            _didClickedOrderSucessCellBtn(_orderModal,index);
        }
    };
    //点击交易关闭cell上的按钮的回调
    cell.didClickedOrderCloseBtn = ^(){
        UIView * v = [weakTmpCell.deleteOrderBtn superview];
        UIView * v1 = [v superview];
        AW_OrderStateCell * orderStateCell = (AW_OrderStateCell*)[v1 superview];
        NSIndexPath *path = [tableView indexPathForCell:orderStateCell];
        AW_MyOrderModal * tmpModal = self.dataArr[path.row];
        _orderModal = tmpModal;
        if (_didClickedOrderCloseCellBtn){
            _didClickedOrderCloseCellBtn(_orderModal);
        }
    };
    cell.articleNumber.text = [NSString stringWithFormat:@"共有%@件商品",modal.totalNumber];
    cell.totalPriceAndDeliveryPrice.text = [NSString stringWithFormat:@"￥%.2f",modal.totalPrice.floatValue];
    cell.deliveryPrice.text = [NSString stringWithFormat:@"(含运费￥%.2f)",modal.deliveryPrice.floatValue];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(UITableViewCell*)configSeparatorCellWithModal:(AW_MyOrderModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString  *cellId = @"separator";
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
