//
//  AW_CheckDetailCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_CheckDetailCell : UITableViewCell
/**
 *  @author cao, 15-10-25 16:10:37
 *
 *  点击展示详情cell的回调
 */
@property(nonatomic,copy)void(^didClickBtn)();
/**
 *  @author cao, 15-12-03 16:12:25
 *
 *  展开button视图
 */
@property (weak, nonatomic) IBOutlet UIButton *expendImage;
/**
 *  @author cao, 15-12-03 16:12:14
 *
 *  底部分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;

@end
