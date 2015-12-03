//
//  AW_CreateIdeaDetailCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_CreateIdeaDetailCell.h"
#import "AW_Constants.h"

@interface AW_CreateIdeaDetailCell()

/**
 *  @author cao, 15-12-03 16:12:02
 *
 *  底部分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;
@end


@implementation AW_CreateIdeaDetailCell

-(void)addBottomLayerWithHeight:(float)height{
    self.bottomLayer = [[CAShapeLayer alloc]init];
    self.bottomLayer = [[CAShapeLayer alloc]init];
    CGFloat lineHeifht = 1.0f/([UIScreen mainScreen].scale);
    self.bottomLayer.frame = Rect(0, height, kSCREEN_WIDTH, lineHeifht);
    self.bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    [self.layer addSublayer:self.bottomLayer];
}

#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
