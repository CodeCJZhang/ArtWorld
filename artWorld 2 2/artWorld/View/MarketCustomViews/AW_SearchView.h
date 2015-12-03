//
//  AW_SearchView.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author cao, 15-10-26 22:10:36
 *
 *  搜索头部视图
 */
@interface AW_SearchView : UIView
/**
 *  @author cao, 15-10-26 22:10:12
 *
 *  全部分类按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
/**
 *  @author cao, 15-10-26 22:10:23
 *
 *  地区分类按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
/**
 *  @author cao, 15-10-26 22:10:37
 *
 *  智能排序按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *IntelligenceBtn;
/**
 *  @author cao, 15-10-26 22:10:26
 *
 *  点击按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger index);
/**
 *  @author cao, 15-10-26 22:10:41
 *
 *  按钮索引
 */
@property(nonatomic)NSInteger index;

@end
