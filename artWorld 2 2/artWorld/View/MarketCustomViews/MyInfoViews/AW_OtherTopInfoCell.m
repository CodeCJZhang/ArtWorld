//
//  AW_OtherTopInfoCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_OtherTopInfoCell.h"
#import "AW_Constants.h"

@interface AW_OtherTopInfoCell()
/**
 *  @author cao, 15-08-21 14:08:35
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer* topLarer;

@end

@implementation AW_OtherTopInfoCell

-(CAShapeLayer*)topLarer{
    if (!_topLarer) {
        _topLarer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _topLarer.frame = CGRectMake(0, 124, [[UIScreen mainScreen]bounds].size.width, lineHeight);
        _topLarer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _topLarer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.layer addSublayer:self.topLarer];
    self.headContainerView.backgroundColor = HexRGB(0x88c244);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
