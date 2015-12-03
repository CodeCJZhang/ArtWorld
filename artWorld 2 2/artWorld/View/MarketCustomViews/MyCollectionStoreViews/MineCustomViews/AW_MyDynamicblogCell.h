//
//  AW_MyDynamicblogCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_MicroBlogListModal.h"

@interface AW_MyDynamicblogCell : UITableViewCell
/**
 *  @author cao, 15-09-21 21:09:47
 *
 *  vip图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
/**
 *  @author cao, 15-09-21 21:09:00
 *
 *  头像图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/**
 *  @author cao, 15-09-21 21:09:09
 *
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *blogerName;
/**
 *  @author cao, 15-09-21 21:09:17
 *
 *  微博发布日期
 */
@property (weak, nonatomic) IBOutlet UILabel *publicDate;
/**
 *  @author cao, 15-09-21 21:09:32
 *
 *  微博内容
 */
@property (weak, nonatomic) IBOutlet UILabel *blogContent;
/**
 *  @author cao, 15-09-21 21:09:41
 *
 *  微博发布的地点
 */
@property (weak, nonatomic) IBOutlet UILabel *publicAdress;
/**
 *  @author cao, 15-09-21 21:09:55
 *
 *  图片按钮数组
 */
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ImageViewArray;
/**
 *  @author cao, 15-09-21 21:09:11
 *
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomLayer;
/**
 *  @author cao, 15-09-22 17:09:37
 *
 *  转发按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *transmitBtn;
/**
 *  @author cao, 15-09-22 17:09:46
 *
 *  评论按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
/**
 *  @author cao, 15-09-22 17:09:56
 *
 *  赞按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
/**
 *  @author cao, 15-09-22 17:09:39
 *
 *  点击按钮后的回调
 */
@property(nonatomic,copy)void(^didClickedBtns)(NSInteger index);
/**
 *  @author cao, 15-09-23 15:09:17
 *
 *  点击图片按钮的回调
 */
@property(nonatomic,copy)void(^didClickedImageBtns)(NSInteger index);
/**
 *  @author cao, 15-09-23 15:09:33
 *
 *  图片按钮标签
 */
@property(nonatomic)NSInteger imageBtnTag;
/**
 *  @author cao, 15-09-22 17:09:52
 *
 *  按钮标签
 */
@property(nonatomic)NSInteger buttonTag;
/**
 *  @author cao, 15-09-21 22:09:45
 *
 *  判断有几行图片
 *
 *  @param imageArray 图片数组
 */
-(void)hasText:(NSString*)text ImageArray:(NSArray *)imageArray showAdress:(BOOL)isShow;
/**
 *  @author cao, 15-08-16 10:08:44
 *
 *  配置信息
 *
 *  @param dynamicModal 我的动态模型
 */
-(void)configDataWithDynamicModal:(AW_MicroBlogListModal*)dynamicModal;
/**
 *  @author cao, 15-09-23 15:09:45
 *
 *  label底部距离图片的高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomConstraint;

@end
