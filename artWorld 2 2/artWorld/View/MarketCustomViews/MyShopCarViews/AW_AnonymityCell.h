//
//  AW_AnonymityCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_AnonymityCell : UITableViewCell
/**
 *  @author cao, 15-09-12 10:09:10
 *
 *  匿名购买按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *AnonymityBtn;
/**
 *  @author cao, 15-09-12 19:09:54
 *
 *  点击匿名购买后的回调
 */
@property (nonatomic,copy)void (^didClickUseAnonymityBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-12 09:09:22
 *
 *  索引
 */
@property(nonatomic)NSInteger index;
@end
