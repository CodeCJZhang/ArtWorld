//
//  AW_MyPreferenceCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/2.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyPreferenceCell.h"

@interface AW_MyPreferenceCell()
/**
 *  @author cao, 15-09-06 16:09:54
 *
 *  cell是否为选中状态，cell上的button的选中状态同cell的选中状态一致
 */
@property(nonatomic)BOOL BtnIsSelect;

@end
@implementation AW_MyPreferenceCell


#pragma mark - Paivate Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.selectBtn setImage:[UIImage imageNamed:@"注册--兴趣选择-选择"] forState:UIControlStateNormal];
    self.selectBtn.hidden = YES;
}

@end
