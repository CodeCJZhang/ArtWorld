//
//  AW_ChatTimeCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/16.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ChatTimeCell.h"

@implementation AW_ChatTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"时间底"]];
    [self.sendTime setBackgroundColor:color];
    self.sendTime.layer.cornerRadius = 3.0;
    self.sendTime.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
