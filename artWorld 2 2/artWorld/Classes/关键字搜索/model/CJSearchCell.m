//
//  CJSearchCellModel.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJSearchCell.h"
#import "CJMoreArtContentController.h"
#import "CJMoreContactPersonController.h"


@interface CJSearchCell ()

@end

@implementation CJSearchCell

- (void)awakeFromNib
{
    _contactsIcon.layer.cornerRadius = 4;
    _weiboIcon.layer.cornerRadius = 4;
    _s_icon.layer.cornerRadius = 4;
    
    _attentionBtn.layer.cornerRadius = 3;
    _attentionBtn.layer.borderWidth = 1;
    _attentionBtn.layer.borderColor = [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0] CGColor];
}

#pragma mark - IBAction BtnClick

//关注联系人按钮
- (IBAction)attentionBtn:(UIButton *)sender
{
    if ([_attentionBtn.titleLabel.text isEqualToString:@"关注"])
    {
        [_attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
}

//进入更多联系人界面、更多艺圈内容界面
- (IBAction)moreBtnClick:(UIButton *)sender
{
    //进入更多联系人界面
    if ([_cellFootBtn.titleLabel.text isEqualToString:@"更多联系人"])
    {
        NSLog(@"1");
        _toMoreContact();
    }
    else    //进入更多艺圈内容界面
    {
         NSLog(@"2");
        _toMoreContent();
    }
}

@end
