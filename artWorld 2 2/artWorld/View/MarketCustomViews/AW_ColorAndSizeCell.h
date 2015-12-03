//
//  AW_ColorAndSizeCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ColorAndSizeCell : UITableViewCell

/**
 *  @author cao, 15-10-23 21:10:09
 *
 *  作品尺寸
 */
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
/**
 *  @author cao, 15-10-23 21:10:24
 *
 *  作品制作工艺
 */
@property (weak, nonatomic) IBOutlet UILabel *CraftLabel;
/**
 *  @author cao, 15-10-23 21:10:47
 *
 *  作品颜色
 */
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
/**
 *  @author cao, 15-10-25 13:10:32
 *
 *  点击颜色按钮的回调
 */
@property(nonatomic,copy)void(^didClickColorBtn)();
@end
