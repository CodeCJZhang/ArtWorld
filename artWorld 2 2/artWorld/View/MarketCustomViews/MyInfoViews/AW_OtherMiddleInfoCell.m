//
//  AW_OtherMiddleInfoCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_OtherMiddleInfoCell.h"
#import "AW_Constants.h"

@interface AW_OtherMiddleInfoCell()
/**
 *  @author cao, 15-08-21 14:08:35
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer* topLarer;
/**
 *  @author cao, 15-08-21 14:08:44
 *
 *  中分割线
 */
@property(nonatomic,strong)CAShapeLayer* middleLayer;
/**
 *  @author cao, 15-08-21 18:08:13
 *
 *  中二分割线
 */
@property(nonatomic,strong)CAShapeLayer* middle2Layer;
/**
 *  @author cao, 15-08-21 15:08:14
 *
 *  下分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;

@end

@implementation AW_OtherMiddleInfoCell

#pragma mark - separator Menthod
-(CAShapeLayer*)topLarer{
    if (!_topLarer) {
        _topLarer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _topLarer.frame = CGRectMake(0, 44, [[UIScreen mainScreen]bounds].size.width, lineHeight);
        _topLarer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _topLarer;
}
-(CAShapeLayer*)middleLayer{
    if (!_middleLayer) {
        _middleLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _middleLayer.frame = CGRectMake(0, 88, [[UIScreen mainScreen]bounds].size.width, lineHeight);
        _middleLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middleLayer;
}
-(CAShapeLayer*)middle2Layer{
    if (!_middle2Layer) {
        _middle2Layer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _middle2Layer.frame = CGRectMake(0, 132, [[UIScreen mainScreen]bounds].size.width, lineHeight);
        _middle2Layer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middle2Layer;
}

-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _bottomLayer.frame = CGRectMake(0, 176, [[UIScreen mainScreen]bounds].size.width, lineHeight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}

#pragma mark - lifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.layer addSublayer:self.topLarer];
    [self.layer addSublayer:self.middleLayer];
    [self.layer addSublayer:self.middle2Layer];
    [self.layer addSublayer:self.bottomLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
