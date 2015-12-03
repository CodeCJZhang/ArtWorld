//
//  AW_ProduceCollectionCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/19.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author cao, 15-10-19 10:10:07
 *
 *  作品collectionViewCell(瀑布流cell)
 */
@interface AW_ProduceCollectionCell : UICollectionViewCell


/**
 *  @author cao, 15-10-19 10:10:43
 *
 *  作品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *artImage;
/**
 *  @author cao, 15-10-19 10:10:46
 *
 *  艺术品描述
 */
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
/**
 *  @author cao, 15-10-19 10:10:50
 *
 *  艺术品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/**
 *  @author cao, 15-10-19 10:10:53
 *
 *  收藏按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
/**
 *  @author cao, 15-10-19 10:10:56
 *
 *  收藏显示的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *praiseImageView;
/**
 *  @author cao, 15-10-19 10:10:00
 *
 *  点击收藏按钮的回调
 */
@property(nonatomic,copy)void(^didClickedStoreBtn)(NSInteger index);
/**
 *  @author cao, 15-10-19 10:10:37
 *
 *  索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-10-19 10:10:58
 *
 *  图片的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstant;

@end
