//
//  AW_ProduceFilterView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_ArtWorkModal.h"

@interface AW_ProduceFilterView : UIView
/**
 *  @author cao, 15-09-14 23:09:51
 *
 *  搜索分类关键字
 */
@property(nonatomic,strong)AW_ArtWorkModal *queryModal;
/**
 *  @author cao, 15-09-15 09:09:37
 *
 *  选中cell后的回调
 */
@property(nonatomic,copy)void(^didClickCell)( AW_ArtWorkModal* queryModal);
/**
 *  @author cao, 15-09-14 19:09:06
 *
 *  筛选数据数组
 */
@property(nonatomic,strong)NSArray * dataArray;
/**
 *  @author cao, 15-10-19 15:10:39
 *
 *  该分类下的商品数量
 */
@property(nonatomic)NSInteger classArtNum;

@end
