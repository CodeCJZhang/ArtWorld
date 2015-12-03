//
//  AW_SearchResultDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/28.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import "IMB_RefreshLoadDataProtocol.h"
#import "IMB_Macro.h"//宏定义类
#import "AW_ProduceCollectionCell.h" //cell类
#import "AW_MarketModal.h"

/**
 *  @author cao, 15-10-23 14:10:10
 *
 *  搜索数据源
 */
@interface AW_SearchResultDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,IMB_RefreshLoadDataProtocol>

/**
 *  @author cao, 15-10-23 10:10:40
 *
 *  用来计算高度的cell
 */
@property (nonatomic,strong)AW_ProduceCollectionCell *SizeCell;
/**
 *  @author cao, 15-10-28 17:10:51
 *
 *  用来接传过来的小分类id
 */
@property(nonatomic,copy)NSString * class_id;
/**
 *  @author cao, 15-11-13 15:11:10
 *
 *  标签字符串
 */
@property(nonatomic,copy)NSString * labelString;
/**
 *  @author cao, 15-10-28 17:10:33
 *
 *  用来接传过来的搜索关键字
 */
@property(nonatomic,copy)NSString * keyString;
/**
 *  @author cao, 15-10-28 20:10:17
 *
 *  搜索省份或城市名称
 */
@property(nonatomic,copy)NSString * locationName;
/**
 *  @author cao, 15-10-28 20:10:49
 *
 *  智能排序类别
 */
@property(nonatomic,copy)NSString * sortString;
/**
 *  @author cao, 15-10-28 20:10:59
 *
 *  用户id
 */
@property(nonatomic,copy)NSString * user_id;

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
 *  @author cao, 15-10-29 14:10:52
 *
 *  点击艺术品cell的回调
 */
@property(nonatomic,copy)void(^didClickCell)(AW_MarketModal * modal);
/**
 *  @author cao, 15-10-29 14:10:13
 *
 *  艺术品modal
 */
@property(nonatomic,strong) AW_MarketModal* modal;
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
 *  初始化
 *
 *  @param didSelectObjectBlock 选中对象块
 *
 *  @return 数据源对象
 */
- (id)initWithDidSelectObjectBlock:(DidSelectObjectBlock)didSelectObjectBlock;
/**
 *  @author cao, 15-10-28 21:10:36
 *
 *  获取数据
 */
-(void)getTestData;
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
