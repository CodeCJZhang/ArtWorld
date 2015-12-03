//
//  AW_DescribeLabelCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/19.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_DescribeLabelCell : UITableViewCell

/**
 *  @author cao, 15-09-19 09:09:28
 *
 *  描述文本
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
/**
 *  @author cao, 15-09-19 09:09:06
 *
 *  计算label的高度
 *
 *  @param describeString 产品详情
 *
 *  @return label高度
 */
-(CGFloat)labelHeightWith:(NSString*)describeString;

@end
