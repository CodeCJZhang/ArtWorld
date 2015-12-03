//
//  AW_AdressModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
/**
 *  @author cao, 15-09-27 11:09:24
 *
 *  所在地modal
 */
@interface AW_AdressModal : Node
/**
 *  @author cao, 15-09-27 11:09:17
 *
 *  所在地
 */
@property(nonatomic,copy)NSString * liveAdress;
/**
 *  @author cao, 15-09-27 19:09:13
 *
 *  所属的省份
 */
@property(nonatomic,strong)NSString*belongProvince;
/**
 *  @author cao, 15-09-27 11:09:27
 *
 *  省份子数组
 */
@property(nonatomic,strong)NSMutableArray * subArray;

@end
