//
//  AW_ConfirmOrderArticleCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ConfirmOrderArticleCell.h"

@implementation AW_ConfirmOrderArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.articleCurrentPrice.textColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
