//
//  AW_MyPreferenceModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/6.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AW_MyPreferenceModal : NSObject
/**
 *  @author cao, 15-09-06 09:09:07
 *
 *  图片地址
 */
@property(nonatomic,copy)NSString * imageURL;
/**
 *  @author cao, 15-09-06 09:09:24
 *
 *  偏好设置类别
 */
@property(nonatomic,copy)NSString * preferenceDes;
/**
 *  @author cao, 15-09-06 16:09:31
 *
 *  判断是否为选中状态
 */
@property(nonatomic)BOOL isSelect;
/**
 *  @author cao, 15-10-26 09:10:56
 *
 *  兴趣id
 */
@property(nonatomic,copy)NSString * hobby_id;

@end
