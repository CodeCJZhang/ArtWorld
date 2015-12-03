//
//  CJGroupMessageDataSource.h
//  artWorld
//
//  Created by 张晓旭 on 15/11/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJGroupMessageDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) void (^toAtMe)();

@property (nonatomic,strong) void (^toCommentMessage)();

@property (nonatomic,strong) void (^toPraiseMe)();

@property (nonatomic,strong) void (^toForward)();

@end
