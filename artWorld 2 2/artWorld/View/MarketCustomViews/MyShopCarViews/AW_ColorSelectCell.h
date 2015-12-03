//
//  AW_ColorSelectCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/18.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ColorSelectCell : UITableViewCell
/**
 *  @author cao, 15-09-19 11:09:01
 *
 *  艺术品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
/**
 *  @author cao, 15-09-18 19:09:38
 *
 *  艺术品描述
 */
@property (weak, nonatomic) IBOutlet UILabel *artDescribe;
/**
 *  @author cao, 15-09-18 19:09:48
 *
 *  分割线视图
 */
@property (weak, nonatomic) IBOutlet UIView *separateView;
/**
 *  @author cao, 15-09-18 19:09:57
 *
 *  红色按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *redBtn;
/**
 *  @author cao, 15-09-18 19:09:07
 *
 *  蓝色按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *blueBtn;
/**
 *  @author cao, 15-09-18 19:09:24
 *
 *  褐色按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *grayBtn;
/**
 *  @author cao, 15-09-20 10:09:06
 *
 *  点击颜色按钮后的回调
 */
@property(nonatomic,copy)void (^didClickColorBtn)(NSInteger index);
/**
 *  @author cao, 15-09-20 10:09:29
 *
 *  按钮标签
 */
@property(nonatomic)NSInteger btnTag;

@end
