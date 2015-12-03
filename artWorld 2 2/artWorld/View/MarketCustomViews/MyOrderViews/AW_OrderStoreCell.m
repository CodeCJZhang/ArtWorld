//
//  AW_OrderStoreCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_OrderStoreCell.h"

@implementation AW_OrderStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderStateLabel.textColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
