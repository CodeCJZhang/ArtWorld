//
//  AW_ArtStoreCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author cao, 15-10-23 16:10:43
 *
 *  商铺cell
 */
@interface AW_ArtStoreCell : UITableViewCell
/**
 *  @author cao, 15-11-28 11:11:34
 *
 *  vip头像到屏幕右侧的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toRightLength;

/**
 *  @author cao, 15-10-23 17:10:06
 *
 *  商铺图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *storeImage;
/**
 *  @author cao, 15-10-23 17:10:31
 *
 *  商店名称
 */
@property (weak, nonatomic) IBOutlet UILabel *storeName;
/**
 *  @author cao, 15-10-23 17:10:33
 *
 *  vip图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
/**
 *  @author cao, 15-10-23 17:10:36
 *
 *  商店地址
 */
@property (weak, nonatomic) IBOutlet UILabel *storeAdress;
/**
 *  @author cao, 15-10-23 17:10:38
 *
 *  作品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *produceNum;
/**
 *  @author cao, 15-10-23 17:10:42
 *
 *  粉丝数量
 */
@property (weak, nonatomic) IBOutlet UILabel *fansNum;
/**
 *  @author cao, 15-10-23 17:10:46
 *
 *  动态数量
 */
@property (weak, nonatomic) IBOutlet UILabel *dynamicNum;
/**
 *  @author cao, 15-10-23 17:10:49
 *
 *  联系卖家按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
/**
 *  @author cao, 15-10-23 17:10:53
 *
 *  进入店铺按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *baguetteBtn;
/**
 *  @author cao, 15-10-23 17:10:45
 *
 *  点击按钮的回调
 */
@property(nonatomic,copy)void(^didClickedButtons)(NSInteger index);
/**
 *  @author cao, 15-10-23 17:10:56
 *
 *  按钮索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-12-02 15:12:43
 *
 *  位置图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *adressImage;

@end
