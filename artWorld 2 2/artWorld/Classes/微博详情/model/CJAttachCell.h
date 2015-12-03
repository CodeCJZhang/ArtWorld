//
//  CJAttachCell.h
//  artWorld
//
//  Created by 张晓旭 on 15/11/7.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJAttachCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *name;

//VIP
@property (weak, nonatomic) IBOutlet UIImageView *vip;

//时间
@property (weak, nonatomic) IBOutlet UILabel *time;

//看法、观点
@property (weak, nonatomic) IBOutlet UILabel *opinion;

//行高
@property (nonatomic,assign) CGFloat cellHeight;

@end
