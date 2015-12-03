//
//  AW_OtherMiddleInfoCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_OtherMiddleInfoCell : UITableViewCell

/**
 *  @author cao, 15-11-23 15:11:43
 *
 *  生日
 */
@property (weak, nonatomic) IBOutlet UILabel *birthday;
/**
 *  @author cao, 15-11-23 15:11:46
 *
 *  家乡
 */
@property (weak, nonatomic) IBOutlet UILabel *homeTown;
/**
 *  @author cao, 15-11-23 15:11:48
 *
 *  所在地
 */
@property (weak, nonatomic) IBOutlet UILabel *liveAdress;
/**
 *  @author cao, 15-11-23 15:11:51
 *
 *  个人标签
 */
@property (weak, nonatomic) IBOutlet UILabel *person_label;

/**
 *  @author cao, 15-11-23 15:11:53
 *
 *  偏好
 */
@property (weak, nonatomic) IBOutlet UILabel *preference;

@end
