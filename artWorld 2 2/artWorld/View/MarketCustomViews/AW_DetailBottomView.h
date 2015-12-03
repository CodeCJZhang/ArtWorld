//
//  AW_DetailBottomView.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/24.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_DetailBottomView : UIView

/**
 *  @author cao, 15-10-24 16:10:28
 *
 *  赞图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *praiseImage;
/**
 *  @author cao, 15-10-24 16:10:37
 *
 *  收藏label
 */
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
/**
 *  @author cao, 15-10-24 16:10:35
 *
 *  点击按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger index);
/**
 *  @author cao, 15-10-24 16:10:37
 *
 *  按钮的索引
 */
@property(nonatomic)NSInteger index;
@end
