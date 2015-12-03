//
//  AW_keywordSearchView.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/28.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_keywordSearchView : UIView

/**
 *  @author cao, 15-10-28 13:10:37
 *
 *  背景图
 */
@property (weak, nonatomic) IBOutlet UITextField *backgroundView;
/**
 *  @author cao, 15-10-28 13:10:40
 *
 *  点击搜索按钮的回调
 */
@property(nonatomic,copy)void(^didClickedSearchBtn)(NSString * searchString);
/**
 *  @author cao, 15-10-28 13:10:44
 *
 *  搜索关键字
 */
@property(nonatomic,copy)NSString * searchString;
/**
 *  @author cao, 15-10-28 13:10:46
 *
 *  搜索文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end
