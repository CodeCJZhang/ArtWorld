//
//  AW_LiveCityController.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/14.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_ProvinceModal.h"
#import "AW_CityModal.h"

@protocol AW_MyLiveAdressDelegate <NSObject>

-(void)didClickedLiveAdressCityCell:(AW_ProvinceModal*)provinceModal city:(AW_CityModal * )cityModal;

@end

/**
 *  @author cao, 15-11-14 10:11:39
 *
 *  所在地城市控制器
 */
@interface AW_LiveCityController : UIViewController

/**
 *  @author cao, 15-11-07 11:11:02
 *
 *  省份modal
 */
@property(nonatomic,strong)AW_ProvinceModal * provinceModal;
/**
 *  @author cao, 15-11-07 14:11:55
 *
 *  城市modal
 */
@property(nonatomic,strong)AW_CityModal * cityModal;
/**
 *  @author cao, 15-11-07 14:11:36
 *
 *  代理对象
 */
@property(nonatomic,weak)id<AW_MyLiveAdressDelegate> delegate;

@end
