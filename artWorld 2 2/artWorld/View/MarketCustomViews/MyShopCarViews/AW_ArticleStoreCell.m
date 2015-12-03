//
//  AW_ArticleStoreCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ArticleStoreCell.h"

@implementation AW_ArticleStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.storeSelectBtn setImage:[[UIImage imageNamed:@"未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.storeSelectBtn setImage:[[UIImage imageNamed:@"选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
    [self.storeEditeBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.storeEditeBtn setTitle:@"完成" forState:UIControlStateSelected];
    [self.storeEditeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
        // Configure the view for the selected state
}

- (IBAction)selectMenthod:(id)sender {
    if (_didClickSelectBtn) {
        _didClickSelectBtn(_index);
    }
}

- (IBAction)editeMenthod:(id)sender {
    
    self.storeEditeBtn.selected = !self.storeEditeBtn.selected;
    
    if (_didClickEditeBtn) {
        _didClickEditeBtn(_index);
    }
}

@end
