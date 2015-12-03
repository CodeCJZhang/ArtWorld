//
//  AW_ConfirmOrderStoreCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ConfirmOrderStoreCell : UITableViewCell
/**
 *  @author cao, 15-09-11 19:09:42
 *
 *  商铺名称
 */
@property (weak, nonatomic) IBOutlet UILabel *storeName;
/**
 *  @author cao, 15-09-12 14:09:30
 *
 *  vip图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
@end
