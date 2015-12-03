//
//  AW_MyDetailViewController.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/20.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "TYSlidePageScrollViewController.h"
#import "AW_MineProductionDataSource.h"//作品数据源
#import "AW_MyAttentionDataSource.h"//关注数据源
#import "AW_MyFansDataSource.h"//粉丝数据源
#import "AW_MyDynamicDataSource.h"//我的动态数据源

/**
 *  @author cao, 15-08-20 17:08:13
 *
 *  我的详情界面
 */
@interface AW_MyDetailViewController : TYSlidePageScrollViewController

@property (nonatomic , assign) BOOL isNoHeaderView;

@property(nonatomic,copy) NSString* markNumber;
/**
 *  @author cao, 15-08-13 17:08:45
 *
 *  我的作品数据源
 */
@property(nonatomic,strong)AW_MineProductionDataSource * productionDataSource;
/**
 *  @author cao, 15-08-13 17:08:01
 *
 *  我关注的人数据源
 */
@property(nonatomic,strong)AW_MyAttentionDataSource * attentionDataSource;
/**
 *  @author cao, 15-08-13 17:08:15
 *
 *  我的粉丝数据源
 */
@property(nonatomic,strong)AW_MyFansDataSource * fansDataSource;
/**
 *  @author cao, 15-08-13 17:08:27
 *
 *  我的动态数据源
 */
@property(nonatomic,strong)AW_MyDynamicDataSource * dynamicDataSource;
/**
 *  @author cao, 15-08-20 17:08:06
 *
 *  用来接上个界面传过来的按钮标签
 */
@property(nonatomic)NSInteger PreviousButtonTag;
/**
 *  @author cao, 15-11-12 16:11:25
 *
 *  按钮标签
 */
@property(nonatomic)NSInteger buttonWithoutProduceTag;
/**
 *  @author cao, 15-09-14 11:09:22
 *
 *  我收藏的店铺传过来的标签
 */
@property(nonatomic)NSInteger myCollectionStoreBtnTag;
/**
 *  @author cao, 15-10-25 15:10:32
 *
 *  艺术品商铺按钮标签
 */
@property(nonatomic)NSInteger artStoreBtnTag;
/**
 *  @author cao, 15-11-12 21:11:55
 *
 *  我收藏的店铺按钮标签
 */
@property(nonatomic)NSInteger collectionStoreBtnTag;
/**
 *  @author cao, 15-11-09 14:11:00
 *
 *  被查看的用户的id
 */
@property(nonatomic,copy)NSString * person_id;
/**
 *  @author cao, 15-11-13 11:11:01
 *
 *  店铺id
 */
@property(nonatomic,copy)NSString * shop_id;
/**
 *  @author cao, 15-11-12 11:11:06
 *
 *  被查看用户的开店状态
 */
@property(nonatomic,copy)NSString * shop_state;

@end
