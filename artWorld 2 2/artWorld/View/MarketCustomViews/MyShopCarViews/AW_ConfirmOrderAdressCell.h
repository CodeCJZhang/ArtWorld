//
//  AW_ConfirmOrderAdressCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ConfirmOrderAdressCell : UITableViewCell

/**
 *  @author cao, 15-09-11 18:09:17
 *
 *  收货人姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *orderName;
/**
 *  @author cao, 15-09-11 18:09:32
 *
 *  收货人电话号码
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPhone;
/**
 *  @author cao, 15-09-11 18:09:44
 *
 *  收货地址
 */
@property (weak, nonatomic) IBOutlet UILabel *orderAdress;

@end
