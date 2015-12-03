//
//  AW_ConfirmOrderDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ConfirmOrderDataSource.h"
#import "AW_MyShopCartModal.h"
#import "AW_ConfirmOrderAdressCell.h"//收货地址
#import "AW_ConfirmOrderArticleCell.h"//艺术品cell
#import "AW_ConfirmOrderOtherCell.h"//留言cell
#import "AW_ConfirmOrderStoreCell.h"//商铺cell
#import "AW_AnonymityCell.h"//匿名购买cell
#import "UIImageView+WebCache.h"
#import "AW_AddDeliveyAdressCell.h"//添加收货地址cell
#import "DeliveryAlertView.h"
#import "AW_FavobleView.h" //弹出的输入验证码视图
#import "AW_Constants.h"
#import "AFNetworking.h"

@interface AW_ConfirmOrderDataSource()
/**
 *  @author cao, 15-09-12 16:09:06
 *
 *  用于记录匿名按钮的状态
 */
@property(nonatomic)NSString * isAnonymity;
/**
 *  @author cao, 15-11-24 22:11:40
 *
 *  记录邮费
 */
@property(nonatomic)float tmpfreight;

@end

@implementation AW_ConfirmOrderDataSource

#pragma mark - Private Menthod
-(NSMutableDictionary*)couponsDict{
    if (!_couponsDict) {
        _couponsDict = [NSMutableDictionary dictionary];
    }
    return _couponsDict;
}

-(NSMutableDictionary*)messageDict{
    if (!_messageDict) {
        _messageDict = [NSMutableDictionary dictionary];
    }
    return _messageDict;
}

-(NSMutableArray *)PurchaseArticleModal{
    if (!_PurchaseArticleModal) {
        _PurchaseArticleModal = [[NSMutableArray alloc]init];
    }
    return _PurchaseArticleModal;
}

-(NSMutableArray *)storeModalArray{
    if (!_storeModalArray) {
        _storeModalArray = [[NSMutableArray alloc]init];
    }
    return _storeModalArray;
}

-(NSMutableArray*)storeArray{
    if (!_storeArray) {
        _storeArray = [[NSMutableArray alloc]init];
    }
    return _storeArray;
}

#pragma mark - GetData  Menthod

-(void)getData{
//==========↓对上个界面传过来的选中的艺术品modal进行处理↓=============
    NSMutableArray * storeArray = [[NSMutableArray alloc]init];
    NSMutableArray * storeModalArray = [[NSMutableArray alloc]init];
    [self.PurchaseArticleModal enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        AW_MyShopCartModal * articleModal = obj;
        NSString * storeName = articleModal.commodityModal.belongStoreName;
        NSLog(@"=====%@===",articleModal.commodityModal.belongSrote_id);
        if (![storeArray containsObject:storeName]) {
            [storeArray addObject:storeName];
            AW_MyShopCartModal * shopModal = [[AW_MyShopCartModal alloc]init];
            AW_StoreModal * tmpModal = [[AW_StoreModal alloc]init];
            tmpModal.shop_Name = storeName;
            tmpModal.shop_Id = articleModal.commodityModal.belongSrote_id;
             NSLog(@"商铺id：%@",tmpModal.shop_Id);
            NSLog(@"%@",tmpModal.shoper_IM_Id);
            shopModal.storeModal = tmpModal;
            [storeModalArray addObject:shopModal];
        }
    }];
    
    [storeModalArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AW_MyShopCartModal * storeModal = obj;
        storeModal.subArray = [[NSMutableArray alloc]init];
        [self.PurchaseArticleModal enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AW_MyShopCartModal * articleModal = obj;
            if ([articleModal.commodityModal.belongStoreName isEqualToString:storeModal.storeModal.shop_Name]) {
                NSLog(@"=====%@===",articleModal.commodityModal.belongSrote_id);
                [storeModal.subArray addObject:articleModal];
            }
        }];
    }];
    self.storeModalArray = [storeModalArray mutableCopy];
