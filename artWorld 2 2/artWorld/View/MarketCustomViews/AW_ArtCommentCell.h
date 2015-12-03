//
//  AW_ArtCommentCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/29.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

/**
 *  @author cao, 15-10-29 17:10:27
 *
 *  商品评论cell
 */
@interface AW_ArtCommentCell : UITableViewCell

/**
 *  @author cao, 15-10-29 18:10:18
 *
 *  评论人头像url
 */
@property (weak, nonatomic) IBOutlet UIImageView *head_img;
/**
 *  @author cao, 15-10-29 18:10:23
 *
 *  评论人名称
 */
@property (weak, nonatomic) IBOutlet UILabel *comment_name;
/**
 *  @author cao, 15-10-29 18:10:28
 *
 *  评论语
 */
@property (weak, nonatomic) IBOutlet UILabel *comment_label;
/**
 *  @author cao, 15-10-29 18:10:30
 *
 *  评论时间截
 */
@property (weak, nonatomic) IBOutlet UILabel *comment_time;
/**
 *  @author cao, 15-10-29 18:10:35
 *
 *  回复
 */
@property (weak, nonatomic) IBOutlet UILabel *reply;
/**
 *  @author cao, 15-11-21 14:11:13
 *
 *  星级视图
 */
@property(nonatomic,strong)CWStarRateView *starRateView;
/**
 *  @author cao, 15-11-21 14:11:40
 *
 *  星级视图
 *
 *  @param str 评分
 */
-(void)floatForStarViewWith:(NSString*)str;

@end
