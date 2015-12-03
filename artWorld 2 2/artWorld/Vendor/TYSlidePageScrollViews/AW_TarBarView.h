//
//  AW_TarBarView.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/20.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "TYBasePageTabBar.h"

@interface AW_TarBarView : TYBasePageTabBar
/**
 *  @author cao, 15-08-20 18:08:47
 *
 *  我的作品label
 */
@property (weak, nonatomic) IBOutlet UILabel *produceLabel;
/**
 *  @author cao, 15-08-20 18:08:00
 *
 *  我的关注label
 */
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
/**
 *  @author cao, 15-08-20 18:08:15
 *
 *  我的粉丝Label
 */
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
/**
 *  @author cao, 15-08-20 18:08:26
 *
 *  我的动态label
 */
@property (weak, nonatomic) IBOutlet UILabel *dynamicLabel;

/**
 *  @author cao, 15-08-20 02:08:56
 *
 *  作品数量
 */

@property (weak, nonatomic) IBOutlet UILabel *produceNumber;

/**
 *  @author cao, 15-08-20 02:08:19
 *
 *  关注数量
 */
@property (weak, nonatomic) IBOutlet UILabel *attentionNumber;

/**
 *  @author cao, 15-08-20 02:08:44
 *
 *  粉丝数量
 */
@property (weak, nonatomic) IBOutlet UILabel *fansNumber;

/**
 *  @author cao, 15-08-20 02:08:06
 *
 *  动态数量
 */
@property (weak, nonatomic) IBOutlet UILabel *dynamicNumber;


/**
 *  @author cao, 15-08-20 02:08:16
 *
 *  整个视图，用来设置灰色分割线
 */
@property (weak, nonatomic) IBOutlet UIView *totalView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsWithoutProduce;

/**
 *  @author cao, 15-08-20 10:08:51
 *
 *  字体颜色
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 *  @author cao, 15-08-20 10:08:36
 *
 *  选中状态下字体颜色
 */
@property (nonatomic, strong) UIColor *selectedTextColor;
/**
 *  @author cao, 15-08-20 10:08:58
 *
 *  水平指示器颜色
 */
@property (nonatomic, strong) UIColor *horIndicatorColor;
/**
 *  @author cao, 15-08-20 10:08:16
 *
 *  水平指示器高度
 */
@property (nonatomic, assign) CGFloat horIndicatorHeight;

/**
 *  @author cao, 15-08-20 10:08:42
 *
 *  button数组
 */
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;
/**
 *  @author cao, 15-08-20 10:08:29
 *
 *  选中的button
 */
@property (nonatomic, strong) UIButton *selectBtn;
/**
 *  @author cao, 15-08-20 10:08:45
 *
 *  水平指示器视图
 */
@property (nonatomic, strong) UIView *horIndicatorView;
/**
 *  @author cao, 15-08-20 15:08:57
 *
 *  选中的按钮的标签
 */
@property(nonatomic)NSInteger selectBtnTag;
/**
 *  @author cao, 15-09-25 17:09:34
 *
 *  current ScrollView index
 */
@property(nonatomic)NSInteger currentIndex;
/**
 *  @author cao, 15-11-12 15:11:19
 *
 *  图片滚动式的回调
 */
@property(nonatomic,copy)void(^scrollViewDidScroll)(NSInteger index);
/**
 *  @author cao, 15-11-12 15:11:42
 *
 *  当前的索引
 */
@property(nonatomic)NSInteger  index;

- (IBAction)bottonClickMenthod:(id)sender;
/**
 *  @author cao, 15-11-12 11:11:10
 *
 *  开店状态
 */
@property(nonatomic,copy)NSString * shop_State;

/**
 *  @author zhe, 15-07-15 17:07:14
 *
 *  左边分割线
 */
@property (nonatomic,strong)CAShapeLayer *leftLayer;
/**
 *  @author cao, 15-08-17 10:08:03
 *
 *  中间分割线
 */
@property(nonatomic,strong)CAShapeLayer * midleLayer;
/**
 *  @author zhe, 15-07-15 17:07:40
 *
 *  右边分割线
 */
@property (nonatomic,strong)CAShapeLayer *rightLayer;
/**
 *  @author cao, 15-11-12 11:11:28
 *
 *  左分割线
 */
@property(nonatomic,strong)CAShapeLayer * left2layer;
/**
 *  @author cao, 15-11-12 11:11:47
 *
 *  右分隔线
 */
@property(nonatomic,strong)CAShapeLayer * right2Layer;
@end
