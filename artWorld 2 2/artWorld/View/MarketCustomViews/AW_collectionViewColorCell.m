//
//  AW_collectionViewColorCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_collectionViewColorCell.h"
#import "UIImage+IMB.h"
#import "AW_Constants.h"

@implementation AW_collectionViewColorCell

#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    // 颜色变背景图片
    UIImage *normalBgImage = [UIImage imageWithColor:HexRGB(0xD4D4D4)];
    normalBgImage = ResizableImageDataForMode(normalBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    //选中时的颜色
    UIImage *selectBgImage = [UIImage imageWithColor:HexRGB(0x88c244)];
    selectBgImage = ResizableImageDataForMode(selectBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    
    [self.colorButton setBackgroundImage:normalBgImage forState:UIControlStateNormal];
    [self.colorButton setBackgroundImage:selectBgImage forState:UIControlStateSelected];
    self.colorButton.layer.cornerRadius = 4.0;
    self.colorButton.clipsToBounds = YES;
}

#pragma mark - buttonClicked Menthod

- (IBAction)buttonClicked:(id)sender {
    if (_didClickedBtn) {
        _didClickedBtn(_iterm);
    }
}

@end
