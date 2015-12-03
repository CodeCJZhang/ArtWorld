//
//  AW_MineShopCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MineShopCell : UITableViewCell
/**
 *  @author cao, 15-09-13 14:09:40
 *
 *  点击我的店按钮后的回调
 */
@property(nonatomic,copy)void(^didClickStoreBtn)(NSInteger index);

@property(nonatomic)NSInteger index;
@end
