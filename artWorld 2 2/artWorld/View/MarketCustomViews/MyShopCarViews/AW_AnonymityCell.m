//
//  AW_AnonymityCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_AnonymityCell.h"

@implementation AW_AnonymityCell

#pragma mark - Private Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.AnonymityBtn setBackgroundImage:[[UIImage imageNamed:@"回复评论--未选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.AnonymityBtn setBackgroundImage:[[UIImage imageNamed:@"回复评论--选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - ButtonClick Menthod
- (IBAction)AnonymityBtnClicked:(id)sender {
    if (_didClickUseAnonymityBtn) {
        _didClickUseAnonymityBtn(_index);
    }
}


@end
