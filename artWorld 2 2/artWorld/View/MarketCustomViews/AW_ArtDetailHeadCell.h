//
//  AW_ArtDetailHeadCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "CWStarRateView.h"

/**
 *  @author cao, 15-10-23 14:10:57
 *
 *  艺术品详情头视图
 */
@interface AW_ArtDetailHeadCell : UITableViewCell
/**
 *  @author cao, 15-11-25 21:11:44
 *
 *  顶部视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

/**
 *  @author cao, 15-10-23 15:10:42
 *
 *  轮播视图
 */
@property (weak, nonatomic) IBOutlet iCarousel *icarouselView;
/**
 *  @author cao, 15-10-23 15:10:53
 *
 *  页码
 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
/**
 *  @author cao, 15-10-23 15:10:07
 *
 *  艺术品描述
 */
@property (weak, nonatomic) IBOutlet UILabel *artDescribe;
/**
 *  @author cao, 15-10-23 15:10:25
 *
 *  星级容器
 */
@property (weak, nonatomic) IBOutlet UIView *starView;
/**
 *  @author cao, 15-11-21 14:11:40
 *
 *  星级视图
 */
@property (strong, nonatomic) CWStarRateView *starRateView;
/**
 *  @author cao, 15-10-23 15:10:39
 *
 *  评价label
 */
@property (weak, nonatomic) IBOutlet UILabel *EvaluateLabel;
/**
 *  @author cao, 15-10-23 15:10:53
 *
 *  多少人进行了评价
 */
@property (weak, nonatomic) IBOutlet UILabel *evalutePersonLabel;
/**
 *  @author cao, 15-12-01 23:12:55
 *
 *  星级评分
 */
@property(nonatomic,copy)NSString * starGrade;
/**
 *  @author cao, 15-10-23 15:10:08
 *
 *  轮播图片数组
 */
@property(nonatomic,strong)NSArray * adImageArr;
/**
 *  @author cao, 15-10-23 16:10:23
 *
 *  点击轮播视图按钮的回调
 */
@property(nonatomic,copy)void(^didClickedICrouselView)(NSInteger index,NSArray * imageArray);
/**
 *  @author cao, 15-10-25 13:10:22
 *
 *  点击按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger index);
/**
 *  @author cao, 15-10-23 16:10:17
 *
 *  轮播图图片索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-10-25 13:10:30
 *
 *  获取轮播图片
 *
 *  @param adImageArr 图片数组
 */
-(void)setAdImageArr:(NSArray *)adImageArr;
/**
 *  @author cao, 15-11-21 11:11:47
 *
 *  星级评分
 *
 *  @param evalute 评价
 */
-(void)floatForStarViewWith:(NSString *)str;

@end
