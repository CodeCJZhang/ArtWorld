//
//  CJPraiseDataSource.h
//  artWorld
//
//  Created by 张晓旭 on 15/11/7.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJPraiseDataSource : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) NSString *weiBo_ID;

@property (nonatomic,strong) UITableView *tableView;

- (void)getData;

@end
