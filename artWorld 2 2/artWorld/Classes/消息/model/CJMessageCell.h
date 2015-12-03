//
//  CJMessageCell.h
//  artWorld
//
//  Created by 张晓旭 on 15/11/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJMessageCell : UITableViewCell


/**##############⬇️ 商城消息 ⬇️###############*/
//图片
@property (weak, nonatomic) IBOutlet UIImageView *m_image;

//数量提示
@property (weak, nonatomic) IBOutlet UIButton *m_hintBtn;

//消息类别
@property (weak, nonatomic) IBOutlet UILabel *m_items;

//最后一条消息
@property (weak, nonatomic) IBOutlet UILabel *lastMessage;


/**##############⬇️ 圈子消息 ⬇️###############*/
//图片
@property (weak, nonatomic) IBOutlet UIImageView *g_Image;

//数量提示
@property (weak, nonatomic) IBOutlet UIButton *g_HintBtn;

//消息类别
@property (weak, nonatomic) IBOutlet UILabel *g_Items;

@end
