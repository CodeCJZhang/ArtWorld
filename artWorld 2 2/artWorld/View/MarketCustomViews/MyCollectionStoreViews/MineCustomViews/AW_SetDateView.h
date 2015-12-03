//
//  AW_SetDateView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/26.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_SetDateView : UIView
/**
 *  @author cao, 15-09-26 13:09:19
 *
 *  按钮标签
 */
@property(nonatomic)NSInteger buttonTag;
/**
 *  @author cao, 15-09-26 13:09:27
 *
 *  日期字符串
 */
@property(nonatomic,copy)NSDate * dateString;
/**
 *  @author cao, 15-09-26 13:09:38
 *
 *  点击按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger index ,NSDate * dateString);
@end
