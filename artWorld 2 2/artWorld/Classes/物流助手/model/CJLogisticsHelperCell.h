//
//  CJLogisticsHelperModel.h
//  artWorld
//
//  Created by 张晓旭 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJLogisticsHelperCell : UITableViewCell

//时间
@property (weak, nonatomic) IBOutlet UIButton *time;

//标题
@property (weak, nonatomic) IBOutlet UILabel *title;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *image;

//简要
@property (weak, nonatomic) IBOutlet UILabel *content;


@end
