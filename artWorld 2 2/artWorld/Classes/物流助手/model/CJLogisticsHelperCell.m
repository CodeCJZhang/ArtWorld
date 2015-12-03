//
//  CJLogisticsHelperModel.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJLogisticsHelperCell.h"

@interface CJLogisticsHelperCell ()

//内容底视图
@property (weak, nonatomic) IBOutlet UIView *bottomeView;

@end

@implementation CJLogisticsHelperCell

- (void)awakeFromNib {
    _time.layer.cornerRadius = 4.0;
    _bottomeView.layer.cornerRadius = 4.0;
}



@end
