//
//  AW_ArtColorCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/29.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ArtColorCell : UITableViewCell
/**
 *  @author cao, 15-10-29 09:10:38
 *
 *  艺术品颜色
 */
@property (weak, nonatomic) IBOutlet UILabel *artColorLabel;
/**
 *  @author cao, 15-10-29 09:10:16
 *
 *  点击颜色按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)();

@end
