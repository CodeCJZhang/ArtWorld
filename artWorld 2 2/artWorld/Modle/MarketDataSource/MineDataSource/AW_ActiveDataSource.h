//
//  AW_ActiveDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/18.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMB_RefreshLoadDataProtocol.h"
#import "MJRefresh.h"
#import "IMB_Macro.h"
#import "AW_SimilaryCommodityModal.h"
/**
 *  @author cao, 15-09-18 15:09:10
 *
 *  活动数据源
 */
@interface AW_ActiveDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,IMB_RefreshLoadDataProtocol>
/**
 *  @author cao, 15-10-19 18:10:02
 *
 *  获取数据
 */
-(void)getTestData;
/**
 *  @author cao, 15-11-11 14:11:41
 *
 *  相似艺术品modal
 */
@property(nonatomic,strong)AW_SimilaryCommodityModal * modal;
/**
 *  @author cao, 15-11-11 14:11:39
 *
 *  点击艺术品cell的回调
 */
@property(nonatomic,copy)void(^didClickedIterm)(AW_SimilaryCommodityModal *modal);
/**
 *  @author cao, 15-10-19 17:10:21
 *
 *  活动图片url
 */
@property(nonatomic,copy)NSString * activeImageURL;
/**
 *  @author cao, 15-11-11 11:11:05
 *
 *  活动图片模糊URL
 */
@property(nonatomic,copy)NSString * activeFuzzyURL;
/**
 *  @author cao, 15-11-11 11:11:18
 *
 *  活动id
 */
@property(nonatomic,copy)NSString * active_id;
/**
 *  @author cao, 15-10-19 17:10:08
 *
 *  活动名称
 */
@property(nonatomic,copy)NSString * activeName;
/**
 *  数据集合
 */
@property (nonatomic,strong) NSMutableArray *dataArr;

/**
 *  已选中某个对象回调
 */
@property (nonatomic,copy) DidSelectObjectBlock didSelectObjectBlock;

/**
 *  关联的列表
 */
@property (nonatomic,assign) UICollectionView *collectionView;
/**
 *  @author cao, 15-10-21 13:10:22
 *
 *  点击弹出视图按钮的回调（跳转到登陆界面）
 */
@property(nonatomic,copy)void(^didclickedBtn)(NSInteger index);
/**
 *  @author cao, 15-10-21 13:10:24
 *
 *  按钮索引
 */
@property(nonatomic)NSInteger index;
/**
 *  初始化
 *
 *  @param didSelectObjectBlock 选中对象块
 *
 *  @return 数据源对象
 */
- (id)initWithDidSelectObjectBlock:(DidSelectObjectBlock)didSelectObjectBlock;

/**
 *  刷新数据
 */
- (void)refreshData;

/**
 *  获取下一页数据
 */
- (void)nextPageData;

/**
 *  释放资源
 */
- (void)releaseResources;

/**
 *
 *  预处理计算cell高度
 */
- (void)pretreatWithHeight;


@end
