//
//  AW_OrderStateCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_OrderStateCell.h"
#import "AW_Constants.h"

@interface AW_OrderStateCell()
/**
 *  @author cao, 15-08-23 18:08:50
 *
 *  底部分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;
@end

@implementation AW_OrderStateCell

#pragma mark - Separator Menthod
-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _bottomLayer.frame = CGRectMake(0, 30, kSCREEN_WIDTH, lineHeight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}

#pragma mark - AwakeFromNib Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    self.paymentBtn.layer.cornerRadius = 3;
    self.paymentBtn.clipsToBounds = YES;
    self.confirmDeliveryBtn.layer.cornerRadius = 3;
    self.confirmDeliveryBtn.clipsToBounds = YES;
    self.evaluteBtn.layer.cornerRadius = 3;
    self.evaluteBtn.clipsToBounds = YES;
    //添加分割线
    [self.layer addSublayer:self.bottomLayer];
    //设置按钮的背景图片
    UIImage * btnImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    btnImage = ResizableImageDataForMode(btnImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.cancleBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.connectBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.lookDeliveryBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.deleteOrderBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.remindSnedBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - ButtonClicked Menthod
//点击提醒发货按钮的回调
- (IBAction)clickedRemindDeliveryBtn:(id)sender {
    if (_didClickRemindBtn) {
        _didClickRemindBtn();
    }
}

//点击待付款cell上的按钮的回调
- (IBAction)didClickedWaitPayCellButtons:(id)sender {
    UIButton *btn = sender;
    _BtnTag = btn.tag;
    if (_didClickedWaitPayCellBtns) {
        _didClickedWaitPayCellBtns(_BtnTag);
    }
}

//点击待收货cell上的按钮的回调
- (IBAction)didClickedWaitReceiveCellButtons:(id)sender {
    UIButton * btn = sender;
    _BtnTag = btn.tag;
    if (_didClickedWaitReceiveCellBtns) {
        _didClickedWaitReceiveCellBtns(_BtnTag);
    }
}

//点击待评价cell上的按钮的回调
- (IBAction)didClickedWaitEvaluteCellButtons:(id)sender {
    UIButton * btn = sender;
    _BtnTag = btn.tag;
    if (_didClickedWaitEvaluteCellBtns) {
        _didClickedWaitEvaluteCellBtns(_BtnTag);
    }
}

//点击完成评价cell上的按钮的回调
- (IBAction)didClickedFinishEvaluteCellButtons:(id)sender {
    UIButton * btn = sender;
    _BtnTag = btn.tag;
    if (_didClickedOrderSucessCellBtns) {
        _didClickedOrderSucessCellBtns(_BtnTag);
    }
}

//点击交易关闭cell上的按钮的回调
- (IBAction)didclickedFinishOrderCellbuttons:(id)sender {
    if (_didClickedOrderCloseBtn) {
        _didClickedOrderCloseBtn();
    }
}

@end
