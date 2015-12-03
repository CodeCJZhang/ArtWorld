//
//  AW_MinetopCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MinetopCell.h"
#import "AW_Constants.h"

@interface AW_MinetopCell()
/**
 *  @author cao, 15-09-13 12:09:59
 *
 *  作品视图
 */
@property (weak, nonatomic) IBOutlet UIView *profuceView;
/**
 *  @author cao, 15-09-13 12:09:14
 *
 *  动态视图
 */
@property (weak, nonatomic) IBOutlet UIView *dynamicView;
/**
 *  @author cao, 15-09-13 12:09:22
 *
 *  关注视图
 */
@property (weak, nonatomic) IBOutlet UIView *attentionView;
/**
 *  @author cao, 15-09-13 12:09:30
 *
 *  粉丝视图
 */
@property (weak, nonatomic) IBOutlet UIView *fansView;
/**
 *  @author cao, 15-09-13 12:09:53
 *
 *  左侧分割线
 */
@property(nonatomic,strong)CAShapeLayer * leftSeparator;
/**
 *  @author cao, 15-09-13 12:09:05
 *
 *  中间分割线
 */
@property(nonatomic,strong)CAShapeLayer * middleSeparator;
/**
 *  @author cao, 15-09-13 12:09:15
 *
 *  右侧分割线
 */
@property(nonatomic,strong)CAShapeLayer * rightSeparator;
/**
 *  @author cao, 15-09-13 15:09:06
 *
 *  用来改变颜色
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-10-22 14:10:54
 *
 *  左侧视图
 */
@property (weak, nonatomic) IBOutlet UIView *leftView;
/**
 *  @author cao, 15-10-22 14:10:10
 *
 *  中间视图
 */
@property (weak, nonatomic) IBOutlet UIView *middleView;
/**
 *  @author cao, 15-10-22 14:10:22
 *
 *  右侧视图
 */
@property (weak, nonatomic) IBOutlet UIView *rightView;
/**
 *  @author cao, 15-10-22 14:10:26
 *
 *  左分割线
 */
@property(nonatomic,strong)CAShapeLayer * leftLayer;
/**
 *  @author cao, 15-10-22 14:10:29
 *
 *  右分割线
 */
@property(nonatomic,strong)CAShapeLayer * rightLayer;
/**
 *  @author cao, 15-11-14 15:11:16
 *
 *  分割线视图
 */
@property (weak, nonatomic) IBOutlet UIView *separatorView;
/**
 *  @author cao, 15-11-14 15:11:06
 *
 *  分割线视图
 */
@property (weak, nonatomic) IBOutlet UIView *separatorOneView;

@end

@implementation AW_MinetopCell

#pragma mark - Separator Menthod
-(CAShapeLayer *)leftLayer{
    if (!_leftLayer) {
        _leftLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _leftLayer.frame = Rect(kSCREEN_WIDTH/3 - 1, 90, lineWidth, 30);
        _leftLayer.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _leftLayer;
}

-(CAShapeLayer *)rightLayer{
    if (!_rightLayer) {
        _rightLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _rightLayer.frame = Rect((kSCREEN_WIDTH/3 *2) - 1, 90, lineWidth, 30);
        _rightLayer.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _rightLayer;
}

-(CAShapeLayer *)leftSeparator{
    if (!_leftSeparator) {
        _leftSeparator = [[CAShapeLayer alloc]init];
       CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _leftSeparator.frame = Rect(kSCREEN_WIDTH/4 - 1, 90, lineWidth, 30);
        _leftSeparator.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _leftSeparator;
}

-(CAShapeLayer*)middleSeparator{
    if (!_middleSeparator) {
        _middleSeparator = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _middleSeparator.frame = Rect(kSCREEN_WIDTH/2 - 1, 90, lineWidth, 30);
        _middleSeparator.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _middleSeparator;
}

-(CAShapeLayer *)rightSeparator{
    if (!_rightSeparator) {
        _rightSeparator = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _rightSeparator.frame = Rect((kSCREEN_WIDTH/4*3) - 1, 90, lineWidth, 30);
        _rightSeparator.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _rightSeparator;
}

#pragma  mark -  LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
     self.topView.backgroundColor = HexRGB(0x88c244);
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.height/2;
    self.headImageView.clipsToBounds = YES;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImageView.layer.borderWidth = 2.0f;
    
}

-(void)configSeparatorWith:(AW_UserModal*)modal{
    if ([modal.shop_state intValue] == 3) {
        [self.layer addSublayer:self.leftSeparator];
        [self.layer addSublayer:self.middleSeparator];
        [self.layer addSublayer:self.rightSeparator];
    }else{
        [self.layer addSublayer:self.leftLayer];
        [self.layer addSublayer:self.rightLayer];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClickKindBtn) {
        _didClickKindBtn(_index);
    }
}

- (IBAction)buttonWithoutProduceClicked:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClicjedBtns) {
        _didClicjedBtns(_index);
    }
    
}

@end
