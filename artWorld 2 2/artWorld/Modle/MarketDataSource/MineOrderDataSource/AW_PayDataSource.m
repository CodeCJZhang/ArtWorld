//
//  AW_PayDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/5.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_PayDataSource.h"
#import "AW_MyShopCartModal.h"
#import "AW_ConfirmOrderAdressCell.h"//收货地址
#import "AW_ConfirmOrderArticleCell.h"//艺术品cell
#import "AW_ConfirmOrderOtherCell.h"//留言cell
#import "AW_ConfirmOrderStoreCell.h"//商铺cell
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "AW_Constants.h"

@implementation AW_PayDataSource

-(AW_DeliveryAdressModal*)adressModal{
    if (!_adressModal) {
        _adressModal = [[AW_DeliveryAdressModal alloc]init];
    }
    return _adressModal;
}

-(NSMutableArray*)storeModalArray{
    if (!_storeModalArray) {
        _storeModalArray = [[NSMutableArray alloc]init];
    }
    return _storeModalArray;
}

-(NSMutableArray*)commidityArray{
    if (!_commidityArray) {
        _commidityArray = [[NSMutableArray alloc]init];
    }
    return _commidityArray;
}


#pragma mark - GetData Menthod

-(void)getData{
    __weak typeof(self) weakSelf = self;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{@"userId":user_id,@"orderId":self.order_id};
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * payDict = @{@"param":@"confirmOrder",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:payDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
            NSDictionary * infoDict = responseObject[@"info"];
            NSDictionary * adressDict = infoDict[@"address"];
            //将总价格记录下来
            self.totalPrice = infoDict[@"total"];
            NSLog(@"%@",self.totalPrice);
            //插入收货地址
            AW_MyShopCartModal * modal = [[AW_MyShopCartModal alloc]init];
            AW_DeliveryAdressModal * adressModal = [[AW_DeliveryAdressModal alloc]init];
            modal.rowHeight = 70;
            modal.adressModal = adressModal;
            adressModal.adress_Id = adressDict[@"id"];
            adressModal.deliveryName = adressDict[@"name"];
            adressModal.deliveryPhoneNumber = adressDict[@"phone"];
            adressModal.deliveryAdress = adressDict[@"address"];
            [weakSelf.dataArr addObject:modal];
            //将收货地址记录下来
            weakSelf.adressModal.adress_Id = adressDict[@"id"];
            weakSelf.adressModal.deliveryName = adressDict[@"name"];
            weakSelf.adressModal.deliveryPhoneNumber = adressDict[@"phone"];
            weakSelf.adressModal.deliveryAdress = adressDict[@"address"];
           //插入分割线
            AW_MyShopCartModal * separate = [[AW_MyShopCartModal alloc]init];
            separate.isSeparate = YES;
            separate.rowHeight = kMarginBetweenCompontents;
            [weakSelf.dataArr addObject:separate];
            //商铺modal
             NSDictionary * shopDict = infoDict[@"shop"];
            AW_StoreModal * storeModal = [[AW_StoreModal alloc]init];
            AW_MyShopCartModal * store = [[AW_MyShopCartModal alloc]init];
            store.storeModal = storeModal;
            storeModal.shop_Id = shopDict[@"id"];
            storeModal.shop_Name = shopDict[@"name"];
            storeModal.shoper_IM_Id = shopDict[@"phone"];
            storeModal.freight = shopDict[@"freight"];
            store.rowHeight = 42;
            //将运费记录下来
            float fre = [shopDict[@"freight"]floatValue];
            self.tmpFreight = fre + self.tmpFreight;
            //将商铺modal记录下来
            store.storeModal.shoper_id = user_id;
            [weakSelf.storeModalArray addObject:store];
            [weakSelf.dataArr addObject:store];
            //插入艺术品modal
            [shopDict[@"arts"]  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * artDict = obj;
                AW_MyShopCartModal * article = [[AW_MyShopCartModal alloc]init];
                AW_CommodityModal * commidityMdal = [[AW_CommodityModal alloc]init];
                article.commodityModal = commidityMdal;
                article.rowHeight = 88;
                commidityMdal.commodity_Id = artDict[@"commodity_id"];
                NSLog(@"%@",commidityMdal.commodity_Id);
                commidityMdal.commodity_Name = artDict[@"commodity_name"];
                commidityMdal.clearImageURL = artDict[@"clear_img"];
                commidityMdal.fuzzyImageURL = artDict[@"fuzzy_img"];
                commidityMdal.commodityPrice = artDict[@"price"];
                commidityMdal.commodityNumber = artDict[@"number"];
                commidityMdal.commodity_color = artDict[@"commodity_attr"];
                commidityMdal.order_id = artDict[@"order_id"];
                [weakSelf.dataArr addObject:article];
                //记录艺术品modal
                [weakSelf.commidityArray addObject:commidityMdal];
            }];
            //记录运费
            self.freight = [NSString stringWithFormat:@"%f",self.tmpFreight];
            //插入留言modal
            AW_MyShopCartModal * otherModal = [[AW_MyShopCartModal alloc]init];
            otherModal.rowHeight = 140;
            otherModal.leaveMessage = infoDict[@"leaveMessage"];
            otherModal.coupsonState =  [infoDict[@"coupsonState"]boolValue];
            otherModal.storeModal = storeModal;
            [weakSelf.dataArr addObject:otherModal];
            
            //插入分割线
            AW_MyShopCartModal * separate1 = [[AW_MyShopCartModal alloc]init];
            separate1.isSeparate = YES;
            separate1.rowHeight = kMarginBetweenCompontents;
            [weakSelf.dataArr addObject:separate1];
        }
        [self dataDidLoad];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];

}

