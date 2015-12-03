//
//  AW_ConfirmOrderArticleCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ConfirmOrderArticleCell : UITableViewCell
/**
 *  @author cao, 15-09-11 19:09:28
 *
 *  艺术品图像
 */
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
/**
 *  @author cao, 15-09-11 19:09:38
 *
 *  艺术品描述
 */
@property (weak, nonatomic) IBOutlet UILabel *articleDes;
/**
 *  @author cao, 15-09-11 19:09:48
 *
 *  艺术品信息
 */

@property (weak, nonatomic) IBOutlet UILabel *articleInfo;

/**
 *  @author cao, 15-09-11 19:09:20
 *
 *  艺术品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *articleNum;
/**
 *  @author cao, 15-09-12 15:09:47
 *
 *  艺术品的价格
 */
@property (weak, nonatomic) IBOutlet UILabel *articleCurrentPrice;
@end
