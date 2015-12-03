//
//  AW_SearchCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SearchCell.h"
#import "AW_Constants.h"
#import "UIImage+IMB.h"

@implementation AW_SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage * btnImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    btnImage = ResizableImageDataForMode(btnImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    // 颜色变背景图片
    UIImage *normalBgImage = [UIImage imageWithColor:HexRGB(0xFFFFFF)];
    normalBgImage = ResizableImageDataForMode(normalBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.attentionBtn setBackgroundImage:normalBgImage forState:UIControlStateHighlighted];
    if ([[self.attentionBtn titleForState:UIControlStateNormal]isEqualToString:@"已关注"]) {
        [self.attentionBtn setBackgroundImage:normalBgImage forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }else if ([[self.attentionBtn titleForState:UIControlStateNormal]isEqualToString:@"关注"]){
       [self.attentionBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
       [self.attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
}
#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    //self.attentionBtn.selected = !self.attentionBtn.selected;
    UIImage * btnImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    btnImage = ResizableImageDataForMode(btnImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    // 颜色变背景图片
    UIImage *normalBgImage = [UIImage imageWithColor:HexRGB(0xFFFFFF)];
    normalBgImage = ResizableImageDataForMode(normalBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    if ([[self.attentionBtn titleForState:UIControlStateNormal]isEqualToString:@"已关注"]) {
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.attentionBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if ([[self.attentionBtn titleForState:UIControlStateNormal]isEqualToString:@"关注"]){
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.attentionBtn setBackgroundImage:normalBgImage forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }
    if (_didClickedAttentionBtn) {
        _didClickedAttentionBtn(_index);
    }
}

@end
