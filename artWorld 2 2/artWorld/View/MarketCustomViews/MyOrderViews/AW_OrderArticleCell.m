//
//  AW_OrderArticleCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_OrderArticleCell.h"
#import "AW_Constants.h"

@implementation AW_OrderArticleCell

#pragma mark  - AwakeFromNib Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    self.articlePrice.textColor = [UIColor orangeColor];
    self.colorContainerView.backgroundColor = HexRGB(0xf6f7f8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
