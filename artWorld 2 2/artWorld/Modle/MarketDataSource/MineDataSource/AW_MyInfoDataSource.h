//
//  AW_MyInfoDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_ProvinceModal.h"
#import "AW_CityModal.h"
/**
 *  @author cao, 15-08-21 15:08:36
 *
 *  我的信息数据源
 */
@interface AW_MyInfoDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-08-21 17:08:15
 *
 *  获取数据
 */
-(void)getData;
/**
 *  @author cao, 15-09-01 19:09:45
 *
 *  回调
 */
@property (nonatomic,copy)void (^didSelect)(NSInteger row);
/**
 *  @author cao, 15-10-22 17:10:29
 *
 *  点击退出按钮的回调
 */
@property(nonatomic,copy)void(^didClickCancleBtn)();
/**
 *  @author cao, 15-09-27 09:09:03
 *
 *  点击cell上的按钮的回调
 */
@property(nonatomic,copy)void (^didSelectCellBtn)(NSInteger row);
/**
 *  @author cao, 15-09-27 19:09:25
 *
 *  用来接传过来的所在地
 */
@property(nonatomic,copy)NSString *liveAdress;
/**
 *  @author cao, 15-09-28 15:09:33
 *
 *  头像图片
 */
@property(nonatomic,strong)UIImage * headImage;
/**
 *  @author cao, 15-10-16 18:10:17
 *
 *  用来接传过来的收货地址
 */
@property(nonatomic,copy)NSString * tmpDeliveryAdress;

/**
 *  @author cao, 15-11-07 09:11:44
 *
 *  数据加载完以后
 */
@property(nonatomic,copy)void(^didLoadData)();

@end
