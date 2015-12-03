//
//  CJTableViewDataSouce.h
//  artWorld
//
//  Created by 张晓旭 on 15/8/19.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface CJSquareDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) void (^artBlock) (NSInteger index);

@property (nonatomic,copy) void (^toWeiboDetails)(NSString *weiBo_ID);

@end
