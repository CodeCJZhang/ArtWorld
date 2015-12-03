//
//  MessageViewController.h
//  artWorld
//
//  Created by 张晓旭 on 15/8/8.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CJMessageViewController : BaseViewController

- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
