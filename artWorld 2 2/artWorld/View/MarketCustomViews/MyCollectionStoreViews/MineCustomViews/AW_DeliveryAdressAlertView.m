//
//  AW_DeliveryAdressAlertView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/2.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_DeliveryAdressAlertView.h"
#import "AW_Constants.h"
#import "DeliveryAlertView.h"

@interface AW_DeliveryAdressAlertView()

@end

@implementation AW_DeliveryAdressAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.confirmBtn setTitleColor:HexRGB(0x88c244) forState:UIControlStateNormal];
    self.backgroundColor = HexRGB(0xf2f2f2);
    self.deliveryName.backgroundColor = HexRGB(0xFFFFFF);
    //设置边框颜色和圆角
    UIImage * tmpImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    tmpImage = ResizableImageDataForMode(tmpImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.deliveryAdress setBackground:tmpImage];
    [self.deliveryName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.deliveryName setBackground:tmpImage];
    [self.deliveryPhoneNumber setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.deliveryPhoneNumber setBackground:tmpImage];
    [self.deliveryAdress setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmBtn setBackgroundImage:tmpImage forState:UIControlStateNormal];
    self.confirmBtn.clipsToBounds = YES;
}

-(AW_DeliveryAdressModal*)adressModal{
    if (!_adressModal) {
        _adressModal = [[AW_DeliveryAdressModal alloc]init];
    }
    return _adressModal;
}

#pragma mark - ButtonClick  Menthod
- (IBAction)buttonClicked:(id)sender {
        self.adressModal.deliveryName = self.deliveryName.text;
        self.adressModal.deliveryPhoneNumber = self.deliveryPhoneNumber.text;
        self.adressModal.deliveryAdress = self.deliveryAdress.text;
    if (self.deliveryPhoneNumber.text.length > 0 && self.deliveryName.text.length >0 && self.deliveryAdress.text.length > 0 && [self isAvailableTelephone] == YES) {
        DeliveryAlertView * alert = (DeliveryAlertView*)[self superview];
        [alert hide];
    }
    if (_didClickConfirmBtn) {
        _didClickConfirmBtn(_adressModal);
    }
}

//验证手机号格式是否正确
- (BOOL)isAvailableTelephone{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    return  [regextestmobile evaluateWithObject:self.deliveryPhoneNumber.text]   ||
    [regextestphs evaluateWithObject:self.deliveryPhoneNumber.text]      ||
    [regextestct evaluateWithObject:self.deliveryPhoneNumber.text]       ||
    [regextestcu evaluateWithObject:self.deliveryPhoneNumber.text]       ||
    [regextestcm evaluateWithObject:self.deliveryPhoneNumber.text];
}

@end
