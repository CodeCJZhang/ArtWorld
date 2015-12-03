//
//  AW_SearchTextView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SearchTextView.h"
#import "AW_Constants.h"

@implementation AW_SearchTextView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.searchStringText becomeFirstResponder];
    UIImage * searchBackgroungImage = [UIImage imageNamed:@"搜索内框"];
    searchBackgroungImage = ResizableImageDataForMode(searchBackgroungImage, 1, 15, 1, 15, UIImageResizingModeStretch);
    self.backImage.image = searchBackgroungImage;
}

#pragma mark - ButtonClicked Menthod
- (IBAction)searchBtnClicked:(id)sender {
    _searchString = self.searchStringText.text;
    if (_didClickSearchBtn) {
        _didClickSearchBtn(_searchString);
    }
}


@end
