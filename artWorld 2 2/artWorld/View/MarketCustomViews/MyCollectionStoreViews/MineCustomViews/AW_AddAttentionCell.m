//
//  AW_AddAttentionCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_AddAttentionCell.h"
#import "AW_Constants.h"

@interface AW_AddAttentionCell()
/**
 *  @author cao, 15-09-15 10:09:21
 *
 *  上部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-09-15 10:09:29
 *
 *  分割线
 */
@property(nonatomic,strong)CAShapeLayer * separator;
@end


@implementation AW_AddAttentionCell

-(CAShapeLayer *)separator{
    if (!_separator) {
        _separator = [[CAShapeLayer alloc]init];
        CGFloat lineHeifht = 1.0f/([UIScreen mainScreen].scale);
        _separator.frame = Rect(0, 41, kSCREEN_WIDTH, lineHeifht);
        _separator.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _separator;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.topView.layer addSublayer:self.separator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - ButtonClick Menthod
- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didclickButton) {
        _didclickButton(_index);
    }
}


@end
