//
//  AW_PostageCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author cao, 15-10-23 16:10:40
 *
 *  邮费cell
 */
@interface AW_PostageCell : UITableViewCell

/**
 *  @author cao, 15-10-23 16:10:06
 *
 *  价格label
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/**
 *  @author cao, 15-10-23 16:10:09
 *
 *  邮费label
 */
@property (weak, nonatomic) IBOutlet UILabel *postageLabel;

@end
