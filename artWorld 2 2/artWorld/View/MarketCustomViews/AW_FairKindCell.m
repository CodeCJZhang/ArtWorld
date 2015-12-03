//
//  AW_FairKindCell.m
//  artWorld
//
//  Created by 张亚哲 on 15/7/10.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import "AW_FairKindCell.h"

@implementation AW_FairKindCell

- (void)awakeFromNib {
    [self.kingBtn addTarget:self action:@selector(kingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.kingImageView.layer.cornerRadius = 25;
    self.kingImageView.clipsToBounds = YES;
}

- (void)kingBtnClick {
    if(_selectKindBtn){
        _selectKindBtn(_index);
    }
}

@end
