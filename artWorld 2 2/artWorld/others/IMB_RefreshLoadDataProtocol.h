//
//  IMB_RefreshLoadDataProtocol.h
//  GoComIM
//
//  Created by 闫建刚 on 14-10-9.
//  Copyright (c) 2014年 iMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMB_RefreshLoadDataProtocol <NSObject>

@optional

/**
 *  是否不是第一次加载
 */
@property (nonatomic,assign) BOOL isNotFirstLoading;

/**
 *  正在刷新数据
 */
@property (nonatomic,assign) BOOL isRefreshData;

/**
 *  是否正在加载
 */
@property (nonatomic,assign) BOOL isLoadingData;

/**
 *  是否有刷新头部
 */
@property (nonatomic,assign) BOOL hasRefreshHeader;

/**
 *  是否有加载更多
 */
@property (nonatomic,assign) BOOL hasLoadMoreFooter;

/**
 *  添加头部
 */
- (void)addHeader;

/**
 *  添加脚部
 */
- (void)addFooter;

/**
 *  数据已经加载完毕
 */
- (void)dataDidLoad;




@end
