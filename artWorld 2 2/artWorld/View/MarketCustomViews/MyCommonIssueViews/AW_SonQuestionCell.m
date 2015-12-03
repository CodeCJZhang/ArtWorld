//
//  AW_SonQuestionCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/28.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SonQuestionCell.h"

@implementation AW_SonQuestionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  @author cao, 15-08-28 10:08:03
 *
 *  根据节点所在的层次计算要平移的距离
 *
 *  @param rect 所在位置
 */
-(void)drawRect:(CGRect)rect{
 NSInteger addMeasure = self.dataModal.level * 25;
 
 //让为题label向右移动
 CGRect frame = self.sonQuestion.frame;
 frame.origin.x = 8 + addMeasure;
 self.sonQuestion.frame = frame;
}

@end
