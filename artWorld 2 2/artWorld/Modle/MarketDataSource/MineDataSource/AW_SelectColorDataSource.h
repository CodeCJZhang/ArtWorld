//
//  AW_SelectColorDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/18.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_MyShopCartModal.h"
/**
 *  @author cao, 15-09-18 18:09:38
 *
 *  选择颜色数据源
 */
@interface AW_SelectColorDataSource : IMB_TableDataSource

/**
 *  @author cao, 15-10-15 12:10:30
 *
 *  商铺modal(用来接上个界面传过来的艺术品modal)
 */
@property(nonatomic,strong)AW_MyShopCartModal * shopCartModal;
/**
 *  @author cao, 15-09-19 16:09:11
 *
 *  获取数据
 */
-(void)getData;

@end
