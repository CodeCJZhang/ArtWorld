//
//  AW_MycollectionHeadView.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MycollectionHeadView.h"
#import "AW_Constants.h"

@interface AW_MycollectionHeadView ()
/**
 *  @author cao, 15-08-26 17:08:00
 *
 *  左侧视图，用来设置分割线
 */
@property (weak, nonatomic) IBOutlet UIView *leftView;
/**
 *  @author cao, 15-08-26 17:08:21
 *
 *  中间的分割线
 */
@property(nonatomic,strong)CAShapeLayer * middleLayer;

@end

@implementation AW_MycollectionHeadView

-(CAShapeLayer*)middleLayer{
    if (!_middleLayer) {
        _middleLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _middleLayer.frame = CGRectMake(kSCREEN_WIDTH/2 ,5, lineWidth, 28);
        _middleLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middleLayer;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.leftView.layer addSublayer:self.middleLayer];
}


@end
