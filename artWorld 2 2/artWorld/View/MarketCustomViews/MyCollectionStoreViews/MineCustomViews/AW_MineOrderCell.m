//
//  AW_MineOrderCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MineOrderCell.h"

@implementation AW_MineOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ButtonClick Menthod
- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClickKindBtn) {
        _didClickKindBtn(_index);
    }
}

@end
