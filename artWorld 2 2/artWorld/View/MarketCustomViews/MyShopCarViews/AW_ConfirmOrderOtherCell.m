//
//  AW_ConfirmOrderOtherCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ConfirmOrderOtherCell.h"
#import "AW_Constants.h"

@interface AW_ConfirmOrderOtherCell()<UITextViewDelegate>
/**
 *  @author cao, 15-09-12 09:09:55
 *
 *  顶部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-09-12 09:09:09
 *
 *  中部视图
 */
@property (weak, nonatomic) IBOutlet UIView *middleView;
/**
 *  @author cao, 15-09-12 09:09:18
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer * topSeparator;
/**
 *  @author cao, 15-09-12 09:09:35
 *
 *  中分割线
 */
@property(nonatomic,strong)CAShapeLayer * middleSeparator;
/**
 *  @author cao, 15-09-12 09:09:45
 *
 *  下分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomSeparator;

@end

@implementation AW_ConfirmOrderOtherCell

#pragma mark - Separator Menthod
-(CAShapeLayer*)topSeparator{
    if (!_topSeparator) {
        _topSeparator = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _topSeparator.frame = CGRectMake(0,0, kSCREEN_WIDTH, lineHeight);
        _topSeparator.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _topSeparator;
}

-(CAShapeLayer*)middleSeparator{
    if (!_middleSeparator) {
        _middleSeparator = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _middleSeparator.frame = CGRectMake(0,44, kSCREEN_WIDTH, lineHeight);
        _middleSeparator.backgroundColor = HexRGB(0xe6e6e6).CGColor;

    }
    return _middleSeparator;
}

-(CAShapeLayer*)bottomSeparator{
    if (!_bottomSeparator) {
        _bottomSeparator = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _bottomSeparator.frame = CGRectMake(0,88, kSCREEN_WIDTH, lineHeight);
        _bottomSeparator.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomSeparator;
}

#pragma mark - Private Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.layer addSublayer:self.topSeparator];
    [self.layer addSublayer:self.middleSeparator];
    [self.layer addSublayer:self.bottomSeparator];
    self.leaveMessage.placeholder = @"给卖家留言";
    self.leaveMessage.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ButtonClick Menthod
- (IBAction)useCouponBtnClicked:(id)sender {
    if (_didClickUseCouponBtn) {
        _didClickUseCouponBtn(_index);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    _Message = self.leaveMessage.text;
    if (_didEndEdite) {
        _didEndEdite(_Message);
    }
}

@end
