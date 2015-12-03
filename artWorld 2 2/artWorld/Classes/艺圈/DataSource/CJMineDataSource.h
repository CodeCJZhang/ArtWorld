//
//  CJMineDataSource.h
//  artWorld
//
//  Created by 张晓旭 on 15/11/16.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJMineDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) void (^myBlock) (NSInteger index);

@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) UITableView *tableView;

@end
