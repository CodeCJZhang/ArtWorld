//
//  AW_WaitEvaluteDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_MyOrderModal.h"
/**
 *  @author cao, 15-10-14 09:10:59
 *
 *  待评价数据源
 */
@interface AW_WaitEvaluteDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-10-14 10:10:19
 *
 *  点击待评价cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickedEvaluteCellButtons)(AW_MyOrderModal *modal,NSInteger index);
/**
 *  @author cao, 15-10-14 10:10:49
 *
 *  订单modal
 */
@property(nonatomic,strong)AW_MyOrderModal * orderModal;
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
 *  @author cao, 15-11-05 09:11:21
 *
 *  点击艺术品cell的回调
 */
@property(nonatomic,copy)void(^didClickedCell)(AW_CommodityModal *modal);
/**
 *  @author cao, 15-11-05 09:11:25
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_CommodityModal *modal;
@end