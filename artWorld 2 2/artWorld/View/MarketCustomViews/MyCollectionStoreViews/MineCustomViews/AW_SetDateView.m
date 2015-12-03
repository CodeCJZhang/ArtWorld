//
//  AW_SetDateView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/26.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SetDateView.h"
#import "AW_Constants.h"
#import "DeliveryAlertView.h"
#import "UIImage+IMB.h"

@interface AW_SetDateView()
/**
 *  @author cao, 15-09-26 14:09:14
 *
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/**
 *  @author cao, 15-09-26 14:09:20
 *
 *  确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
/**
 *  @author cao, 15-09-26 13:09:50
 *
 *  上部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-09-26 13:09:57
 *
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 *  @author cao, 15-09-26 13:09:54
 *
 *  日期选择器
 */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
/**
 *  @author cao, 15-09-26 13:09:09
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer * topLayer;
/**
 *  @author cao, 15-09-26 13:09:27
 *
 *  下分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;
/**
 *  @author cao, 15-09-27 09:09:50
 *
 *  中1分割线
 */
@property(nonatomic,strong)CAShapeLayer * middle1Layer;
/**
 *  @author cao, 15-09-27 09:09:00
 *
 *  中2分割线
 */
@property(nonatomic,strong)CAShapeLayer* middle2Layer;
/**
 *  @author cao, 15-09-26 13:09:43
 *
 *  垂直分割线
 */
@property(nonatomic,strong)CAShapeLayer * verticalLayer;

@end

@implementation AW_SetDateView

#pragma mark - Separator Menthod
-(CAShapeLayer*)topLayer{
    if (!_topLayer) {
        _topLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 3.0/([UIScreen mainScreen].scale);
        _topLayer.frame = Rect(0, 57, 280, lineHeight);
        _topLayer.backgroundColor = HexRGB(0x87CEFA).CGColor;
    }
    return _topLayer;
}
-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _bottomLayer.frame = Rect(0,300 - 40 , 280, lineHeight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}

-(CAShapeLayer*)middle1Layer{
    if (!_middle1Layer) {
        _middle1Layer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 2.0f/([UIScreen mainScreen].scale);
        _middle1Layer.frame = Rect(0, 132, 280, lineHeight);
        _middle1Layer.backgroundColor = HexRGB(0x87CEFA).CGColor;
    }
    return _middle1Layer;
}
-(CAShapeLayer*)middle2Layer{
    if (!_middle2Layer) {
        _middle2Layer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 2.0f/([UIScreen mainScreen].scale);
        _middle2Layer.frame = Rect(0, 167, 280, lineHeight);
        _middle2Layer.backgroundColor = HexRGB(0x87CEFA).CGColor;
    }
    return _middle2Layer;
}
-(CAShapeLayer*)verticalLayer{
    if (!_verticalLayer) {
        _verticalLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _verticalLayer.frame = Rect(280/2,260, lineWidth,40);
        _verticalLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _verticalLayer;
}

#pragma mark - Private Menthod
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 3.0f;
    self.clipsToBounds = YES;
    UIImage * selectImage = [UIImage imageWithColor:HexRGB(0x87CEFA)];
    selectImage = ResizableImageDataForMode(selectImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.confirmBtn setBackgroundImage:selectImage forState:UIControlStateHighlighted];
    [self.cancleBtn setBackgroundImage:selectImage forState:UIControlStateHighlighted];
    [self.topView.layer addSublayer:self.topLayer];
    [self.layer addSublayer:self.bottomLayer];
    [self.layer addSublayer:self.verticalLayer];
    [self.layer addSublayer:self.middle1Layer];
    [self.layer addSublayer:self.middle2Layer];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    //不写这句话,在iphone6上会显示英文的月份
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.backgroundColor = [UIColor whiteColor];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    _buttonTag = btn.tag;
    if (_didClickedBtn) {
        _didClickedBtn(_buttonTag,_dateString);
    }
    DeliveryAlertView * alertView = (DeliveryAlertView*)self.superview;
    [alertView hideWithoutAnimation];
}

- (IBAction)dateVallueChanged:(id)sender {
    UIDatePicker * datePicker = sender;
    NSDate * date = datePicker.date;
    NSDateFormatter * formattor = [[NSDateFormatter alloc]init];
    formattor.dateFormat = @"yyyy-MM-dd";
    NSLog(@"%@",[formattor stringFromDate:date]);
    _dateString = date;
}

@end
