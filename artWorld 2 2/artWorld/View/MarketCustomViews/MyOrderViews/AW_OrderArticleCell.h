//
//  AW_OrderArticleCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_OrderArticleCell : UITableViewCell
/**
 *  @author cao, 15-10-12 17:10:31
 *
 *  用来设置颜色的视图
 */
@property (weak, nonatomic) IBOutlet UIView *colorContainerView;

/**
 *  @author cao, 15-10-12 17:10:51
 *
 *  艺术品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
/**
 *  @author cao, 15-10-12 17:10:04
 *
 *  艺术品名字
 */
@property (weak, nonatomic) IBOutlet UILabel *articleName;
/**
 *  @author cao, 15-10-12 17:10:13
 *
 *  艺术品描述
 */
@property (weak, nonatomic) IBOutlet UILabel *articleDescribe;
/**
 *  @author cao, 15-10-12 17:10:24
 *
 *  艺术品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *articlePrice;
/**
 *  @author cao, 15-10-12 17:10:38
 *
 *  艺术品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *articleNum;

@end
