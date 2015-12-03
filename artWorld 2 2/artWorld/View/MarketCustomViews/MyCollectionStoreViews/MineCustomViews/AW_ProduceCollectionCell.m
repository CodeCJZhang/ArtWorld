//
//  AW_ProduceCollectionCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/19.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ProduceCollectionCell.h"

@implementation AW_ProduceCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];    
}

#pragma mark - ButtonClicked Menthod
- (IBAction)storeButtonClicked:(id)sender {
    if (_didClickedStoreBtn) {
        _didClickedStoreBtn(_index);
        NSLog(@"收藏了第几个====%d===",_index);
    }
}

@end
