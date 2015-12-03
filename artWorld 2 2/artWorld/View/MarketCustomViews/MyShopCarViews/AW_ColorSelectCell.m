//
//  AW_ColorSelectCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/18.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ColorSelectCell.h"
#import "UIImage+IMB.h"
#import "AW_Constants.h"

@implementation AW_ColorSelectCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // 颜色变背景图片
    UIImage *normalBgImage = [UIImage imageWithColor:HexRGB(0xD4D4D4)];
    normalBgImage = ResizableImageDataForMode(normalBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    //选中时的颜色
    UIImage *selectBgImage = [UIImage imageWithColor:HexRGB(0x88c244)];
    selectBgImage = ResizableImageDataForMode(selectBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.redBtn setBackgroundImage:selectBgImage forState:UIControlStateSelected];
    [self.redBtn setBackgroundImage:normalBgImage forState:UIControlStateNormal];
    self.redBtn.layer.cornerRadius = 5.0f;
    self.redBtn.clipsToBounds = YES;
    [self.blueBtn setBackgroundImage:selectBgImage forState:UIControlStateSelected];
    [self.blueBtn setBackgroundImage:normalBgImage forState:UIControlStateNormal];
    self.blueBtn.layer.cornerRadius = 5.0f;
    self.blueBtn.clipsToBounds = YES;
    [self.grayBtn setBackgroundImage:selectBgImage forState:UIControlStateSelected];
    [self.grayBtn setBackgroundImage:normalBgImage forState:UIControlStateNormal];
    self.grayBtn.layer.cornerRadius = 5.0f;
    self.grayBtn.clipsToBounds = YES;
    
    self.separateView.backgroundColor = HexRGB(0xf6f7f8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)colorBtnClicked:(id)sender {
    UIButton * btn = sender;
    btn.selected = !btn.selected;
    if (btn.tag == 1) {
        self.blueBtn.selected = NO;
        self.grayBtn.selected = NO;
    }else if (btn.tag == 2){
        self.redBtn.selected = NO;
        self.grayBtn.selected = NO;
    }else if (btn.tag == 3){
        self.redBtn.selected = NO;
        self.blueBtn.selected = NO;
    }
    
    _btnTag = btn.tag;
    if (_didClickColorBtn) {
        _didClickColorBtn(_btnTag);
    }
}

@end
