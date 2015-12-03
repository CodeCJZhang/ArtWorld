//
//  AW_DeleteAlertMessage.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/20.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_DeleteAlertMessage.h"
#import "AW_Constants.h"
#import "DeliveryAlertView.h"
#import "UIImage+IMB.h"

@interface AW_DeleteAlertMessage()
/**
 *  @author cao, 15-09-20 15:09:06
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer * topLayer;
/**
 *  @author cao, 15-09-20 15:09:17
 *
 *  中分割线
 */
@property(nonatomic,strong)CAShapeLayer * middleLayer;
/**
 *  @author cao, 15-09-20 15:09:25
 *
 *  下分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottonLayer;
/**
 *  @author cao, 15-09-20 16:09:58
 *
 *  确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
/**
 *  @author cao, 15-09-20 16:09:06
 *
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@end

@implementation AW_DeleteAlertMessage

#pragma mark - Separator Menthod
-(CAShapeLayer*)topLayer{
    if (!_topLayer) {
        _topLayer = [[CAShapeLayer alloc]init];
        CGFloat  lineHeight = 3.0f/([UIScreen mainScreen].scale);
        _topLayer.frame = Rect(0, 51, 272, lineHeight);
        _topLayer.backgroundColor = HexRGB(0x87CEFA).CGColor;
    }
    return _topLayer;
}

-(CAShapeLayer*)bottonLayer{
    if (!_bottonLayer) {
        _bottonLayer = [[CAShapeLayer alloc]init];
        CGFloat  lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _bottonLayer.frame = Rect(0, 92, 272 , lineHeight);
        _bottonLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottonLayer;
}

-(CAShapeLayer*)middleLayer{
    if (!_middleLayer) {
        _middleLayer = [[CAShapeLayer alloc]init];
        CGFloat  lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _middleLayer.frame = Rect(272/2, 92, lineWidth, 38);
        _middleLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middleLayer;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 3.5f;
    self.clipsToBounds = YES;
    [self.layer addSublayer:self.topLayer];
    [self.layer addSublayer:self.middleLayer];
    [self.layer addSublayer:self.bottonLayer];
    
    UIImage * selectImage = [UIImage imageWithColor:HexRGB(0x87CEFA)];
    selectImage = ResizableImageDataForMode(selectImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.confirmBtn setBackgroundImage:selectImage forState:UIControlStateHighlighted];
    [self.cancleBtn setBackgroundImage:selectImage forState:UIControlStateHighlighted];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    DeliveryAlertView * alertView = (DeliveryAlertView*)self.superview;
    [alertView hideWithoutAnimation];
    UIButton * btn = sender;
    _btnTag = btn.tag;
    if (_didClickedBtn) {
        _didClickedBtn(_btnTag);
    }
}

@end
