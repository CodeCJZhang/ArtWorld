//
//  AW_MineQuestionCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MineQuestionCell.h"
#import "AW_Constants.h"

@interface AW_MineQuestionCell()
/**
 *  @author cao, 15-09-13 14:09:51
 *
 *  上部视图
 */
@property (weak, nonatomic) IBOutlet UIButton *topView;
/**
 *  @author cao, 15-09-13 14:09:01
 *
 *  中部视图
 */
@property (weak, nonatomic) IBOutlet UIButton *middleView;
/**
 *  @author cao, 15-09-13 14:09:21
 *
 *  上部分割线
 */
@property(nonatomic,strong) CAShapeLayer* topSeparator;
/**
 *  @author cao, 15-09-13 14:09:38
 *
 *  下部分割线
 */
@property(nonatomic,strong) CAShapeLayer * middleSeparator;
@end

@implementation AW_MineQuestionCell

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
   
}

#pragma mark - ButtonClick Menthod
- (IBAction)buttonClickMenthod:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClickKindBtn) {
        _didClickKindBtn(_index);
    }
}

@end
