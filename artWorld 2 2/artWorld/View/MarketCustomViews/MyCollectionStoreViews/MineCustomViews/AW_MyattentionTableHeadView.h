//
//  AW_MyattentionTableHeadView.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/20.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MyattentionTableHeadView : UIView
/**
 *  @author cao, 15-08-20 21:08:24
 *
 *  我的关注标签
 */
@property (weak, nonatomic) IBOutlet UILabel *myAttentionLabel;
/**
 *  @author cao, 15-08-20 21:08:52
 *
 *  添加关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addAttentionBtn;
/**
 *  @author cao, 15-09-15 09:09:51
 *
 *  索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-09-15 09:09:58
 *
 *  点击添加关注按钮后的回调
 */
@property(nonatomic,copy)void(^didClickAttentionBtn)(NSInteger index);
@end
