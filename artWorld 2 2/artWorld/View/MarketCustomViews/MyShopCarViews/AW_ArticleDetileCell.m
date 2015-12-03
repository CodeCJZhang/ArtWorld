//
//  AW_ArticleDetileCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/19.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ArticleDetileCell.h"
#import "AW_Constants.h"

@interface AW_ArticleDetileCell()
/**
 *  @author cao, 15-09-20 11:09:34
 *
 *  下分割线
 */
@property(nonatomic,strong)CAShapeLayer *bottomShape;
/**
 *  @author cao, 15-09-20 11:09:41
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer * topShape;

@end
@implementation AW_ArticleDetileCell

#pragma mark - Separate Menthod
-(CAShapeLayer *)bottomShape{
   if (!_bottomShape) {
      _bottomShape = [[CAShapeLayer alloc]init];
      CGFloat lineHeight = (1.0f / [UIScreen mainScreen].scale);
       _bottomShape.frame = CGRectMake(0, self.bounds.size.height - lineHeight, kSCREEN_WIDTH, lineHeight);
      _bottomShape.backgroundColor = HexRGB(0xe6e6e6).CGColor;
   }
    return _bottomShape;
}

-(CAShapeLayer *)topShape{
    if (!_topShape) {
        _topShape = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = (1.0f / [UIScreen mainScreen].scale);
        _topShape.frame = CGRectMake(0, lineHeight, kSCREEN_WIDTH, lineHeight);
        _topShape.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _topShape;
}
#pragma mark - config Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - AddSeparator Menthod
-(void)hasButtomSeparate:(BOOL)isShow{
    if (isShow) {
        [self.layer addSublayer:self.bottomShape];
    }else{
        [self.bottomShape removeFromSuperlayer];
    }
}

-(void)hasTopSeparate:(BOOL)isShow{
    if (isShow) {
        [self.layer addSublayer:self.topShape];
    }else{
        [self.topShape removeFromSuperlayer];
    }
}

@end