#pragma mark - UITableViewDataSource Menthod

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyShopCartModal * modal = self.dataArr[indexPath.row];
    if (modal.rowHeight == kMarginBetweenCompontents) {
        return [self configSeparateCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if (modal.rowHeight == 140){
        return [self configOtherCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if (modal.rowHeight == 88){
        return [self configArticleCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if (modal.rowHeight == 70){
        return [self configAdressCellWithModal:modal.adressModal tableView:tableView indexPath:indexPath];
    }else if (modal.rowHeight == 42){
        return [self configStoreCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDelegate Menthod

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyShopCartModal * modal = self.dataArr[indexPath.row];
    return modal.rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AW_MyShopCartModal * modal = self.dataArr[indexPath.row];
    if ([[tableView cellForRowAtIndexPath:indexPath]isKindOfClass:[AW_ConfirmOrderArticleCell class]]) {
        _commidity_id = modal.commodityModal.commodity_Id;
        NSLog(@"%@",_commidity_id);
        if (_didClickedCell) {
            _didClickedCell(_commidity_id);
        }
    }
}

#pragma mark - ConfigTableViewCell Menthod
//添加收货地址之后加载cell
-(AW_ConfirmOrderAdressCell*)configAdressCellWithModal:(AW_DeliveryAdressModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"adressCell";
    AW_ConfirmOrderAdressCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ConfirmOrderAdressCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.orderName.text = [NSString stringWithFormat:@"%@",modal.deliveryName];
    cell.orderPhone.text = [NSString stringWithFormat:@"%@",modal.deliveryPhoneNumber];
    cell.orderAdress.text = [NSString stringWithFormat:@"%@",modal.deliveryAdress];
    return cell;
}

-(AW_ConfirmOrderStoreCell*)configStoreCellWithModal:(AW_MyShopCartModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"storeCell";
    AW_ConfirmOrderStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ConfirmOrderStoreCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.storeName.text = [NSString stringWithFormat:@"%@",modal.storeModal.shop_Name];
    return cell;
}

-(AW_ConfirmOrderArticleCell*)configArticleCellWithModal:(AW_MyShopCartModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"articleCell";
    AW_ConfirmOrderArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ConfirmOrderArticleCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //判断网络状态和是否开启了省流量模式
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"patternState"]isEqualToString:@"yes"]&&[[user objectForKey:@"NetState"]isEqualToString:@"切换到WWAN网络"]) {
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commodityModal.fuzzyImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    }else{
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commodityModal.clearImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    }
    cell.articleDes.text  = [NSString stringWithFormat:@"%@",modal.commodityModal.commodity_Name];
    if (![modal.commodityModal.commodity_color isKindOfClass:[NSNull class]]) {
        cell.articleInfo.text = [NSString stringWithFormat:@"%@",modal.commodityModal.commodity_color];
    }
    cell.articleCurrentPrice.text = [NSString stringWithFormat:@"￥%.2f",modal.commodityModal.commodityPrice.floatValue];
    cell.articleNum.text = [NSString stringWithFormat:@"x %@",modal.commodityModal.commodityNumber];
    return cell;
}

-(AW_ConfirmOrderOtherCell*)configOtherCellWithModal:(AW_MyShopCartModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"messageCell";
    AW_ConfirmOrderOtherCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ConfirmOrderOtherCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (modal.coupsonState == YES) {
        cell.stateLabel.text = [NSString stringWithFormat:@"已使用"];
    }else{
        cell.stateLabel.text = [NSString stringWithFormat:@"未使用"];
    }
    cell.deliveryPrice.text = [NSString stringWithFormat:@"￥%.2f",modal.storeModal.freight.floatValue];
    cell.leaveMessage.text = [NSString stringWithFormat:@"%@",modal.leaveMessage];
    cell.leaveMessage.editable = NO;
    return cell;
}

-(UITableViewCell*)configSeparateCellWithModal:(AW_MyShopCartModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
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
