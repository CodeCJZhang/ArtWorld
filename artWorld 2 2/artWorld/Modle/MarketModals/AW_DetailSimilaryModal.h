//
//  AW_DetailSimilaryModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/24.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-24 11:10:39
 *
 *  与该艺术品相似的艺术品modal
 */
@interface AW_DetailSimilaryModal : Node

/**
 *  @author cao, 15-10-24 11:10:45
 *
 *  艺术品id
 */
@property(nonatomic,copy)NSString * art_id;
/**
 *  @author cao, 15-10-24 11:10:47
 *
 *  艺术品清晰图片url
 */
@property(nonatomic,copy)NSString * clear_img;
/**
 *  @author cao, 15-10-24 11:10:49
 *
 *  艺术品模糊图片url
 */
@property(nonatomic,copy)NSString * fuzzy_img;

@end
