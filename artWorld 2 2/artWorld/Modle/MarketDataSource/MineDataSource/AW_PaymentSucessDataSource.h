//
//  AW_PaymentSucessDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMB_RefreshLoadDataProtocol.h"
#import "MJRefresh.h"
#import "IMB_Macro.h"
#import "AW_DeliveryAdressModal.h"
#import "AW_MarketModal.h"
#import "AW_MyShopCartModal.h"

@interface AW_PaymentSucessDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,IMB_RefreshLoadDataProtocol>
/**
 *  @author cao, 15-09-12 18:09:50
 *
 *  获取数据
 */
-(void)getTestData;
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
 *  @author cao, 15-11-11 15:11:54
 *
 *  点击艺术品cell的回调
 */
@property(nonatomic,copy)void(^didClickedCell)(AW_MarketModal *modal);
/**
 *  @author cao, 15-11-11 15:11:05
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_MarketModal * modal;
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
 *  @author cao, 15-09-21 16:09:36
 *
 *  点击店铺cell的回调
 */
@property(nonatomic,copy)void(^didClickedStoreCell)(AW_MyShopCartModal * storeModal);
/**
 *  @author cao, 15-09-21 16:09:40
 *
 *  用于接上个界面传过来的收货地址modal
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * currentAdressModal;
/**
 *  @author cao, 15-09-21 16:09:09
 *
 *  用于接上个界面传过来的艺术品总价格
 */
@property(nonatomic,copy)NSString* totalPrice;
/**
 *  @author cao, 15-09-21 16:09:32
 *
 *  用于接上个界面传过来的邮费价格
 */
@property(nonatomic,copy)NSString* postagePrice;
/**
 *  @author cao, 15-11-24 14:11:05
 *
 *  用来接上个界面传过来的店铺modal
 */
@property(nonatomic,strong)NSMutableArray * storeModalArray;

@end
