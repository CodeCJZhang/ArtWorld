//
//  AW_MyCollectionStoreDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_MyCollectionStoreModal.h"

@interface AW_MyCollectionStoreDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-09-14 10:09:50
 *
 *  获取数据
 */
-(void)getData;
/**
 *  @author cao, 15-09-14 10:09:40
 *
 *  点击按钮后的回调
 */
@property(nonatomic,copy)void(^didClickBtn)(NSInteger btnIdx , AW_MyCollectionStoreModal* storeModal);

/**
 *  @author cao, 15-09-14 10:09:40
 *
 *  点击取消和聊天按钮后的回调
 */
@property(nonatomic,copy)void(^didClickTalkBtn)(NSInteger btnIdx , AW_MyCollectionStoreModal *storeModal);
/**
 *  @author cao, 15-10-15 15:10:46
 *
 *  点击取消按钮的回调
 */
@property(nonatomic,copy)void(^didClickedCancleBtn)();
/**
 *  @author cao, 15-11-12 17:11:55
 *
 *  请求成功后的回调
 */
@property(nonatomic,copy)void(^didRequestSucess)(NSString * totalNum);
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

@end
