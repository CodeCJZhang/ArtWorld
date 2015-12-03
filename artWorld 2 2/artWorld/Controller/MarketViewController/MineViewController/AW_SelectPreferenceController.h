//
//  AW_SelectPreferenceController.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/2.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AW_SelectPreferenceControllerDelegate <NSObject>

-(void)didClickCompleteBtnWithSelectArray:(NSMutableArray*)selectArray;

@end

/**
 *  @author cao, 15-09-02 16:09:06
 *
 *  选择偏好控制器
 */
@interface AW_SelectPreferenceController : UIViewController

@property(nonatomic,weak)id<AW_SelectPreferenceControllerDelegate>delegate;

@end
