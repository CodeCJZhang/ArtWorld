//
//  CJMessageDataSouce.h
//  artWorld
//
//  Created by 张晓旭 on 15/8/22.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CJMarketMessageDataSource :NSObject <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) void (^toSystemMessage)();

@property (nonatomic,strong) void (^toLogisticsHelper)();

@end
