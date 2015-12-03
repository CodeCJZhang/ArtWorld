//
//  AW_ArtStoreCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ArtStoreCell.h"
#import "AW_Constants.h"

@interface AW_ArtStoreCell()
/**
 *  @author cao, 15-10-23 17:10:54
 *
 *  左侧分割线
 */
@property(nonatomic,strong)CAShapeLayer * leftLayer;
/**
 *  @author cao, 15-10-23 17:10:57
 *
 *  右侧分割线
 */
@property(nonatomic,strong)CAShapeLayer * rightLayer;

@end

@implementation AW_ArtStoreCell

#pragma mark - Separator Menthod
-(CAShapeLayer*)leftLayer{
    if (!_leftLayer) {
        _leftLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _leftLayer.frame = Rect(kSCREEN_WIDTH/3, 89, lineWidth, 41-16);
        _leftLayer.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _leftLayer;
}

-(CAShapeLayer*)rightLayer{
    if (!_rightLayer) {
        _rightLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _rightLayer.frame = Rect((kSCREEN_WIDTH/3)*2, 89, lineWidth, 41-16);
        _rightLayer.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _rightLayer;
}

#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.layer addSublayer:self.leftLayer];
    [self.layer addSublayer:self.rightLayer];
    UIImage * image = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    image = ResizableImageDataForMode(image, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.connectBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.baguetteBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self removeConstraint:self.toRightLength];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClickedButtons) {
        _didClickedButtons(_index);
    }
}

@end
