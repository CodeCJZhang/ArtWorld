//
//  AW_PersonSearchCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/30.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_PersonSearchCell.h"
#import "UIImage+IMB.h"
#import "AW_Constants.h"

@implementation AW_PersonSearchCell

- (void)awakeFromNib {
    self.headImage.layer.cornerRadius = 5;
    self.headImage.clipsToBounds = YES;
    // 颜色变背景图片
    UIImage *normalBgImage = [UIImage imageWithColor:HexRGB(0xFFFFFF)];
    normalBgImage = ResizableImageDataForMode(normalBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"我的-详情-加关注"] forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:normalBgImage forState:UIControlStateSelected];
    [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"已关注" forState:UIControlStateSelected];
    [self.rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    self.rightButton.tintColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - ButtonClicked Menthod

- (IBAction)buttonClicked:(id)sender {
    self.rightButton.selected = !self.rightButton.selected;
    if (_didClickedBtn) {
        _didClickedBtn(_index);
    }
}

@end
