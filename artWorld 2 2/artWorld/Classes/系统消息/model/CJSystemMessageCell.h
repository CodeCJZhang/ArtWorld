//
//  CJSystemMessageModl.h
//  artWorld
//
//  Created by 张晓旭 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJSystemMessageCell : UITableViewCell

//消息时间
@property (weak, nonatomic) IBOutlet UIButton *time;

//消息主题
@property (weak, nonatomic) IBOutlet UILabel *item;

//消息描述
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end
