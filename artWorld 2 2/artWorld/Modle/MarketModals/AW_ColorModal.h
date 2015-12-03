//
//  AW_ColorModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

@interface AW_ColorModal : Node

/**
 *  @author cao, 15-11-26 17:11:07
 *
 *  颜色string
 */
@property(nonatomic,copy)NSString * coloredString;
/**
 *  @author cao, 15-11-26 17:11:10
 *
 *  是否选中状态
 */
@property(nonatomic)BOOL isSelect;

@end
