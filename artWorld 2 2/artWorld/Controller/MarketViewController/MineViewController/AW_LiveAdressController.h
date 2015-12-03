//
//  AW_LiveAdressController.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveAdressDelegate <NSObject>

-(void)didClikedCell:(NSString*)adressString;

@end
/**
 *  @author cao, 15-09-27 10:09:22
 *
 *  所在地控制器
 */
@interface AW_LiveAdressController : UIViewController
/**
 *  @author cao, 15-09-27 19:09:44
 *
 *  委托对象
 */
@property(nonatomic,weak)id<LiveAdressDelegate> delegate;

@end
