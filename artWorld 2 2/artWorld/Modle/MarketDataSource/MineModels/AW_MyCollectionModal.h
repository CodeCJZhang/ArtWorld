//
//  AW_MyCollectionModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/26.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//


#import "Node.h"
#import "AW_CommodityModal.h"

/**
 *  @author cao, 15-10-15 16:10:07
 *
 *  我收藏的艺术品列表接口modal
 */
@interface AW_MyCollectionModal : Node

typedef NS_ENUM(NSInteger, ENUM_COLLECTION_TYPE){
    
    ENUM_COLLECTION_SEPATATE = 0,
    ENUM_COLLECTION_COLLECTION = 1,
    ENUM_COLLECTION_INVALID = 2,
};
/**
 *  @author cao, 15-10-15 16:10:36
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_CommodityModal * commidityModal;
/**
 *  @author cao, 15-10-16 14:10:01
 *
 *   用来记录分割线的modal
 */
@property(nonatomic,strong)AW_MyCollectionModal * separatorModal;
/**
 *  @author cao, 15-10-15 16:10:42
 *
 *  分类id
 */
@property(nonatomic,copy)NSString * class_id;
/**
 *  @author cao, 15-10-15 16:10:44
 *
 *  分类名称
 */
@property(nonatomic,copy)NSString * class_name;
/**
 *  @author cao, 15-10-15 16:10:47
 *
 *  该分类下的作品数
 */
@property(nonatomic) NSInteger class_num;
/**
 *  @author cao, 15-08-26 16:08:25
 *
 *  是否有分割线
 */
@property(nonatomic) BOOL isSeparate;

/**
 *  @author cao, 15-10-15 16:10:49
 *
 *  cell的类别
 */
@property(nonatomic)ENUM_COLLECTION_TYPE cellType;

@end
