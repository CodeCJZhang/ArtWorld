//
//  AW_PopView.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/25.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_PopView.h"
#import "AW_Constants.h"

@interface AW_PopView()
/**
 *  @author cao, 15-10-25 11:10:32
 *
 *  中间分割线
 */
@property(nonatomic,strong)CAShapeLayer * middleLayer;

@end
@implementation AW_PopView

-(CAShapeLayer*)middleLayer{
    if (!_middleLayer) {
        _middleLayer = [[CAShapeLayer alloc]init];
        CGFloat  lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _middleLayer.frame = Rect(0, 35, self.bounds.size.width, lineHeight);
        _middleLayer.backgroundColor = HexRGB(0xffffff).CGColor;
    }
    return _middleLayer;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.layer addSublayer:self.middleLayer];
}

- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClickedButton) {
        _didClickedButton(_index);
    }
}

@end
