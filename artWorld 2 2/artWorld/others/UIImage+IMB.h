//
//  UIImage+IMB.h
//  microtraining
//
//  Created by iMobile on 14-7-8.
//  Copyright (c) 2014年 iMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IMB)

/**
 *  根据指定颜色生成图片
 *
 *  @param color 颜色
 *
 *  @return 图片对象
 */
+ (UIImage*)imageWithColor:(UIColor*)color;

@end
