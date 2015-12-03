//
//  AW_SelectPhotoView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SelectPhotoView.h"
#import "DeliveryAlertView.h"
#import "AW_Constants.h"
#import "UIImage+IMB.h"

@interface AW_SelectPhotoView()
/**
 *  @author cao, 15-09-27 20:09:18
 *
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/**
 *  @author cao, 15-09-27 20:09:30
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer* topLayer;
/**
 *  @author cao, 15-09-27 20:09:44
 *
 *  下分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;
@end

@implementation AW_SelectPhotoView

#pragma mark - Separator Menthod
-(CAShapeLayer*)topLayer{
    if (!_topLayer) {
        _topLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 3.0/([UIScreen mainScreen].scale);
        _topLayer.frame = CGRectMake(0, 57, 280 , lineHeight);
        _topLayer.backgroundColor = HexRGB(0x87CEFA).CGColor;
    }
    return _topLayer;
}

-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _bottomLayer.frame = CGRectMake(0, 120, 280, lineHeight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.layer addSublayer:self.topLayer];
    [self.layer addSublayer:self.bottomLayer];
    self.layer.cornerRadius = 3.0f;
    self.clipsToBounds = YES;
    UIImage * selectImage = [UIImage imageWithColor:HexRGB(0x87CEFA)];
    selectImage = ResizableImageDataForMode(selectImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.cancleBtn setBackgroundImage:selectImage forState:UIControlStateHighlighted];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)cancleBtnClicked:(id)sender {
    DeliveryAlertView * alertView =  (DeliveryAlertView*)[self superview];
    [alertView hideWithoutAnimation];
}

- (IBAction)selectHeadImage:(id)sender {
    UIButton * btn = sender;
    _buttonTag = btn.tag;
    if (_didClickedCamera) {
        _didClickedCamera(_buttonTag);
    }
    DeliveryAlertView* alertView = (DeliveryAlertView*)[self superview];
    [alertView hideWithoutAnimation];
}

@end
