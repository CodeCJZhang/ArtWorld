//
//  AW_PopView.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/25.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_PopView : UIView
/**
 *  @author cao, 15-10-25 11:10:30
 *
 *  点击按钮的回调
 */
@property(nonatomic,copy)void(^didClickedButton)(NSInteger index);
/**
 *  @author cao, 15-10-25 11:10:46
 *
 *  按钮索引
 */
@property(nonatomic)NSInteger index;

@end
