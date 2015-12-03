//
//  AW_ArticlePopingView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/19.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_ConfirmBtnView.h"

/**
 *  @author cao, 15-09-19 14:09:50
 *
 *  弹出视图（显示商品详情的tableView）
 */
@interface AW_ArticlePopingView : UIView
/**
 *  @author cao, 15-09-18 18:09:20
 *
 *  选择颜色列表
 */
@property(nonatomic,strong)UITableView * colorTableView;
/**
 *  @author cao, 15-09-18 18:09:40
 *
 *  确认按钮视图
 */
@property(nonatomic,strong)AW_ConfirmBtnView * btnView;
@end
