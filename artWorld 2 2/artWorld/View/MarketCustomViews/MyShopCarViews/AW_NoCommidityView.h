//
//  AW_NoCommidityView.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  @author cao, 15-10-15 10:10:28
 *
 *  购物车中没有商品时显示的视图
 */
@interface AW_NoCommidityView : UIView
/**
 *  @author cao, 15-10-15 10:10:38
 *
 *  点击随便逛逛按钮的回调
 */
@property(nonatomic,copy)void(^didClickedStrollBtn)();

@end
