//
//  AW_ClassContainerView.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ClassContainerView.h"

@implementation AW_ClassContainerView


#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    if (_didClickedButton) {
        _didClickedButton();
    }
}

@end
