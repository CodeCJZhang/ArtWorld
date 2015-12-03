//
//  CJParameter.h
//  artWorld
//
//  Created by 张晓旭 on 15/11/4.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJParameter : NSObject

//头像
@property (nonatomic,copy) NSString *icon;

//昵称
@property (nonatomic,copy) NSString *name;

//是否VIP
@property (nonatomic,assign) NSInteger isVIP;

//时间
@property (nonatomic,copy) NSString *time;

//正文
@property (nonatomic,copy) NSString *weiBo;

//图片集合
@property (nonatomic,copy) NSString *photoes;

//地址
@property (nonatomic,copy) NSString *address;

@end
