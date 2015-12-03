//
//  CJPraiseCell.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJPraiseCell.h"

@interface CJPraiseCell ()

//底视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation CJPraiseCell

- (void)awakeFromNib {
    _bottomView.layer.cornerRadius = 3.0;
}

//底视图点击（界面跳转）
- (IBAction)bottomBtnClick:(UIButton *)sender {
}

@end
