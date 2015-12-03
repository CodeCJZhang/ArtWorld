//
//  CJAttachCell.m
//  artWorld
//
//  Created by 张晓旭 on 15/11/7.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "CJAttachCell.h"

@interface CJAttachCell ()



@end

@implementation CJAttachCell

- (void)awakeFromNib {
    // Initialization code
    
    _cellHeight = CGRectGetMaxY(_opinion.frame);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
