//
//  DeliveryAlertView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/2.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryAlertView : UIView
/**
 *  @author cao, 15-09-02 14:09:31
 *
 *  内容视图
 */
@property(nonatomic,strong)UIView * contentView;
/**
 *  @author cao, 15-09-02 14:09:46
 *
 *  显示
 */
-(void)show;
/**
 *  @author cao, 15-09-02 14:09:02
 *
 *  隐藏
 */
-(void)hide;
/**
 *  @author cao, 15-09-02 14:09:46
 *
 *  显示不展示动画
 */
-(void)showWithoutAnimation;
/**
 *  @author cao, 15-09-02 14:09:02
 *
 *  隐藏不展示动画
 */
-(void)hideWithoutAnimation;

@end
