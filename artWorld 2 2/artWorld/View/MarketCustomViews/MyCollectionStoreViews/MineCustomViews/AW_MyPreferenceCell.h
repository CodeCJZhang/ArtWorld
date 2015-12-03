//
//  AW_MyPreferenceCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/2.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MyPreferenceCell : UICollectionViewCell
/**
 *  @author cao, 15-09-02 17:09:24
 *
 *  选择偏好类型
 */
@property (weak, nonatomic) IBOutlet UILabel *preferenceLabel;
/**
 *  @author cao, 15-09-06 11:09:13
 *
 *  选中cell后显示提示信息的button
 */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/**
 *  @author cao, 15-10-26 09:10:21
 *
 *  兴趣id
 */
@property(nonatomic,copy)NSString * id;
/**
 *  @author cao, 15-12-02 09:12:54
 *
 *  大的兴趣偏好第一个字
 */
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;

@end
