//
//  AW_MyCollectArticleCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyCollectArticleCell.h"
#import "AW_Constants.h"

@interface AW_MyCollectArticleCell()
/**
 *  @author cao, 15-08-25 18:08:36
 *
 *  用来设置圆角的视图
 */
@property (weak, nonatomic) IBOutlet UIView *labelView;

@end

@implementation AW_MyCollectArticleCell

- (void)awakeFromNib {
    self.labelView.layer.cornerRadius = 5.0f;
    self.labelView.clipsToBounds = YES;
    self.labelView.backgroundColor = HexRGB(0xCCCCCC);
    UIImage * btnImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    btnImage = ResizableImageDataForMode(btnImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.cancleButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    self.articlePrice.textColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ButtonClick Menthod
- (IBAction)cancleBtnClicked:(id)sender {
    if (_didClickCancleBtn) {
        _didClickCancleBtn(_index);
    }
}


@end
