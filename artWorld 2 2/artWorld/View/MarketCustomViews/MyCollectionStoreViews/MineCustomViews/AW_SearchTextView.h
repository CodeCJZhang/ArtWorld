//
//  AW_SearchTextView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_SearchTextView : UIView
/**
 *  @author cao, 15-09-15 11:09:59
 *
 *  搜索背景图
 */
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

/**
 *  @author cao, 15-09-15 11:09:09
 *
 *  搜索按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
/**
 *  @author cao, 15-09-15 11:09:31
 *
 *  点击搜索按钮后的回调
 */
@property(nonatomic,copy)void(^didClickSearchBtn)(NSString *searchString);
/**
 *  @author cao, 15-09-15 11:09:45
 *
 *  搜索的关键字
 */
@property(nonatomic,copy)NSString * searchString;
/**
 *  @author cao, 15-09-15 15:09:10
 *
 *  搜索输入的关键字
 */
@property (weak, nonatomic) IBOutlet UITextField *searchStringText;

@end
