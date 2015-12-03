//
//  AW_DetailOtherCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_DetailOtherCell.h"
#import "AW_Constants.h"

@interface AW_DetailOtherCell()<UITextFieldDelegate>
/**
 *  @author cao, 15-10-23 21:10:34
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer * topLayer;
/**
 *  @author cao, 15-10-23 21:10:46
 *
 *  中1分割线
 */
@property(nonatomic,strong)CAShapeLayer * middleLayer;
/**
 *  @author cao, 15-10-23 21:10:48
 *
 *  中2分割线
 */
@property(nonatomic,strong)CAShapeLayer * middleTwoLayer;
/**
 *  @author cao, 15-10-23 21:10:52
 *
 *  底部分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;

@end

@implementation AW_DetailOtherCell

#pragma mark - Separator Menthod
/*-(CAShapeLayer*)topLayer{
    if (!_topLayer) {
        _topLayer = [[CAShapeLayer alloc]init];
        CGFloat lineheight = 1.0f/([UIScreen mainScreen].scale);
        _topLayer.frame = Rect(0 , 0, kSCREEN_WIDTH,lineheight);
        _topLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _topLayer;
}*/

-(CAShapeLayer*)middleLayer{
    if (!_middleLayer) {
        _middleLayer = [[CAShapeLayer alloc]init];
        CGFloat lineheight = 1.0f/([UIScreen mainScreen].scale);
        _middleLayer.frame = Rect(0 , 42, kSCREEN_WIDTH,lineheight);
        _middleLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middleLayer;
}

-(CAShapeLayer*)middleTwoLayer{
    if (!_middleTwoLayer) {
        _middleTwoLayer = [[CAShapeLayer alloc]init];
        CGFloat lineheight = 1.0f/([UIScreen mainScreen].scale);
        _middleTwoLayer.frame = Rect(0 ,84, kSCREEN_WIDTH,lineheight);
        _middleTwoLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middleTwoLayer;
}

#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
   // [self.layer addSublayer:self.topLayer];
    [self.layer addSublayer:self.middleLayer];
    [self.layer addSublayer:self.middleTwoLayer];
   // [self.layer addSublayer:self.bottomLayer];
    self.numTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    UIButton* btn = sender;
    _index = btn.tag;
    if (_didClick) {
        _didClick(_index);
    }
}

#pragma mark - TextFieldDelegate Menthod
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _numString = textField.text;
    if (_endEdite) {
        _endEdite(_numString);
    }
}

@end
