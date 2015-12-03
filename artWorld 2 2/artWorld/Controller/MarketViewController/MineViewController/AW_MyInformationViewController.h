//
//  AW_MyInformationViewController.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_ConfirmOrderDataSource.h"
#import "AW_MyInfoDataSource.h"//我的个人信息数据源

/**
 *  @author cao, 15-08-21 11:08:02
 *
 *  我的个人资料
 */
@interface AW_MyInformationViewController : UIViewController

/**
 *  @author cao, 15-08-21 15:08:25
 *
 *  我的个人信息数据源
 */
@property(nonatomic,strong)AW_MyInfoDataSource * infoDataSource;
/**
 *  @author cao, 15-09-06 15:09:32
 *
 *  用来接偏好设置界面传过来的数据
 */
@property(nonatomic,strong)NSMutableString * preferenceString;
/**
 *  @author cao, 15-10-26 11:10:28
 *
 *  用来接兴趣id的字符串
 */
@property(nonatomic,copy)NSMutableString * hobbyIdString;
/**
 *  @author cao, 15-11-07 15:11:14
 *
 *  收货地址id
 */
@property(nonatomic,copy)NSString * adress_id;
/**
 *  @author cao, 15-11-09 13:11:27
 *
 *  头像路径
 */
@property(nonatomic,copy)NSString * headImgPath;

@end
