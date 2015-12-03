//
//  AW_ArticleDetileCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/19.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ArticleDetileCell : UITableViewCell
/**
 *  @author cao, 15-09-19 09:09:56
 *
 *  判断是否有分割线
 *
 *  @param isShow 分割线
 */
-(void)hasButtomSeparate:(BOOL)isShow;
/**
 *  @author cao, 15-09-19 11:09:50
 *
 *  左侧label内容
 */
@property (weak, nonatomic) IBOutlet UILabel *leftString;
/**
 *  @author cao, 15-09-20 11:09:16
 *
 *  是否有上分割线
 *
 *  @param isShow 分割线
 */
-(void)hasTopSeparate:(BOOL)isShow;
@end
