//
//  AW_SuperQuestionCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/28.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SuperQuestionCell.h"

@implementation AW_SuperQuestionCell

#pragma  mark - Privaye Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    if (_didClickedMoreBtn) {
        _didClickedMoreBtn(_index);
    }
}

@end
