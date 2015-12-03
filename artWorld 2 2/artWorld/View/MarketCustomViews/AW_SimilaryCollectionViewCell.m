//
//  AW_SimilaryCollectionViewCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_SimilaryCollectionViewCell.h"

@implementation AW_SimilaryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - ButtonClicked Menthod
- (IBAction)btnClicked:(id)sender {
    if (_didClickedBtn) {
        _didClickedBtn(_index);
    }
}
@end
