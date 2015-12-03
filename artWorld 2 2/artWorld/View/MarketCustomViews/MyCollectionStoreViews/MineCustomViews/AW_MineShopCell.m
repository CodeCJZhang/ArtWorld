//
//  AW_MineShopCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MineShopCell.h"

@implementation AW_MineShopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)mineStoreBtn:(id)sender {
    if (_didClickStoreBtn) {
        _didClickStoreBtn(_index);
    }
}

@end
