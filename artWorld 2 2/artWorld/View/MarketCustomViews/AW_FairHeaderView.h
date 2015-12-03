//
//  AW_FairHeaderView.h
//  artWorld
//
//  Created by 张亚哲 on 15/7/10.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import <UIKit/UIKit.h>


// 主界面-市集-图片轮播头视图
@interface AW_FairHeaderView : UIView

/**
 *  @author zhe, 15-07-10 11:07:42
 *
 *  广告页图片地址数组
 */
@property (nonatomic,strong)NSArray *adImageArr;

/**
 *  @author zhe, 15-07-10 11:07:40
 *
 *  热门分类地址
 */
@property (nonatomic,strong)NSArray *kindArr;

// 点击轮播头视图回调
@property (nonatomic,copy)void (^didSelectFair)(NSInteger index);

// 点击热门分类图片回调
@property (nonatomic,copy)void (^didSelect)(NSInteger row);

/**
 *  @author zhe, 15-07-10 16:07:34
 *
 *  释放资源
 */
-(void)releaseResource;



@end
