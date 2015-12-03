//
//  AW_CheckPhonePersonCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_CheckPhonePersonCell.h"
#import "UIImage+IMB.h"
#import "AW_Constants.h"

@implementation AW_CheckPhonePersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage * btnImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    btnImage = ResizableImageDataForMode(btnImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    // 颜色变背景图片
    UIImage *normalBgImage = [UIImage imageWithColor:HexRGB(0xFFFFFF)];
    normalBgImage = ResizableImageDataForMode(normalBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.attentionBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [self.attentionBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [self.attentionBtn setBackgroundImage:normalBgImage forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - ButtonClicked Menthod
- (IBAction)attentionClicked:(id)sender {
    
    if (_didClickAttentionBtn) {
        _didClickAttentionBtn(_indexPath);
    }
}
@end
