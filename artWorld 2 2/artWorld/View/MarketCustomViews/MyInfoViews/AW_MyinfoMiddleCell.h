//
//  AW_MyinfoMiddleCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MyinfoMiddleCell : UITableViewCell
/**
 *  @author cao, 15-08-21 15:08:29
 *
 *  生日label
 */
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
/**
 *  @author cao, 15-08-21 15:08:51
 *
 *  家乡
 */
@property (weak, nonatomic) IBOutlet UILabel *homeText;

/**
 *  @author cao, 15-08-21 15:08:59
 *
 *  所在地
 */
@property (weak, nonatomic) IBOutlet UILabel *liveAdress;

/**
 *  @author cao, 15-08-21 15:08:05
 *
 *  个人标签
 */
@property (weak, nonatomic) IBOutlet UITextField *ownTagText;
/**
 *  @author cao, 15-08-21 15:08:18
 *
 *  个人偏好
 */
@property (weak, nonatomic) IBOutlet UILabel *preferenceLabel;
/**
 *  @author cao, 15-09-01 19:09:25
 *
 *  索引
 */
@property (nonatomic,assign)NSInteger index;
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  回调的block块
 */
@property (nonatomic,copy)void (^selectBtn)(NSInteger index);
/**
 *  @author cao, 15-11-09 09:11:42
 *
 *  个人标签改变时的回调
 */
@property(nonatomic,copy)void(^personLabelEdite)(NSString * personLabel);
/**
 *  @author cao, 15-11-09 09:11:50
 *
 *  个人标签
 */
@property(nonatomic,copy)NSString * person_label;

@end
