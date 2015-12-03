//
//  AW_ApplyedCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/21.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author cao, 15-10-21 20:10:47
 *
 *  申请认证和申请开店cell
 */
@interface AW_ApplyedCell : UITableViewCell

/**
 *  @author cao, 15-10-21 20:10:16
 *
 *  申请认证label
 */
@property (weak, nonatomic) IBOutlet UILabel *certificationLabel;
/**
 *  @author cao, 15-10-21 20:10:53
 *
 *  申请开店label
 */
@property (weak, nonatomic) IBOutlet UILabel *openShopLabel;
/**
 *  @author cao, 15-10-21 20:10:07
 *
 *  点击申请认证按钮的回调
 */
@property(nonatomic,copy)void(^didClickedcertificationBtn)();
/**
 *  @author cao, 15-10-21 20:10:23
 *
 *  点击申请开店按钮的回调
 */
@property(nonatomic,copy)void(^didClickedOpenShopBtn)();

@end
