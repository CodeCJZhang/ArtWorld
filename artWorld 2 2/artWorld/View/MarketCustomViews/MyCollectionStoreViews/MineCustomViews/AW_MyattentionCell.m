//
//  AW_MyattentionCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyattentionCell.h"
#import "IMB_Macro.h"
#import "UIImage+IMB.h"
@interface AW_MyattentionCell()

@property(nonatomic,strong)CAShapeLayer * buttomLayer;

@end

@implementation AW_MyattentionCell

- (void)awakeFromNib {
    
  //[self.layer addSublayer:_buttomLayer];
    /**
     *  @author cao, 15-08-18 11:08:35
     *
     *  设置圆角
     */
    self.vipImage.layer.cornerRadius = self.vipImage.bounds.size.height/2;
    self.vipImage.clipsToBounds = YES;
    self.portraitImage.layer.cornerRadius = 5;
    self.portraitImage.clipsToBounds = YES;
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

    // Configure the view for the selected state
}

#pragma mark - ButtonClicked Menthod
- (IBAction)attentinBtnClicked:(id)sender {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]) {
        self.rightButton.selected = !self.rightButton.selected;
    }
    if (_didClickAttentionBtn) {
        _didClickAttentionBtn(_index);
    }
}

@end
