//
//  IMB_TableDataSource.h
//  GoComIM
//
//  Created by 闫建刚 on 14-9-22.
//  Copyright (c) 2014年 iMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import "IMB_RefreshLoadDataProtocol.h"
#import "IMB_Macro.h"


@interface IMB_TableDataSource : NSObject<UITableViewDelegate,UITableViewDataSource,IMB_RefreshLoadDataProtocol>
/**
 *  数据集合
 */
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *payArr;
@property (nonatomic,strong) NSMutableArray *sendArr;
@property (nonatomic,strong) NSMutableArray *receiveArr;
@property (nonatomic,strong) NSMutableArray *evaluteArr;
/**
 *  已选中某个对象回调
 */
@property (nonatomic,copy) DidSelectObjectBlock didSelectObjectBlock;
/**
 *  关联的列表
 */
@property (nonatomic,assign) UITableView *tableView;

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
 *  @author zhe, 15-06-23 09:06:35
 *
 *  预处理计算cell高度
 */
- (void)pretreatWithHeight;

@end
