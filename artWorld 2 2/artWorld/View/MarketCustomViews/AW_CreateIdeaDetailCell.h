//
//  AW_CreateIdeaDetailCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_CreateIdeaDetailCell : UITableViewCell
/**
 *  @author cao, 15-10-24 13:10:08
 *
 *  创作理念
 */
@property (weak, nonatomic) IBOutlet UILabel *ideaLabel;
/**
 *  @author cao, 15-12-03 16:12:24
 *
 *  添加底部分割线
 *
 *  @param height cell高度
 */
-(void)addBottomLayerWithHeight:(float)height;

@end
