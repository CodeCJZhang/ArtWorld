//
//  AW_MyCollectArticleCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MyCollectArticleCell : UITableViewCell
/**
 *  @author cao, 15-08-25 18:08:55
 *
 *  艺术品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
/**
 *  @author cao, 15-08-25 18:08:09
 *
 *  艺术品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *articleName;
/**
 *  @author cao, 15-08-25 18:08:17
 *
 *  艺术品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *articlePrice;
/**
 *  @author cao, 15-09-14 14:09:39
 *
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
/**
 *  @author cao, 15-09-14 14:09:03
 *
 *  点击取消按钮后的回调
 */
@property(nonatomic,copy)void (^didClickCancleBtn)(NSInteger index);
/**
 *  @author cao, 15-09-14 14:09:30
 *
 *  索引
 */
@property(nonatomic)NSInteger index;
@end
