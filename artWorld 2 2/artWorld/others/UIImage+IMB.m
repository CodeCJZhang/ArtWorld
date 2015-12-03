//
//  UIImage+IMB.m
//  microtraining
//
//  Created by iMobile on 14-7-8.
//  Copyright (c) 2014年 iMobile. All rights reserved.
//

#import "UIImage+IMB.h"

@implementation UIImage (IMB)

/**
 *  根据指定颜色生成图片
 *
 *  @param color 颜色
 *
 *  @return 图片对象
 */
+ (UIImage*)imageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage * image = [[UIImage alloc] init];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
