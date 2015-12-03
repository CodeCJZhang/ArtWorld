//
//  AW_MineProductionDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMB_RefreshLoadDataProtocol.h"
#import "MJRefresh.h"
#import "IMB_Macro.h"
#import "AW_ArtWorkModal.h"

@interface AW_MineProductionDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,IMB_RefreshLoadDataProtocol>
/**
 *  @author cao, 15-11-11 14:11:08
 *
 *  点击艺术品cell的回调
 */
@property(nonatomic,copy)void(^didClickedCell)(AW_ArtWorkModal* modal);
/**
 *  @author cao, 15-11-11 14:11:33
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_ArtWorkModal * modal;
/**
 *  @author cao, 15-10-19 16:10:34
 *
 *  活动头视图图片
 */
@property(nonatomic,copy)NSString * activeImageURL;
/**
 *  @author cao, 15-11-11 11:11:46
 *
 *  活动模糊视图
 */
@property(nonatomic,copy)NSString * activeFuzzyURL;
/**
 *  @author cao, 15-11-11 11:11:56
 *
 *  活动id
 */
@property(nonatomic,copy)NSString * active_id;
/**
 *  @author cao, 15-11-11 11:11:33
 *
 *  活动名称
 */
@property(nonatomic,copy)NSString * active_name;
/**
 *  @author cao, 15-11-09 17:11:25
 *
 *  将作品数量记录下来
 */
@property(nonatomic,copy)NSString * produce_num;
/**
 *  @author cao, 15-11-09 16:11:19
 *
 *  被查看用户的id
 */
@property(nonatomic,copy)NSString * person_id;
/**
 *  @author cao, 15-10-19 11:10:56
 *
 *  用来存放筛选数据的数组
 */
@property(nonatomic,strong)NSMutableArray * queryArray;
/**
 *  @author cao, 15-10-19 11:10:31
 *
 *  用来记录艺术品的全部数量
 */
@property(nonatomic)NSInteger totalArticleNum;
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
 *  @author cao, 15-09-18 16:09:45
 *
 *  点击顶部headView图片按钮的回调
 */
@property(nonatomic,copy)void(^didClickTopImageBtn)(NSInteger index);
/**
 *  @author cao, 15-10-20 22:10:10
 *
 *  点击确定或取消按钮的回调
 */
@property(nonatomic,copy)void(^didClickedConfirmBtn)(NSInteger index);
/**
 *  @author cao, 15-10-20 22:10:13
 *
 *  按钮的索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-11-12 10:11:53
 *
 *  记录活动信息
 */
@property(nonatomic,strong)NSDictionary * activeDictionary;
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
/**
 *  @author cao, 15-12-01 14:12:14
 *
 *  请求成功后的回调
 */
@property(nonatomic,copy)void(^didRequestSucess)(NSString * str);
/**
 *  @author cao, 15-12-01 15:12:55
 *
 *  作品数量
 */
@property(nonatomic,copy)NSString * str;

@end
