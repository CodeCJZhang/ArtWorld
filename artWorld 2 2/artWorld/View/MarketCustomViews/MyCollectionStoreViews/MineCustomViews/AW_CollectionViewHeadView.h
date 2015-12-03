//
//  AW_CollectionViewHeadView.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_CollectionViewHeadView : UIView

/**
 *  @author cao, 15-08-18 09:08:54
 *
 *  collectionview头视图图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
/**
 *  @author cao, 15-08-18 09:08:22
 *
 *  我的作品数量
 */

@property (weak, nonatomic) IBOutlet UILabel *myProduceNumber;
/**
 *  @author cao, 15-10-19 15:10:37
 *
 *  分类名称
 */
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;

/**
 *  @author cao, 15-08-18 09:08:34
 *
 *  筛选按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
/**
 *  @author cao, 15-08-18 09:08:51
 *
 *  筛选按钮左侧图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *fiterButtonLeftImage;
/**
 *  @author cao, 15-09-14 18:09:46
 *
 *  点击筛选按钮后的回调
 */
@property(nonatomic,copy)void (^didClickFiterBtn)(NSInteger index);
/**
 *  @author cao, 15-09-18 15:09:28
 *
 *  点击上部按钮的回调
 */
@property(nonatomic,copy)void(^didClickedTopBtn)(NSInteger index);
/**
 *  @author cao, 15-09-14 18:09:02
 *
 *  索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-09-18 15:09:28
 *
 *  图片按钮视图
 */
@property (weak, nonatomic) IBOutlet UIButton *topButton;


@end
