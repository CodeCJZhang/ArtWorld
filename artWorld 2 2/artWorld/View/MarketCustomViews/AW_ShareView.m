//
//  AW_ShareView.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/25.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ShareView.h"
#import "AW_Constants.h"

@interface AW_ShareView()

@property(nonatomic,strong)CAShapeLayer * middleLayer;
@end

@implementation AW_ShareView

-(CAShapeLayer*)middleLayer{
    if (!_middleLayer) {
        _middleLayer = [[CAShapeLayer alloc]init];
        CGFloat  lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _middleLayer.frame = Rect(0, self.bounds.size.height - 40, kSCREEN_WIDTH, lineHeight);
        _middleLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middleLayer;
}

-(void)awakeFromNib{
    [super awakeFromNib];
   // [self.layer addSublayer:self.middleLayer];
}

- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClickedBtn) {
        _didClickedBtn(_index);
    }
}

@end
