//
//  AW_MyCollectionDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_MyCollectionModal.h"

@interface AW_MyCollectionDataSource : IMB_TableDataSource

/**
 *  @author cao, 15-08-27 14:08:09
 *
 *  获得商品列表
 */
-(void)getData;
/**
 *  @author cao, 15-11-06 10:11:35
 *
 *  获得失效的艺术品列表
 */
-(void)getFailureData;
/**
 *  @author cao, 15-10-15 18:10:55
 *
 *  点击取消收藏按钮的回调
 */
@property(nonatomic,copy)void(^didClickedCancleBtn)();
/**
 *  @author cao, 15-10-16 09:10:23
 *
 *  用来盛放全部分类的数量
 */
@property(nonatomic,copy)NSString* totalClassNum;
/**
 *  @author cao, 15-10-16 15:10:30
 *
 *  将modal传到下一个界面
 */
@property(nonatomic,strong)AW_MyCollectionModal * CollectionModal;
/**
 *  @author cao, 15-11-17 22:11:45
 *
 *  请求成功后的回调
 */
@property(nonatomic,copy)void(^requestSucess)(NSString * totalNum);
/**
 *  @author cao, 15-11-26 14:11:07
 *
 *  点击艺术品cell的回调
 */
@property(nonatomic,copy)void(^didSelectCell)(AW_CommodityModal * modal);
/**
 *  @author cao, 15-11-26 14:11:21
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_CommodityModal * articleModal;

@end
