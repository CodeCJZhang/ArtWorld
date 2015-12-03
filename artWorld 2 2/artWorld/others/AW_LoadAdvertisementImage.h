//
//  AW_LoadAdvertisementImage.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/27.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AW_LoadAdvertisementImage : NSObject

/**
 *  @author cao, 15-11-27 11:11:00
 *
 *  请求图片
 */
+(void)requestAdvertisementImage;
/**
 *  @author cao, 15-11-27 14:11:37
 *
 *  是否显示广告图片
 *
 *  @return BOOL
 */
+ (BOOL)isShouldDisplayAd;
/**
 *  @author cao, 15-11-27 14:11:25
 *
 *  获得广告图片
 *
 *  @return 广告图片
 */
+ (UIImage *)getAdImage;

@end
