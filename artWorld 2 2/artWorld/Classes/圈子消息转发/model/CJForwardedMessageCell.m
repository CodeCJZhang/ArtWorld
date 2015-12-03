//
//  CJForwardedMessageCell.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJForwardedMessageCell.h"

@interface CJForwardedMessageCell ()

//原微博底视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation CJForwardedMessageCell

- (void)awakeFromNib {
    _bottomView.layer.cornerRadius = 3.0;
}



@end
