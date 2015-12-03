//
//  CJReplyController.h
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJReplyController : UIViewController

//被回复的微博id
@property (nonatomic,copy) NSString *weiBo_ID;

//被回复的评论id
@property (nonatomic,copy) NSString *respond_comment_id;

//被回复的用户id
@property (nonatomic,copy) NSString *respond_user_id;

@end
