//
//  AW_FairCollectionViewDataSource.h
//  artWorld
//
//  Created by 张亚哲 on 15/7/9.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import "IMB_RefreshLoadDataProtocol.h"
#import "IMB_Macro.h"//宏定义类
#import "AW_ProduceCollectionCell.h" //cell类
#import "AW_FairHeaderView.h" //主界面-市集-图片轮播头视图
#import "AW_MarketModal.h"

/**
 *  @author cao, 15-10-23 14:10:10
 *
 *  市集数据源
 */
@interface AW_FairCollectionViewDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,IMB_RefreshLoadDataProtocol>

/**
 *  @author cao, 15-10-23 10:10:40
 *
 *  用来计算高度的cell
 */
@property (nonatomic,strong)AW_ProduceCollectionCell *SizeCell;
/**
 *  @author cao, 15-10-23 10:10:49
 *
 *  点击弹出视图（跳转到登陆界面按钮的回调）
 */
@property(nonatomic,copy)void(^didClickedConfirmBtn)(NSInteger index);
/**
 *  @author cao, 15-10-23 10:10:28
 *
 *  弹出视图的按钮索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-10-27 15:10:55
 *
 *  记录总页数
 */
@property(nonatomic,copy)NSString * totolPage;
/**
 *  @author cao, 15-10-27 15:10:08
 *
 *  当前的页数
 */
@property(nonatomic,copy)NSString * currentPage;
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

// 设置是否需要瀑布流上面的头视图
@property (nonatomic,assign) BOOL whetherNeedHeaderView;

/**
 *  @author cao, 15-10-28 17:10:48
 *
 *  点击轮播视图的回调
 */
@property (nonatomic,copy)void (^didSelectFairView)(NSString * art_id);

/**
 *  @author cao, 15-10-28 17:10:00
 *
 *  点击热门分类的回调
 */
@property (nonatomic,copy)void (^didSelectKind)(NSString * class_id);
/**
 *  @author cao, 15-10-28 17:10:03
 *
 *  点击艺术品按钮的回调
 */
@property(nonatomic,copy)void(^didClickedCell)(AW_MarketModal * modal);
/**
 *  @author cao, 15-10-28 17:10:38
 *
 *  艺术品id
 */
@property(nonatomic,copy)NSString * commidity_id;
/**
 *  @author cao, 15-10-31 12:10:34
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_MarketModal * modal;
/**
 *  @author cao, 15-10-28 17:10:40
 *
 *  艺术品id
 */
@property(nonatomic,strong)NSString * art_URL;
/**
 *  @author cao, 15-10-28 17:10:57
 *
 *  小分类id
 */
@property(nonatomic,strong)NSString * class_id;
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
 *  @author zhe, 15-06-23 09:06:35
 *
 *  预处理计算cell高度
 */
- (void)pretreatWithHeight;

@end
