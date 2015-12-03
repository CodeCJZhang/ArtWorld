//
//  AW_DeliveryAdressCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/1.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_DeliveryAdressCell.h"
#import "AW_Constants.h"

@interface AW_DeliveryAdressCell()
/**
 *  @author cao, 15-09-01 17:09:24
 *
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 *  @author cao, 15-09-01 17:09:34
 *
 *  底部分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;

@end

@implementation AW_DeliveryAdressCell
-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _bottomLayer.frame = Rect(8, self.bounds.size.height - 48, kSCREEN_WIDTH - 16, lineHeight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}


#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.layer addSublayer:self.bottomLayer];
    
    //设置白色背景和圆角
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 6.0f;
    self.containerView.clipsToBounds = YES;
    
    //设置默认收货地址按钮的背景颜色
    [self.defealtImageBtn setBackgroundImage:[[UIImage imageNamed:@"设为默认地址-灰"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.defealtImageBtn setBackgroundImage:[[UIImage imageNamed:@"设为默认地址"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    //self.defealtImageBtn.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - ButtonClick Menthod
- (IBAction)buttonClickMenthod:(id)sender {
    if (_didClickEditeBtn) {
        _didClickEditeBtn(_Index);
    }
}

- (IBAction)defaultAdressBtnClicked:(id)sender {
    if (_didClickDefaultBtn) {
        _didClickDefaultBtn(_Index);
    }
    if (self.defealtImageBtn.selected == NO) {
        self.defealtImageBtn.enabled = NO;
    }
}

- (IBAction)deleteBtnClicked:(id)sender {
    
    if (_didClickDeleteBtn) {
        _didClickDeleteBtn(_Index);
    }
}

-(void)dealloc{
    if (_didClickEditeBtn) {
        _didClickEditeBtn = nil;
    }
}

@end
