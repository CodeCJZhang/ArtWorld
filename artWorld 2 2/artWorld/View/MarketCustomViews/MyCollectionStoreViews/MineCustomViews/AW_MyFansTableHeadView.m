//
//  AW_MyFansTableHeadView.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/20.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyFansTableHeadView.h"
#import "IMB_Macro.h"

@interface AW_MyFansTableHeadView()

@property(nonatomic,strong)CAShapeLayer * buttomLayer;
@end


@implementation AW_MyFansTableHeadView

-(CAShapeLayer*)buttomLayer{
    if (!_buttomLayer) {
        _buttomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/[UIScreen mainScreen].scale;
        _buttomLayer.frame = CGRectMake(0, 40, kSCREEN_WIDTH, lineHeight);
        _buttomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _buttomLayer;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.layer addSublayer:self.buttomLayer];
}
@end
