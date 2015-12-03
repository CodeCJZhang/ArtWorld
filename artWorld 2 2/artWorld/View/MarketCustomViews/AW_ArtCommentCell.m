//
//  AW_ArtCommentCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/29.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ArtCommentCell.h"

@interface AW_ArtCommentCell()
/**
 *  @author cao, 15-11-21 14:11:23
 *
 *  星级容器视图
 */
@property (weak, nonatomic) IBOutlet UIView *starview;

@end

@implementation AW_ArtCommentCell

-(CWStarRateView*)starRateView{
    if (!_starRateView) {
        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 11, 100, 18) numberOfStars:5];
        _starRateView.allowIncompleteStar = YES;
        _starRateView.hasAnimation = NO;
        _starRateView.scorePercent = 0;
    }
    return _starRateView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.head_img.layer.cornerRadius = 22;
    self.head_img.clipsToBounds = YES;
    [self.starview addSubview:self.starRateView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)floatForStarViewWith:(NSString *)str{
    CGFloat starFloat = [str floatValue]/5.0;
    self.starRateView.scorePercent = starFloat;
}

@end
