//
//  AW_CityController.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/7.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_ProvinceModal.h"
#import "AW_CityModal.h"

@protocol AW_MyAdressDelegate <NSObject>

-(void)didClickedCityCell:(AW_ProvinceModal*)provinceModal city:(AW_CityModal * )cityModal;

@end

/**
 *  @author cao, 15-11-07 10:11:14
 *
 *  家乡城市控制器
 */
@interface AW_CityController : UIViewController
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
@property(nonatomic,weak)id<AW_MyAdressDelegate> delegate;

@end
