
//  AW_MyDetailHeadView.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyDetailHeadView.h"
#import "IMB_Macro.h"
#import "AW_PersonalInformationModal.h"

@interface AW_MyDetailHeadView()

/**
 *  @author cao, 15-08-23 10:08:11
 *
 *  上部视图的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
/**
 *  @author cao,15-08-23 10:08:04
 *
 *  展示文本简介的按钮
 */
@property (weak, nonatomic) IBOutlet UIView *displayButton;
/**
 *  @author cao, 15-08-23 13:08:55
 *
 *  整个视图
 */
@property (weak, nonatomic) IBOutlet UIView *containerView;
/**
 *  @author cao, 15-11-10 16:11:13
 *
 *  个人信息modal
 */
@property(nonatomic,strong)AW_PersonalInformationModal * modal;

@end

@implementation AW_MyDetailHeadView

#pragma mark - Private - Menthod

/**
 *  @author cao, 15-08-17 10:08:05
 *
 *  添加分割线
 */
-(void)awakeFromNib{
    [super awakeFromNib];
    self.myImage.layer.cornerRadius = 35.0;
    self.myImage.clipsToBounds = YES;
    self.myDescribe.text = self.modal.synopsis;
    self.topView.backgroundColor = HexRGB(0x88c244);
    self.myImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.myImage.layer.borderWidth = 2.0f;
    
    //设置圆角
    _attentionButtob.layer.cornerRadius = 0.0f;
    _attentionButtob.clipsToBounds = YES;
    _storeButton.layer.cornerRadius = 0.0f;
    _storeButton.clipsToBounds = YES;
    UIImage * btnImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    btnImage = ResizableImageDataForMode(btnImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.storeButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.attentionButtob setBackgroundImage:btnImage forState:UIControlStateNormal];
    //设置关注按钮
    [self.AttentionCover setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.AttentionCover setTitle:@"" forState:UIControlStateNormal];
    [self.AttentionCover setTitle:@"已关注" forState:UIControlStateSelected];
    [self.AttentionCover setBackgroundImage:btnImage forState:UIControlStateSelected];
    //设置店铺收藏按钮
    [self.storeButton setTitle:@"已收藏" forState:UIControlStateSelected];
    [self.storeButton setTitle:@"收藏店铺" forState:UIControlStateNormal];
    [self.storeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.storeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
}

#pragma mark - ButtonClicked Menthod

- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClickedBtn) {
        _didClickedBtn(_index);
    }
}

@end
