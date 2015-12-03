//
//  AW_DeliveryAdressDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/1.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_DeliveryAdressModal.h"

@protocol AW_AdressDelegate <NSObject>

-(void)didClickAdressCell:(AW_DeliveryAdressModal*)modal;

@end

@interface AW_DeliveryAdressDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-09-20 17:09:00
 *
 *  代理属性
 */
@property(nonatomic,weak)id<AW_AdressDelegate>delegate;
/**
 *  @author cao, 15-09-02 16:09:50
 *
 *  用来盛放修改以后的收货地址或者添加新的收货地址(重新插入dataArray)
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * freshAdressModal;
/**
 *  @author cao, 15-11-05 16:11:36
 *
 *  编辑之后的modal
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * editeModal;
/**
 *  @author cao, 15-09-07 17:09:40
 *
 *  编辑或删除了第几个收货地址
 */
@property(nonatomic)NSInteger adressIndex;
/**
 *  @author cao, 15-09-20 17:09:04
 *
 *  点击cell单元格后的回调
 */
@property(nonatomic,copy)void(^didSelectAdressCell)(AW_DeliveryAdressModal *adressModal);
/**
 *  @author cao, 15-10-10 15:10:07
 *
 *  点击确定按钮的回调
 */
@property(nonatomic,copy)void(^didClickedConfirmButton)(AW_DeliveryAdressModal *modal);
/**
 *  @author cao, 15-10-11 19:10:22
 *
 *  先点击编辑按钮，然后点击确定按钮的回调
 */
@property(nonatomic,copy)void(^didClickedEditeConfirmBtn)(AW_DeliveryAdressModal * modal);
/**
 *  @author cao, 15-10-10 15:10:19
 *
 *  点击删除按钮后的回调
 */
@property(nonatomic,copy)void(^didClickedDeleteBtn)(NSInteger  index);
/**
 *  @author cao, 15-10-10 15:10:48
 *
 *  临时的收货地址modal
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * tmpModal;
/**
 *  @author cao, 15-09-20 17:09:24
 *
 *  收货地址modal
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * addressModal;

/**
 *  @author cao, 15-09-07 10:09:14
 *
 *  获取测试数据
 */
-(void)getData;
/**
 *  @author cao, 15-11-13 13:11:36
 *
 *  已经是默认收货地址时，进行提示
 */
@property(nonatomic,copy)void(^isDefaultAdress)();
/**
 *  @author cao, 15-12-02 10:12:41
 *
 *  设置默认收货地址成功
 */
@property(nonatomic,copy)void(^defaultAdressSucess)(AW_DeliveryAdressModal * modal);
/**
 *  @author cao, 15-12-02 10:12:46
 *
 *  记录默认收货地址
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * Modal;
/**
 *  @author cao, 15-12-02 11:12:40
 *
 *  请求成功后的回调
 */
@property(nonatomic,copy)void(^didRequestSucess)();

@end
