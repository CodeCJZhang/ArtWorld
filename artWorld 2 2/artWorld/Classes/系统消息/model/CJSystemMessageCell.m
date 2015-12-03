//
//  CJSystemMessageModl.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJSystemMessageCell.h"

@interface CJSystemMessageCell ()

//内容底
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation CJSystemMessageCell

- (void)awakeFromNib {
    _time.layer.cornerRadius = 4.0;
    _bottomView.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
