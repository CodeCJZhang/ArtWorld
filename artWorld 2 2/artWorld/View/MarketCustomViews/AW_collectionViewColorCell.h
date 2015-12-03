//
//  AW_collectionViewColorCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_collectionViewColorCell : UICollectionViewCell

/**
 *  @author cao, 15-11-26 15:11:10
 *
 *  颜色按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
/**
 *  @author cao, 15-11-26 15:11:44
 *
 *  点击按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger  index);
/**
 *  @author cao, 15-11-26 15:11:46
 *
 *  商品iterm
 */
@property(nonatomic)NSInteger  iterm;

@end
