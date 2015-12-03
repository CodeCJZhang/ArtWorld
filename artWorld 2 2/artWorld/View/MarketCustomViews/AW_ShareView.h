//
//  AW_ShareView.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/25.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ShareView : UIView

/**
 *  @author cao, 15-10-25 11:10:09
 *
 *  点击按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger index);
/**
 *  @author cao, 15-10-25 11:10:19
 *
 *  按钮索引
 */
@property(nonatomic)NSInteger index;
@end
