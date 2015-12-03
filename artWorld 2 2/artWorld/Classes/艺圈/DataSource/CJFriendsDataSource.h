//
//  CJFriendsDataSource.h
//  artWorld
//
//  Created by 张晓旭 on 15/11/16.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJFriendsDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) void (^friBlock) (NSInteger index);

@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) UITableView *tableView;

@end
