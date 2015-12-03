//
//  AW_MyCollectionStoreModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_StoreModal.h"
/**
 *  @author cao, 15-10-15 14:10:51
 *
 *  我收藏的店铺列表接口Modal
 */
@interface AW_MyCollectionStoreModal : Node
/**
 *  @author cao, 15-10-15 15:10:46
 *
 *  商铺modal
 */
@property(nonatomic,strong)AW_StoreModal * storeModal;
/**
 *  @author cao, 15-08-27 16:08:25
 *
 *  判断是否是会员
 */
@property(nonatomic)BOOL isVip;
/**
 *  @author cao, 15-08-27 16:08:07
 *
 *  判断是否是分割线
 */
@property(nonatomic)BOOL isSeparate;

@end
