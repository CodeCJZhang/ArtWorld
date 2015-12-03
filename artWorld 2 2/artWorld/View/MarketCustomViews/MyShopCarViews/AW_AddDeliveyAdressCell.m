//
//  AW_AddDeliveyAdressCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/1.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_AddDeliveyAdressCell.h"

@interface AW_AddDeliveyAdressCell()

/**
 *  @author cao, 15-09-01 17:09:37
 *
 *  容器视图
 */
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation AW_AddDeliveyAdressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //设置白色背景和圆角
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 6.0f;
    self.containerView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //Configure the view for the selected state
}

@end