//========↓将上个界面传过来选中的艺术品modal赋值给self.dataArr↓======
    
    __weak typeof(self) weakSelf = self;
    //收货地址
    if (self.adressModal) {
        AW_MyShopCartModal * modal = [[AW_MyShopCartModal alloc]init];
        AW_DeliveryAdressModal * adressModal = [[AW_DeliveryAdressModal alloc]init];
        modal.rowHeight = 70;
         adressModal = self.adressModal;
        modal.adressModal = adressModal;
        [weakSelf.dataArr addObject:modal];
    }else{
        
        //=======↓进行默认收货地址请求=========
       __block NSDictionary * infoDict;
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * user_id = [user objectForKey:@"user_id"];
        NSDictionary * dict =  @{@"userId":user_id};
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
        NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary * defaultAdress = @{@"jsonParam":str,@"token":@"",@"param":@"getDefAddress"};
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:defaultAdress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"%@",responseObject[@"info"]);
            infoDict = responseObject[@"info"];
            if ([responseObject[@"code"]intValue] == 0) {
               //判断是否有默认收货地址
                if ([infoDict isKindOfClass:[NSNull class]]) {
                    AW_MyShopCartModal *addAdressModal = [[AW_MyShopCartModal alloc]init];
                    addAdressModal.rowHeight = 50;
                    [weakSelf.dataArr insertObject:addAdressModal atIndex:0];
                }else{
                    //插入默认收货地址
                    AW_MyShopCartModal * modal = [[AW_MyShopCartModal alloc]init];
                    AW_DeliveryAdressModal * adressModal = [[AW_DeliveryAdressModal alloc]init];
                    modal.rowHeight = 70;
                    adressModal.deliveryAdress = infoDict[@"address"];
                    adressModal.deliveryName = infoDict[@"name"];
                    adressModal.deliveryPhoneNumber = infoDict[@"phone"];
                    adressModal.adress_Id = infoDict[@"id"];
                    modal.adressModal = adressModal;
                    //记录默认收货地址
                    weakSelf.defaultAdressModal = adressModal;
                    [weakSelf.dataArr insertObject:modal atIndex:0];
                  //插入分割线
                    AW_MyShopCartModal * separate = [[AW_MyShopCartModal alloc]init];
                    separate.isSeparate = YES;
                    separate.rowHeight = kMarginBetweenCompontents;
                    [weakSelf.dataArr insertObject:separate atIndex:1];
                }
                [self dataDidLoad];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@",[error localizedDescription]);
        }];
  
    }
     [storeModalArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         AW_MyShopCartModal * storeModal = obj;
         NSLog(@"====%@===",storeModal.storeModal.shop_Name);
         if (idx == 0) {
             if (self.adressModal) {
                 //分割线(判断什么时候插入分割线)
                 AW_MyShopCartModal * separate = [[AW_MyShopCartModal alloc]init];
                 separate.isSeparate = YES;
                 separate.rowHeight = kMarginBetweenCompontents;
                 [weakSelf.dataArr addObject:separate];
             }
         }else{
             //分割线(判断什么时候插入分割线)
             AW_MyShopCartModal * separate = [[AW_MyShopCartModal alloc]init];
             separate.isSeparate = YES;
             separate.rowHeight = kMarginBetweenCompontents;
             [weakSelf.dataArr addObject:separate];
         }
        //商铺modal
         AW_StoreModal * storeModalTwo = [[AW_StoreModal alloc]init];
         AW_MyShopCartModal * store = [[AW_MyShopCartModal alloc]init];
         storeModalTwo = storeModal.storeModal;
         store.rowHeight = 42;
         store.storeModal = storeModalTwo;
         [weakSelf.dataArr addObject:store];
          NSLog(@"商铺id：%@",store.storeModal.shop_Id);
         
         [storeModal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AW_MyShopCartModal * articleModal = obj;
             //艺术品modal
             AW_MyShopCartModal * article = [[AW_MyShopCartModal alloc]init];
             article = articleModal;
             articleModal.rowHeight = 88;
             NSLog(@"%@",article.commodityModal.commidity_freight);
             self.tmpfreight = [article.commodityModal.commidity_freight floatValue] +  self.tmpfreight;
             self.total_freight = [article.commodityModal.commidity_freight floatValue] +  self.total_freight;
             [weakSelf.dataArr addObject:articleModal];
         }];
         //留言modal
         AW_MyShopCartModal * otherModal = [[AW_MyShopCartModal alloc]init];
         otherModal.rowHeight = 156;
         otherModal.storeModal.shop_Id = store.storeModal.shop_Id;
         otherModal.total_freight = [NSString stringWithFormat:@"%f",self.tmpfreight];
         [weakSelf.dataArr addObject:otherModal];
         self.tmpfreight = 0;
     }];
    
    //分割线
    AW_MyShopCartModal * separate = [[AW_MyShopCartModal alloc]init];
    separate.isSeparate = YES;
    separate.rowHeight = kMarginBetweenCompontents;
    [weakSelf.dataArr addObject:separate];

    
}
#pragma mark  - UITableViewDataSource  Menthod

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyShopCartModal * modal = self.dataArr[indexPath.row];
    if (indexPath.row == 0) {
        if (self.adressModal) {
             return [self configAdressCellWithModal:modal.adressModal tableView:tableView indexPath:indexPath];
        }else{
            if (modal.rowHeight == 70) {
            return [self configAdressCellWithModal:modal.adressModal tableView:tableView indexPath:indexPath];
            }else{
            return [self configAddAdressCellWithModal:modal tableView:tableView indexPath:indexPath];
            }
        }
    }else if(modal.rowHeight == kMarginBetweenCompontents){
        return [self configSeparateCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if(modal.rowHeight == 42){
        return [self configStoreCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if(modal.rowHeight == 156){
        return [self configOtherCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if(modal.rowHeight == 88){
        return [self configArticleCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else{
    
        return nil;
    }
}

#pragma mark - UITableViewDelegate Menthod

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyShopCartModal * modal = self.dataArr[indexPath.row];
    return  modal.rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyShopCartModal * modal  = self.dataArr[indexPath.row];
    NSInteger cellIndex = indexPath.row;
    if ([[tableView cellForRowAtIndexPath:indexPath]isKindOfClass:[AW_ConfirmOrderAdressCell class]]) {
        _index = cellIndex;
        if (_didSelectCell) {
            _didSelectCell(_index);
        }
    }
    
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[AW_ConfirmOrderArticleCell class]]) {
        _str = modal.commodityModal.commodity_Id;
        NSLog(@"%@",_str);
        if (_didClickedArtCell) {
            _didClickedArtCell(_str);
        }
    }
    
}

#pragma mark - ConfigTableViewCell Menthod

//添加收货地址之前加载cell
-(AW_AddDeliveyAdressCell*)configAddAdressCellWithModal:(AW_MyShopCartModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  static NSString * cellId = @"addAdressCell";
    AW_AddDeliveyAdressCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_AddDeliveyAdressCell");
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

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
    cell.orderName.text = modal.deliveryName;
    cell.orderPhone.text = modal.deliveryPhoneNumber;
    cell.orderAdress.text = modal.deliveryAdress;
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
  [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commodityModal.clearImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    cell.articleDes.text  = [NSString stringWithFormat:@"%@",modal.commodityModal.commodity_Name];
    cell.articleInfo.text = [NSString stringWithFormat:@"%@",modal.commodityModal.commodity_color];
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
    cell.deliveryPrice.text = [NSString stringWithFormat:@"￥%.2f",modal.total_freight.floatValue];
    cell.leaveMessage.placeholder = @"请填写留言";
    __weak typeof(cell) weakCell = cell;
    cell.didClickUseCouponBtn = ^(NSInteger index){
        UIView* v = [weakCell.useCouponBtn superview];
        UIView* v1 = [v superview];
        AW_ConfirmOrderOtherCell * otherCell = (AW_ConfirmOrderOtherCell*)[v1 superview];
        NSIndexPath * path = [tableView indexPathForCell:otherCell];
        NSLog(@"点击了使用优惠券按钮:索引位置%@",path);
        //确定所属的商铺(在那个商铺使用优惠券)
        AW_MyShopCartModal * CommidityModal = self.dataArr[path.row - 1];
        DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
        AW_FavobleView * contentView = BundleToObj(@"AW_FavobleView");
        contentView.bounds = Rect(0, 0, 280, 162);
        alertView.contentView = contentView;
        //点击确定按钮的回调
        contentView.didClickedConfirmBtn = ^(NSString *string){
            NSLog(@"%@",string);
            NSLog(@"商铺id%@",CommidityModal.commodityModal.belongSrote_id);
            NSString * tmpString;
            //将优惠券存入字典
            if (string) {
                tmpString  = string;
            }else{
                tmpString = @"";
            }
            
            //优惠券确认接口(在这进行请求)
            NSDictionary * dict = @{@"coupons":tmpString};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
            NSDictionary * tmpDict = @{@"param":@"checkCoupons",@"jsonParam":str};
           [manager POST:ARTSCOME_INT parameters:tmpDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
               NSLog(@"%@",responseObject);
               NSLog(@"%@",responseObject[@"message"]);
               _tipMessage = responseObject[@"message"];
               [self.couponsDict setValue:[NSString stringWithFormat:@"%@",tmpString] forKey:[NSString stringWithFormat:@"%@",CommidityModal.commodityModal.belongSrote_id]];
               NSLog(@"%@",self.couponsDict);
               if (_didClicked) {
                   _didClicked(_tipMessage);
               }
           } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
               NSLog(@"错误信息：%@",[error localizedDescription]);
           }];
        };
        [alertView show];
    };
    //留言信息编辑完成后的回调
    NSLog(@"%ld",indexPath.row - 1);
    AW_MyShopCartModal * tmpModal = self.dataArr[indexPath.row - 1];
    NSLog(@"%@",tmpModal.commodityModal.belongSrote_id);
    cell.didEndEdite = ^(NSString * message){
        NSLog(@"%@",message);
            [self.messageDict removeObjectForKey:tmpModal.commodityModal.belongSrote_id];
            [self.messageDict setValue:message forKey:tmpModal.commodityModal.belongSrote_id];
        NSLog(@"%@",self.messageDict);
    };
    return cell;
}

/*-(AW_AnonymityCell*)configAnonymityCellWithModal:(AW_MyShopCartModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
   static NSString * cellId = @"AnonymityCell";
    AW_AnonymityCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_AnonymityCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([self.isAnonymity isEqualToString:@"YES"]) {
        cell.AnonymityBtn.selected = YES;
    }else if([self.isAnonymity isEqualToString:@"NO"]){
        cell.AnonymityBtn.selected = NO;
    }
    
    __weak typeof(cell) weakCell = cell;
    cell.didClickUseAnonymityBtn = ^(NSInteger index){
        weakCell.AnonymityBtn.selected = !weakCell.AnonymityBtn.selected;
        if (weakCell.AnonymityBtn.selected) {
            self.isAnonymity = @"YES";
        }else{
           self.isAnonymity = @"NO";
        }
    };

    return cell;
}*/

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
