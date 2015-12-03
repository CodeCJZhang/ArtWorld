//
//  AW_BigClassCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_BigClassCell : UITableViewCell

/**
 *  @author cao, 15-10-26 17:10:46
 *
 *  大分类图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *bigClassImage;
/**
 *  @author cao, 15-10-26 18:10:03
 *
 *  大分类标签
 */
@property (weak, nonatomic) IBOutlet UILabel *bigClassLabel;

@end
