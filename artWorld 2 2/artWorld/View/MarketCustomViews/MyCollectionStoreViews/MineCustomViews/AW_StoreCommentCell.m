//
//  AW_StoreCommentCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_StoreCommentCell.h"

@implementation AW_StoreCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //为描述按钮设置背景色
    [self.describeButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * btn = obj;
        btn.highlighted = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"星星-灰"] forState:UIControlStateNormal];
         [btn setBackgroundImage:[UIImage imageNamed:@"星星-黄"] forState:UIControlStateSelected];
        if (idx  == 0) {
            btn.selected = YES;
        }
    }];
    //为物流按钮设置背景色
    [self.deliveryButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * btn = obj;
        btn.highlighted = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"星星-灰"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"星星-黄"] forState:UIControlStateSelected];
        if (idx == 0) {
            btn.selected = YES;
        }
    }];
    //为服务按钮设置背景色
    [self.seviercesButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * btn = obj;
        btn.highlighted = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"星星-灰"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"星星-黄"] forState:UIControlStateSelected];
        if (idx == 0) {
            btn.selected = YES;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - ButtonClick Menthod
- (IBAction)describeBtnStarClicked:(id)sender {
    UIButton * btn = sender;
    _describeBtnTag = btn.tag;
    NSLog(@"描述类型的按钮标签=====%ld====",btn.tag);
    if (_didClickDescribeBtn) {
        _didClickDescribeBtn(_describeBtnTag);
    }
}

- (IBAction)deliveryBtnClicked:(id)sender {
    UIButton * btn = sender;
    _deliveryBtnTag = btn.tag;
     NSLog(@"物流类型的按钮标签=====%ld====",btn.tag);
    if (_didClickDeliveryBtn) {
        _didClickDeliveryBtn(_deliveryBtnTag);
    }
}

- (IBAction)serviceBtnClicked:(id)sender {
    UIButton * btn = sender;
    _seriviceBtnTag = btn.tag;
     NSLog(@"服务态度类型的按钮标签=====%ld====",btn.tag);
    if (_didClickSericeBtn) {
        _didClickSericeBtn(_seriviceBtnTag);
    }}

@end
