//
//  AW_OtherBottomInfoCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_OtherBottomInfoCell : UITableViewCell

/**
 *  @author cao, 15-11-23 15:11:07
 *
 *  个性签名
 */
@property (weak, nonatomic) IBOutlet UILabel *person_singure;
/**
 *  @author cao, 15-11-23 15:11:11
 *
 *  个人描述
 */
@property (weak, nonatomic) IBOutlet UILabel *persondescribe;
/**
 *  @author cao, 15-11-23 15:11:08
 *
 *  计算cell高度
 *
 *  @param string 描述
 *
 *  @return 高度
 */
-(CGFloat)heightWithString:(NSString *)string;

@end
