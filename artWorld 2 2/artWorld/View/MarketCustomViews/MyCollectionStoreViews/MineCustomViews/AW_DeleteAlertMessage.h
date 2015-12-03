//
//  AW_DeleteAlertMessage.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/20.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_DeleteAlertMessage : UIView

/**
 *  @author cao, 15-09-20 16:09:09
 *
 *  选中某个按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger index);
/**
 *  @author cao, 15-09-20 16:09:22
 *
 *  按钮的标签
 */
@property(nonatomic)NSInteger btnTag;

@end
