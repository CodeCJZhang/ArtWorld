//
//  AW_SimilaryProduceDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/9.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMB_RefreshLoadDataProtocol.h"
#import "MJRefresh.h"
#import "IMB_Macro.h"

/**
 *  @author cao, 15-10-09 18:10:51
 *
 *  相似产品数据源
 */
@interface AW_SimilaryProduceDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,IMB_RefreshLoadDataProtocol>

/**
 *  @author cao, 15-10-21 11:10:00
 *
 *  按钮的索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-10-21 11:10:53
 *
 *  点击弹出视图（进入注册界面）按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger index);
/**
 *  数据集合
 */
@property (nonatomic,strong) NSMutableArray *dataArr;

/**
 *  已选中某个对象回调
 */
@property (nonatomic,copy) DidSelectObjectBlock didSelectObjectBlock;
/**
 *  @author cao, 15-10-30 18:10:12
 *
 *  用来接上个界面传过来的相似艺术品id
 */
@property(nonatomic,copy)NSString * similaryArt_id;
/**
 *  @author cao, 15-10-31 09:10:54
 *
 *  点击艺术品的回调
 */
@property(nonatomic,copy)void(^didClickCell)(NSString * art_id);
/**
 *  @author cao, 15-10-31 09:10:51
 *
 *  传到艺术品详情界面的id;
 */
@property(nonatomic,copy)NSString * commidity_id;
/**
 *  关联的列表
 */
@property (nonatomic,assign) UICollectionView *collectionView;

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
