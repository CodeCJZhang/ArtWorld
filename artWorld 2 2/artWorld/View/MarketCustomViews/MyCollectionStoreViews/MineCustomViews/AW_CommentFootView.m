//
//  AW_CommentFootView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_CommentFootView.h"

@interface AW_CommentFootView()


@end

@implementation AW_CommentFootView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)commentBtnClicked:(id)sender {
    
}
- (IBAction)selectBtnClicked:(id)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
}

@end
