//
//  AW_MyShopCarCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/24.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyShopCarCell.h"
#import "AW_Constants.h"

@interface AW_MyShopCarCell()

@end

@implementation AW_MyShopCarCell

#pragma mark - Private Menthod

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addButton.backgroundColor = HexRGB(0xf6f7f8);
    self.reduceButton.backgroundColor = HexRGB(0xf6f7f8);
    self.editeArticleNum.backgroundColor = HexRGB(0xf6f7f8);
    self.articlePrice.textColor = [UIColor orangeColor];
    [self.articleSelectBtn setImage:[[UIImage imageNamed:@"未选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.articleSelectBtn setImage:[[UIImage imageNamed:@"选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    self.articleSelectBtn.backgroundColor = [UIColor clearColor];
    
    UIImage * btnImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    btnImage = ResizableImageDataForMode(btnImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.similaryBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 [self.articleSelectBtn setImage:[[UIImage imageNamed:@"选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
}

#pragma mark - LifeCycle Menthod

//点击左侧选择按钮的方法
- (IBAction)selcetBtnClicked:(id)sender {
    self.articleSelectBtn.selected = !self.articleSelectBtn.selected;
    if (_didClickSelectBtn) {
        _didClickSelectBtn(_index);
    }
}

//点击增加商品数量
- (IBAction)addBtnClicked:(id)sender {
    NSLog(@"%@",_didClickAddBtn);
    if (_didClickAddBtn) {
        _didClickAddBtn(_index);
    }
}

//点击减少商品数量
- (IBAction)reduceBtnClicked:(id)sender {
    if (_didClickReduceBtn) {
        _didClickReduceBtn(_index);
    }
}

//点击删除按钮的方法
- (IBAction)deleteBtnClicked:(id)sender {
    NSLog(@"%@",_didClickDeleteButton);
    if (_didClickDeleteButton) {
        _didClickDeleteButton(_index);
    }
}

//点击下拉按钮的方法
- (IBAction)editePullBtnClicked:(id)sender {
    if (_didClickPullBtn) {
        _didClickPullBtn(_index);
    }
}

//点击展示详情按钮展示tableview
- (IBAction)displayDetailBtnClicked:(id)sender {
    if (_didClickDisplayDetailBtn) {
        _didClickDisplayDetailBtn(_index);
    }
}

//点击找相似按钮
- (IBAction)similaryBtnClicked:(id)sender {
    if (_didClickedSimilaryBtn) {
        _didClickedSimilaryBtn(_articleKind);
    }
}

@end
