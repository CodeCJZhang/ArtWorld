//
//  CJLocationSelectCell.h
//  artWorld
//
//  Created by 张晓旭 on 15/9/18.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJLocationSelectCell : UITableViewCell

//地点
@property (weak, nonatomic) IBOutlet UILabel *place;

//区域
@property (weak, nonatomic) IBOutlet UILabel *area;

//右侧选中图片
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@end
