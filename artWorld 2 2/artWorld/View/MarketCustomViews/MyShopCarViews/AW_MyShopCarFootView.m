//
//  AW_MyShopCarFootView.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyShopCarFootView.h"
#import "AW_Constants.h"

@implementation AW_MyShopCarFootView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.totalPrice.textColor = [UIColor orangeColor];
    self.backgroundColor = HexRGB(0xf6f7f8);
    [self.selectBtn setBackgroundImage:[[UIImage imageNamed:@"未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:[[UIImage imageNamed:@"选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.payMentBtn setBackgroundImage:[[UIImage imageNamed:@"结算"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.payMentBtn setBackgroundImage:[[UIImage imageNamed:@"结算"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    self.payMentBtn.highlighted = NO;
}

- (IBAction)allSelectBtnClicked:(id)sender {
    if (_didClickSelectBtn) {
        _didClickSelectBtn(_index);
    }
}
@end
