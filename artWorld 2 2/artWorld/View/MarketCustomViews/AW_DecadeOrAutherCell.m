//
//  AW_DecadeOrAutherCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/15.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_DecadeOrAutherCell.h"
#import "AW_Constants.h"

@interface AW_DecadeOrAutherCell()

/**
 *  @author cao, 15-10-29 09:10:43
 *
 *  底部分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;

@end

@implementation AW_DecadeOrAutherCell

-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _bottomLayer.frame = Rect(0 , 41, kSCREEN_WIDTH,lineHeight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.layer addSublayer:self.bottomLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
