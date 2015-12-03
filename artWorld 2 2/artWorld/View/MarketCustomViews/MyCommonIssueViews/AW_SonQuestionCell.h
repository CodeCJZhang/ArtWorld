//
//  AW_SonQuestionCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/28.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_QuestionModal.h"

@interface AW_SonQuestionCell : UITableViewCell

/**
 *  @author cao, 15-08-28 09:08:30
 *
 *  第二级分类的问题
 */
@property (weak, nonatomic) IBOutlet UILabel *sonQuestion;

/**
 *  @author cao, 15-08-28 10:08:25
 *
 *  用来盛放数据
 */
@property(nonatomic,strong)AW_QuestionModal * dataModal;

@end
