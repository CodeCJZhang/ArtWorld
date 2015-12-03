//
//  AW_FairKindCell.h
//  artWorld
//
//  Created by 张亚哲 on 15/7/10.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import <UIKit/UIKit.h>

// 热门分类Cell
@interface AW_FairKindCell : UICollectionViewCell

/**
 *  @author zhe, 15-07-10 14:07:35
 *
 *  分类图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *kingImageView;
/**
 *  @author zhe, 15-07-10 14:07:46
 *
 *  分类标题
 */
@property (weak, nonatomic) IBOutlet UILabel *kingTitle;

// 热门分类按钮
@property (weak, nonatomic) IBOutlet UIButton *kingBtn;


@property (nonatomic,assign) NSInteger index;

// 点击热门分类图片回调
@property (nonatomic,copy)void (^selectKindBtn)(NSInteger index);



@end
