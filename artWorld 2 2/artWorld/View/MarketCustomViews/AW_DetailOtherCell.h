//
//  AW_DetailOtherCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_DetailOtherCell : UITableViewCell

/**
 *  @author cao, 15-10-24 14:10:51
 *
 *  发货地
 */
@property (weak, nonatomic) IBOutlet UILabel *sendOutPlace;
/**
 *  @author cao, 15-10-24 14:10:54
 *
 *  库存
 */
@property (weak, nonatomic) IBOutlet UILabel *storageNum;
/**
 *  @author cao, 15-10-24 14:10:57
 *
 *  产品数量
 */
@property (weak, nonatomic) IBOutlet UITextField *numTextField;

/**
 *  @author cao, 15-10-25 14:10:25
 *
 *  数量的回调
 */
@property(nonatomic,copy)void(^didClick)(NSInteger index);
/**
 *  @author cao, 15-10-25 15:10:05
 *
 *  按钮索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-11-30 16:11:07
 *
 *  编辑结束后的回调
 */
@property(nonatomic,copy)void(^endEdite)(NSString * str);
/**
 *  @author cao, 15-11-30 16:11:10
 *
 *  商品数量
 */
@property(nonatomic,copy)NSString * numString;

@end
