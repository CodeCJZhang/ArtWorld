//
//  NSString+Convert.m
//  7.1_添加索引和搜索栏
//
//  Created by 曹学亮 on 15/7/1.
//  Copyright (c) 2015年 曹学亮. All rights reserved.
//

#import "NSString+Convert.h"

@implementation NSString (Convert)


- (NSString*)convertToPinYinWithTone{
    NSMutableString *str = [self mutableCopy];
    CFMutableStringRef cfstr = (__bridge CFMutableStringRef)(str);
    //CFRange strRange = CFRangeMake(0, str.length); //传 |Null| 表示所有都转换
    CFStringTransform(cfstr, NULL, kCFStringTransformMandarinLatin, false);
    return str;
}



- (NSString*)convertToPinYinWithoutTone{
    NSMutableString *str = [[self convertToPinYinWithTone]mutableCopy];
    CFMutableStringRef cfstr = (__bridge CFMutableStringRef)(str);
    //CFRange strRange = CFRangeMake(0, str.length); //传 |Null| 表示所有都转换
    CFStringTransform(cfstr, NULL, kCFStringTransformStripDiacritics, false);
    return str;
}


@end
