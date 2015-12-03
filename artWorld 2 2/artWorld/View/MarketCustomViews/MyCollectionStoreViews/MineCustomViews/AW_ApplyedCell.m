//
//  AW_ApplyedCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/21.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ApplyedCell.h"
#import "AW_Constants.h"

@interface AW_ApplyedCell()

/**
 *  @author cao, 15-10-21 21:10:57
 *
 *  用于添加分割线的视图
 */
@property (weak, nonatomic) IBOutlet UIView *tmpView;
/**
 *  @author cao, 15-10-21 21:10:12
 *
 *  中间的分割线
 */
@property(nonatomic,strong)CAShapeLayer * middleLayer;

@end

@implementation AW_ApplyedCell

-(CAShapeLayer*)middleLayer{
    if (!_middleLayer) {
        _middleLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _middleLayer.frame = Rect(0, 1, kSCREEN_WIDTH, lineHeight);
        _middleLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middleLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tmpView.layer addSublayer:self.middleLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ButtonClicked Menthod
- (IBAction)CertificationButtonClicked:(id)sender{
    if (_didClickedcertificationBtn) {
        _didClickedcertificationBtn();
    }
}

- (IBAction)applyOpenShopBtnClicked:(id)sender {
    if (_didClickedOpenShopBtn) {
        _didClickedOpenShopBtn();
    }
}

@end
