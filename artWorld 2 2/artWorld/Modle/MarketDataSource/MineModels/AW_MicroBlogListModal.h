//
//  AW_MicroBlogListModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_UserModal.h"
/**
 *  @author cao, 15-10-16 20:10:16
 *
 *  用户发表的微博列表接口Modal
 */
@interface AW_MicroBlogListModal : Node

/**
 *  @author cao, 15-10-16 20:10:05
 *
 *  用户modal
 */
@property(nonatomic,strong)AW_UserModal * userModal;
/**
 *  @author cao, 15-10-16 20:10:07
 *
 *  微博id
 */
@property(nonatomic,copy)NSString * microBlog_id;
/**
 *  @author cao, 15-10-16 20:10:10
 *
 *  总记录数
 */
@property(nonatomic,copy)NSString * totalNumber;
/**
 *  @author cao, 15-10-16 20:10:13
 *
 *  微博文字内容，如果内容太长可以截取一部分
 */
@property(nonatomic,copy)NSString * microBlog_Content;
/**
 *  @author cao, 15-10-16 20:10:16
 *
 *  微博中清晰图片的url数组
 */
@property(nonatomic,strong)NSArray * imageArray;
/**
 *  @author cao, 15-10-16 20:10:19
 *
 *  微博中模糊图片的url
 */
@property(nonatomic,copy)NSString * fuzzy_img;
/**
 *  @author cao, 15-10-16 20:10:22
 *
 *  微博发布时间截
 */
@property(nonatomic,copy)NSString * create_time;
/**
 *  @author cao, 15-10-16 20:10:25
 *
 *  发微博时被查看用户所处的位置
 */
@property(nonatomic,copy)NSString * location;
/**
 *  @author cao, 15-10-16 20:10:27
 *
 *  当前登录用户是赞过这条微博
 */
@property(nonatomic)BOOL isPraised;
/**
 *  @author cao, 15-10-16 21:10:48
 *
 *  是否是分割线
 */
@property(nonatomic)BOOL isSeparator;
/**
 *  @author cao, 15-10-16 21:10:25
 *
 *  是否显示地址
 */
@property(nonatomic)BOOL hasAdress;

@end
