//
//  AW_PreferenceDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/2.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMB_RefreshLoadDataProtocol.h"
#import "MJRefresh.h"
#import "IMB_Macro.h"
#import "AW_MyPreferenceModal.h"//偏好设置模型

@interface AW_PreferenceDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,IMB_RefreshLoadDataProtocol>
/**
 *  @author cao, 15-09-02 17:09:17
 *
 *  数据集合
 */
@property(nonatomic,strong)NSMutableArray * dataArray;
/**
 *  @author cao, 15-09-02 17:09:25
 *
 *  选中某个对象后的回调
 */
@property (nonatomic,copy) DidSelectObjectBlock didSelectObjectBlock;
/**
 *  @author cao, 15-09-02 17:09:49
 *
 *  关联的列表
 */
@property(nonatomic,strong)UICollectionView * collectionView;
/**
 *  @author cao, 15-09-06 11:09:56
 *
 *  选中的cell数组集合
 */
@property(nonatomic,strong)NSMutableArray * selectModalArray;
/**
 *  @author cao, 15-09-06 18:09:41
 *
 *  选中的cell的索引(避免cell重用显示不正确)
 */
@property(nonatomic,strong)NSMutableArray * indexArray;
/**
 *  初始化
 *
 *  @param didSelectObjectBlock 选中对象块
 *
 *  @return 数据源对象
 */

- (id)initWithDidSelectObjectBlock:(DidSelectObjectBlock)didSelectObjectBlock;
/**
 *  释放资源
 */
- (void)releaseResources;
/**
 *  @author cao, 15-09-06 10:09:02
 *
 *  获得测试数据
 */
-(void)getData;

@end
