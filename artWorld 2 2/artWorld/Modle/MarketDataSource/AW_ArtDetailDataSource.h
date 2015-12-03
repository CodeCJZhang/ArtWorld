//
//  AW_ArtDetailDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_CommodityModal.h"

/**
 *  @author cao, 15-10-23 14:10:39
 *
 *  艺术品详情数据源
 */
@interface AW_ArtDetailDataSource : IMB_TableDataSource

/**
 *  @author cao, 15-10-25 16:10:09
 *
 *  点击轮播视图的回调
 */
@property(nonatomic,copy)void(^didClickedIcarousel)(NSInteger index,NSArray * imageArray);
/**
 *  @author cao, 15-10-25 13:10:12
 *
 *  点击头部视图按钮的回调
 */
@property(nonatomic,copy)void(^didClickedHeadCellBtn)(NSInteger index);
/**
 *  @author cao, 15-10-25 13:10:36
 *
 *  点击颜色按钮的回调
 */
@property(nonatomic,copy)void(^didClickedColorButton)(AW_CommodityModal * artModal);
/**
 *  @author cao, 15-10-25 15:10:55
 *
 *  点击商铺cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickedStoreCell)(NSInteger index);
/**
 *  @author cao, 15-10-25 15:10:01
 *
 *  点击相似艺术品的回调
 */
@property(nonatomic,copy)void(^didClickedSimilaryBtn)(NSString * artId);
/**
 *  @author cao, 15-10-29 14:10:57
 *
 *  相似艺术品id
 */
@property(nonatomic,copy)NSString * similaryArt_id;
/**
 *  @author cao, 15-10-25 14:10:23
 *
 *  商品数量小于1时的回调
 */
@property(nonatomic,copy)void(^didClicked)();
/**
 *  @author cao, 15-11-30 15:11:50
 *
 *  商品数量大于库存的回调
 */
@property(nonatomic,copy)void(^numgreaterThanStore)();
/**
 *  @author cao, 15-10-28 17:10:44
 *
 *  用来接上个界面传过来的艺术品id
 */
@property(nonatomic,copy)NSString * commidity_id;
/**
 *  @author cao, 15-10-29 16:10:19
 *
 *  商铺名称
 */
@property(nonatomic,copy)NSString * shop_id;
/**
 *  @author cao, 15-10-29 16:10:57
 *
 *  商品数量
 */
@property(nonatomic,copy)NSString * commidity_account;
/**
 *  @author cao, 15-10-31 11:10:50
 *
 *  用来接上个界面传过来的是否收藏了该商品
 */
@property(nonatomic)BOOL isCollection;
/**
 *  @author cao, 15-10-25 17:10:46
 *
 *  滚动结束后的回调
 */
@property(nonatomic,copy)void(^didEndScroll)(CGFloat beforeY,CGFloat afterY);
/**
 *  @author cao, 15-10-25 14:10:41
 *
 *  艺术品颜色
 */
@property(nonatomic,copy)NSString * artColor;
/**
 *  @author cao, 15-10-31 10:10:53
 *
 *  颜色数组
 */
@property(nonatomic,strong)AW_CommodityModal * commidity_Color_modal;
/**
 *  @author cao, 15-10-25 17:10:15
 *
 *  滚动前的Y值
 */
@property(nonatomic)CGFloat beforeY;
/**
 *  @author cao, 15-10-25 17:10:18
 *
 *  滚动后的Y值
 */
@property(nonatomic)CGFloat afterY;
/**
 *  @author cao, 15-10-24 14:10:18
 *
 *  获取数据
 */
-(void)getData;
/**
 *  @author cao, 15-11-09 14:11:26
 *
 *  被查看用户的id
 */
@property(nonatomic,copy)NSString * personId;
/**
 *  @author cao, 15-11-12 11:11:05
 *
 *  被查看用户的开店状态
 */
@property(nonatomic,copy)NSString * shop_state;
/**
 *  @author cao, 15-11-16 16:11:43
 *
 *  店主的环信id
 */
@property(nonatomic,copy)NSString * shoper_IM_id;
//艺术品描述
@property(nonatomic,copy)NSString * commidity_describe;
//将要分享的图片记录下来
@property(nonatomic,copy)NSString * share_image;
@end
