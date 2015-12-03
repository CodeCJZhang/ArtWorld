//
//  AW_CollectionViewHeadView.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_CollectionViewHeadView.h"
#import "AW_Constants.h"

@implementation AW_CollectionViewHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = HexRGB(0xf6f7f8);
}


- (IBAction)topImageBtnClicked:(id)sender {
    if (_didClickedTopBtn) {
        _didClickedTopBtn(_index);
    }
}

@end
