//
//  AW_MineOtherCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MineOtherCell.h"
#import "AW_Constants.h"

@interface AW_MineOtherCell()
/**
 *  @author cao, 15-09-13 14:09:21
 *
 *  上部分割线
 */
@property(nonatomic,strong) CAShapeLayer* topSeparator;
/**
 *  @author cao, 15-09-13 14:09:38
 *
 *  中分割线
 */
@property(nonatomic,strong) CAShapeLayer * middleSeparator;
/**
 *  @author cao, 15-10-21 18:10:57
 *
 *  下1分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottom1Separator;
/**
 *  @author cao, 15-10-21 18:10:01
 *
 *  下2分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottom2Separator;

@end

@implementation AW_MineOtherCell

#pragma mark - Separator Menthod
-(CAShapeLayer *)topSeparator{
    if (!_topSeparator) {
        _topSeparator = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _topSeparator.frame = Rect(0, self.topView.bounds.size.height - 1, kSCREEN_WIDTH, lineHeight);
        _topSeparator.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _topSeparator;
}

-(CAShapeLayer*)middleSeparator{
    if (!_middleSeparator) {
        _middleSeparator = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _middleSeparator.frame = Rect(0, self.middleView.bounds.size.height - 1, kSCREEN_WIDTH, lineHeight);
        _middleSeparator.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middleSeparator;
}

#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.topView.layer addSublayer:self.topSeparator];
    [self.middleView.layer addSublayer:self.middleSeparator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ButtonClick Menthod

- (IBAction)didClickMenthdo:(id)sender{
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClickKindBtn) {
        _didClickKindBtn(_index);
    }
    
}
@end
