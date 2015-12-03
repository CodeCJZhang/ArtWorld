//
//  AW_DecadeOrAutherCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/15.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_DecadeOrAutherCell : UITableViewCell
/**
 *  @author cao, 15-11-15 21:11:06
 *
 *  年代或者作者label
 */
@property (weak, nonatomic) IBOutlet UILabel *autherOrTimeLabel;
/**
 *  @author cao, 15-11-15 21:11:02
 *
 *  描述label
 */
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@end
