//
//  AW_SuperQuestionCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/28.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_QuestionModal.h"

@interface AW_SuperQuestionCell : UITableViewCell
/**
 *  @author cao, 15-08-28 09:08:46
 *
 *  第一级问题
 */
@property (weak, nonatomic) IBOutlet UILabel *superQuestion;
/**
 *  @author cao, 15-08-28 09:08:01
 *
 *  更多问题的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *moreQuestionBtn;
/**
 *  @author cao, 15-08-28 10:08:25
 *
 *  用来盛放数据
 */
@property(nonatomic,strong)AW_QuestionModal * dataModal;
/**
 *  @author cao, 15-11-10 11:11:15
 *
 *  点击更多按钮的回调
 */
@property(nonatomic,copy)void(^didClickedMoreBtn)(NSInteger index);
/**
 *  @author cao, 15-11-10 11:11:18
 *
 *  cell的索引
 */
@property(nonatomic)NSInteger index;

@end
