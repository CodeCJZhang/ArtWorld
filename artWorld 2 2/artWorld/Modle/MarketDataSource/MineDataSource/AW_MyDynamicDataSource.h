//
//  AW_MyDynamicDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_MicroBlogListModal.h"

/**
 *  @author cao, 15-08-16 11:08:13
 *
 *  我的动态数据源
 */
@interface AW_MyDynamicDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-09-22 17:09:15
 *
 *  点击转发,评论,赞按钮后的回调
 */
@property(nonatomic,copy)void(^didClickedBottomBtns)(NSInteger index,AW_MicroBlogListModal* modal);
/**
 *  @author cao, 15-09-22 17:09:46
 *
 *  我的动态modal
 */
@property(nonatomic,strong)AW_MicroBlogListModal * dynamicModal;
/**
 *  @author cao, 15-10-02 17:10:44
 *
 *  点击图片按钮的回调
 */
@property(nonatomic,copy)void(^didClickedImageBtn)(NSArray * photosArray,NSInteger index);
/**
 *  @author cao, 15-10-02 17:10:01
 *
 *  图片数组
 */
@property(nonatomic,strong)NSArray * photosArray;
/**
 *  @author cao, 15-10-02 17:10:11
 *
 *  图片索引
 */
@property(nonatomic)NSInteger imageIndex;
/**
 *  @author cao, 15-11-09 21:11:55
 *
 *  记录被查看用户的id
 */
@property(nonatomic,copy)NSString * person_id;

@end
