//
//  AW_PaymentSucessHeadView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_PaymentSucessHeadView.h"
#import "AW_Constants.h"

@interface AW_PaymentSucessHeadView()
/**
 *  @author cao, 15-09-12 17:09:30
 *
 *  用于添加分割线的视图
 */
@property (weak, nonatomic) IBOutlet UIView *separateView;
/**
 *  @author cao, 15-09-12 17:09:54
 *
 *  分割线
 */
@property(nonatomic,strong)CAShapeLayer * separate;

@end

@implementation AW_PaymentSucessHeadView

-(CAShapeLayer*)separate{
    if (!_separate) {
        _separate = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _separate.frame = Rect(0, 0, kSCREEN_WIDTH, lineHeight);
        _separate.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _separate;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.separateView.layer addSublayer:self.separate];
    UIImage * btnImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    btnImage = ResizableImageDataForMode(btnImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.connactBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)connectSellerBtnClicked:(id)sender {
    if (_didClickedConectBtn) {
        _didClickedConectBtn(_storeString);
    }
}

@end
