//
//  AW_MycollectionStoreCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MycollectionStoreCell : UITableViewCell
/**
 *  @author cao, 15-10-15 16:10:38
 *
 *  店主的头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *head_Image;

/**
 *  @author cao, 15-08-27 15:08:47
 *
 *  商铺名称
 */
@property (weak, nonatomic) IBOutlet UILabel *storeName;
/**
 *  @author cao, 15-08-27 15:08:57
 *
 *  vip头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
/**
 *  @author cao, 15-08-27 15:08:04
 *
 *  聊天按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *talkBtn;
/**
 *  @author cao, 15-08-27 15:08:16
 *
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *adress;
/**
 *  @author cao, 15-08-27 15:08:22
 *
 *  作品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *produceNum;
/**
 *  @author cao, 15-08-27 15:08:31
 *
 *  动态数量
 */
@property (weak, nonatomic) IBOutlet UILabel *dynamicNum;
/**
 *  @author cao, 15-08-27 15:08:48
 *
 *  关注数量
 */
@property (weak, nonatomic) IBOutlet UILabel *attentionNum;
/**
 *  @author cao, 15-08-27 15:08:02
 *
 *  粉丝数量
 */
@property (weak, nonatomic) IBOutlet UILabel *fansNum;

/**
 *  @author cao, 15-08-27 15:08:09
 *
 *  取消收藏按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/**
 *  @author cao, 15-09-14 10:09:40
 *
 *  作品按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *profuceBtn;
/**
 *  @author cao, 15-09-14 10:09:51
 *
 *  动态按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *dynamicBtn;
/**
 *  @author cao, 15-09-14 10:09:59
 *
 *  关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
/**
 *  @author cao, 15-09-14 10:09:08
 *
 *  粉丝按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;
/**
 *  @author cao, 15-09-14 10:09:40
 *
 *  点击cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickCellBtn)(NSInteger btnIndex);
/**
 *  @author cao, 15-09-14 10:09:40
 *
 *  点击cell上的聊天和取消收藏后的回调按钮的回调
 */
@property(nonatomic,copy)void(^didClickTalkAndCancleBtn)(NSInteger btnIndex ,NSInteger storeId);
/**
 *  @author cao, 15-09-14 10:09:56
 *
 *  按钮索引
 */
@property(nonatomic)NSInteger btnIndex;
/**
 *  @author cao, 15-09-14 11:09:29
 *
 *  商铺id
 */
@property(nonatomic)NSInteger storeId;
/**
 *  @author cao, 15-11-28 14:11:17
 *
 *  商铺名称label长度
 *
 *  @param shopName 商铺名称
 *
 *  @return label长度
 */
-(float)heightForStoreName:(NSString*)shopName;
/**
 *  @author cao, 15-11-28 14:11:08
 *
 *  到聊天按钮的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstant;
/**
 *  @author cao, 15-12-02 23:12:31
 *
 *  地址图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *adressImage;

@end
