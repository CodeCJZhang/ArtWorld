//
//  AW_DetailBottomView.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/24.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_DetailBottomView.h"
#import "AW_Constants.h"

@interface AW_DetailBottomView()
/**
 *  @author cao, 15-10-24 16:10:56
 *
 *  中间分割线
 */
@property(nonatomic,strong)CAShapeLayer * middleLayer;

@end

@implementation AW_DetailBottomView

-(CAShapeLayer*)middleLayer{
    if (!_middleLayer) {
        _middleLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _middleLayer.frame = Rect(kSCREEN_WIDTH/4 ,0, lineWidth,self.bounds.size.height);
        _middleLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middleLayer;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.layer addSublayer:self.middleLayer];
}

#pragma mark - buttonClicked Menthod
- (IBAction)buttonClickedMenthod:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClickedBtn) {
        _didClickedBtn(_index);
    }
}

@end
