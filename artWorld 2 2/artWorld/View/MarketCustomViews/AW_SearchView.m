//
//  AW_SearchView.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_SearchView.h"
#import "AW_Constants.h"

@implementation AW_SearchView

-(void)awakeFromNib{
    [super awakeFromNib];
    UIColor * selectColor = HexRGB(0x88c244);
    [self.allBtn setTitleColor:selectColor forState:UIControlStateSelected];
    [self.allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.locationBtn setTitleColor:selectColor forState:UIControlStateSelected];
    [self.locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.IntelligenceBtn setTitleColor:selectColor forState:UIControlStateSelected];
    [self.IntelligenceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark  - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    btn.selected = !btn.selected;
    _index = btn.tag;
    if (_didClickedBtn) {
        _didClickedBtn(_index);
    }
}

@end
