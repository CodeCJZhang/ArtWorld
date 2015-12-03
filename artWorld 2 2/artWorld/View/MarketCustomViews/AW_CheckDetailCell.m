//
//  AW_CheckDetailCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_CheckDetailCell.h"
#import "AW_Constants.h"

@interface AW_CheckDetailCell()

@end

@implementation AW_CheckDetailCell

#pragma mark - Separator Menthod
-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeifht = 1.0f/([UIScreen mainScreen].scale);
        _bottomLayer.frame = Rect(0, 41, kSCREEN_WIDTH, lineHeifht);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}

#pragma mark - LifeCycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.layer addSublayer:self.bottomLayer];
    
    [self.expendImage setBackgroundImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
    [self.expendImage setBackgroundImage:[UIImage imageNamed:@"up_gray"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - ButtonClicked Menthod

- (IBAction)disPlayDetailBtn:(id)sender {
    if (_didClickBtn) {
        _didClickBtn();
    }
}


@end
