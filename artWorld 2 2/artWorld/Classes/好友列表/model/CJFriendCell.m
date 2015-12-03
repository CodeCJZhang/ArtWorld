//
//  CJFriendCell.m
//  artWorld
//
//  Created by 张晓旭 on 15/10/31.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "CJFriendCell.h"

@implementation CJFriendCell

- (void)awakeFromNib {
    // Initialization code
    
    _selectImg.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
