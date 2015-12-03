//
//  CJCellParameter.h
//  artWorld
//
//  Created by 张晓旭 on 15/11/2.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJCellParameter : NSObject

//头像
@property (nonatomic,copy) NSString *iconImage;

//昵称
@property (nonatomic,copy) NSString *name;

//是否VIP
@property (nonatomic,assign) NSInteger isVIP;

//商铺状态
@property (nonatomic,assign) NSInteger shopState;

//昵称简介
@property (nonatomic,copy) NSString *nameDesc;

//作品简介
@property (nonatomic,copy) NSString *pictureDesc;

//清晰照片集合
@property (nonatomic,copy) NSString *clearImages;

//模糊照片集合
@property (nonatomic,copy) NSString *fuzzyImages;

//时间
@property (nonatomic,copy) NSString *time;

//发布地址
@property (nonatomic,copy) NSString *address;

//是否赞过
@property (nonatomic) BOOL isPraised;

//微博ID
@property (nonatomic,copy) NSString *weibo_id;

//被转发微博
@property (nonatomic,strong) NSDictionary *original_dict;

@end
