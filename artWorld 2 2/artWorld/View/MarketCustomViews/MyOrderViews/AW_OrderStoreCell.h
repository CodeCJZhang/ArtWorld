//
//  AW_OrderStoreCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_OrderStoreCell : UITableViewCell

/**
 *  @author cao, 15-11-04 16:11:39
 *
 *  商店名称
 */
@property (weak, nonatomic) IBOutlet UILabel *articleStoreName;
/**
 *  @author cao, 15-11-04 16:11:50
 *
 *  vip图像
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
/**
 *  @author cao, 15-11-04 16:11:02
 *
 *  订单状态label
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

@end
