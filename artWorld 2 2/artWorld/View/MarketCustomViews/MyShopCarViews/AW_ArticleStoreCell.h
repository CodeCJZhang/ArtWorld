//
//  AW_ArticleStoreCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ArticleStoreCell : UITableViewCell

/**
 *  @author cao, 15-08-25 14:08:11
 *
 *  商店左侧选择按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *storeSelectBtn;
/**
 *  @author cao, 15-08-25 14:08:29
 *
 *  商店名称
 */
@property (weak, nonatomic) IBOutlet UILabel *storeName;
/**
 *  @author cao, 15-08-25 14:08:50
 *
 *  编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *storeEditeBtn;
/**
 *  @author cao, 15-08-25 14:08:18
 *
 *  vip头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击左侧选择按钮回调
 */
@property (nonatomic,copy)void (^didClickSelectBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击右侧编辑按钮回调
 */
@property (nonatomic,copy)void (^didClickEditeBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-07 20:09:03
 *
 *  店铺索引
 */
@property(nonatomic)NSInteger index;

@end
