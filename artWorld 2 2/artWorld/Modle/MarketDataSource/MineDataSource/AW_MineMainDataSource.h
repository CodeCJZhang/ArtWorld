//
//  AW_MineMainDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
/**
 *  @author cao, 15-09-13 14:09:00
 *
 *  我的主界面数据源
 */
@interface AW_MineMainDataSource : IMB_TableDataSource

@property(nonatomic)BOOL hasShop;
@property(nonatomic)BOOL isIdentification;
/**
 *  @author cao, 15-09-13 16:09:55
 *
 *  获取数据
 */
-(void)getData;
/**
 *  @author cao, 15-09-13 15:09:45
 *
 *  点击topCell按钮的回调
 */
@property (nonatomic,copy)void (^didClickHeadViewBtn)(NSInteger index);
/**
 *  @author cao, 15-09-13 15:09:45
 *
 *  点击OrdelCell按钮的回调
 */
@property (nonatomic,copy)void (^didClickOrderViewBtn)(NSInteger index);
/**
 *  @author cao, 15-09-13 15:09:45
 *
 *  点击StoreCell按钮的回调
 */
@property (nonatomic,copy)void (^didClickStoreBtn)(NSInteger index);
/**
 *  @author cao, 15-09-13 15:09:45
 *
 *  点击OtherCell按钮的回调
 */
@property (nonatomic,copy)void (^didClickOtherCellBtn)(NSInteger index);
/**
 *  @author cao, 15-09-13 15:09:45
 *
 *  点击BottomCell按钮的回调
 */
@property (nonatomic,copy)void (^didClickBottomCellBtn)(NSInteger index);
/**
 *  @author cao, 15-11-12 16:11:27
 *
 *  点击按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtnsWithoutProduce)(NSInteger index);
/**
 *  @author cao, 15-10-21 21:10:44
 *
 *  点击申请开店按钮的回调
 */
@property(nonatomic,copy)void(^didClickedOpenShopBtn)();
/**
 *  @author cao, 15-10-21 21:10:49
 *
 *  点击申请认证按钮的回调
 */
@property(nonatomic,copy)void(^didClickedCertificationBtn)();
/**
 *  @author cao, 15-11-12 11:11:34
 *
 *  开店状态
 */
@property(nonatomic,copy)NSString * shop_state;

@end
