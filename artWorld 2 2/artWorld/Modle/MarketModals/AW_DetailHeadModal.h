//
//  AW_DetailHeadModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/24.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-24 10:10:59
 *
 *  艺术品详情头部modal
 */
@interface AW_DetailHeadModal : Node

/**
 *  @author cao, 15-10-24 11:10:05
 *
 *  清晰的图片url，多张时，url之间用英文逗号分隔
 */
@property(nonatomic,strong)NSArray * clearImageArray;
/**
 *  @author cao, 15-10-24 11:10:08
 *
 *  模糊的艺术品图片url
 */
@property(nonatomic,copy)NSString * fuzzy_img;
/**
 *  @author cao, 15-10-24 11:10:25
 *
 *  艺术品名称
 */
@property(nonatomic,copy)NSString * artName;
/**
 *  @author cao, 15-10-24 11:10:28
 *
 *  用户是否已经收藏该艺术品
 */
@property(nonatomic)BOOL isCollected;
/**
 *  @author cao, 15-10-24 11:10:31
 *
 *  好评率
 */
@property(nonatomic,copy)NSString * evaluation;
/**
 *  @author cao, 15-10-24 11:10:33
 *
 *  评价数量
 */
@property(nonatomic,copy)NSString * evaluation_num;

@end
