//
//  AW_FavobleView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_FavobleView.h"
#import "AW_Constants.h"
#import "DeliveryAlertView.h"

@interface AW_FavobleView()

/**
 *  @author cao, 15-09-21 11:09:08
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer * topSeparator;
/**
 *  @author cao, 15-09-21 14:09:12
 *
 *  上部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-09-21 14:09:19
 *
 *  下部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation AW_FavobleView

-(CAShapeLayer*)topSeparator{
    if (!_topSeparator) {
        _topSeparator = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _topSeparator.frame = Rect(0, 41, 280, lineHeight);
        _topSeparator.backgroundColor = HexRGB(0x88c244).CGColor;
    }
    return _topSeparator;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.layer addSublayer:self.topSeparator];
    self.confirmBtn.titleLabel.textColor = HexRGB(0x88c244);
    self.backgroundColor = HexRGB(0xf6f7f8);
    self.topView.backgroundColor = HexRGB(0xf6f7f8);
    self.bottomView.backgroundColor = HexRGB(0xf6f7f8);
    UIImage * tmpImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    tmpImage = ResizableImageDataForMode(tmpImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    //设置边框颜色
    [self.confirmBtn setBackgroundImage:tmpImage forState:UIControlStateNormal];
    //设置边框颜色
    [self.privilegeNumber setBackground:tmpImage];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)confirmBtnClicked:(id)sender {
    //将输入的优惠码记录下来
    self.privilegeString = self.privilegeNumber.text;
    if (_didClickedConfirmBtn) {
        _didClickedConfirmBtn(_privilegeString);
    }
    DeliveryAlertView * alertView = (DeliveryAlertView*)self.superview;
    [alertView hide];
}

@end
