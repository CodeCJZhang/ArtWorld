//
//  AW_SimilaryCollectionViewCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author cao, 15-10-23 17:10:05
 *
 *  相似艺术品collectionViewCell
 */
@interface AW_SimilaryCollectionViewCell : UICollectionViewCell

/**
 *  @author cao, 15-10-23 17:10:43
 *
 *  按钮图片
 */
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
/**
 *  @author cao, 15-10-23 17:10:21
 *
 *  点击按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger index);
/**
 *  @author cao, 15-10-23 17:10:32
 *
 *  按钮索引
 */
@property(nonatomic)NSInteger index;

@end
