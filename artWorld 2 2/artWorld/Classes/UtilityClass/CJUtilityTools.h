//
//  CJTimeStampProcessing.h
//  artWorld
//
//  Created by 张晓旭 on 15/11/27.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJUtilityTools : NSObject

//时间戳变可用时间
+(NSString *)timeStampWithTimeStr:(NSString *)string;

//图片字符串拆分为URL数组
+(NSArray *)imageUrlArrWithUrlStr:(NSString *)urlStr;

//计算设定好宽度与字号的文本高度
+(CGFloat)countTextHeightWithString:(NSString *)string placeHolderWidth:(CGFloat)width;

//HTML串变可阅读字符串
+(NSString *)filterHTMLWithString:(NSString *)string;

//表情变字符串
+ (NSString *)convertToCommonEmoticons:(NSString *)text;
//字符串变表情
+ (NSString *)convertToSystemEmoticons:(NSString *)text;

//原始串（表情字符串、HTML串）变可阅读字符串
+ (NSString *)convertToViewableWithString:(NSString *)text;

@end
