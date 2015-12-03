//
//  ArtGroupCell.h
//  artWorld
//
//  Created by 张晓旭 on 15/8/7.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CJCellParameter;

@interface CJWeiBoCell : UITableViewCell

/** ################⬇️ type = 原文 ⬇️#################  */
//头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *name;

//vip
@property (weak, nonatomic) IBOutlet UIImageView *vip;

//进入小店
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

//昵称描述
@property (weak, nonatomic) IBOutlet UILabel *namedesc;

//作品描述
@property (weak, nonatomic) IBOutlet UILabel *picturedesc;

//图片集合
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *imageArr;

//发布时间
@property (weak, nonatomic) IBOutlet UILabel *time;

//发布地址
@property (weak, nonatomic) IBOutlet UIButton *address;

//转发btn
@property (weak, nonatomic) IBOutlet UIButton *sendbtn;

//赞Btn
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

//三个按钮的底视图
@property (weak, nonatomic) IBOutlet UIView *bottom4Btn;

//底部view
@property (weak, nonatomic) IBOutlet UIView *bottomview;

//照片到Icon
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picToIcon;

//照片到正文
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picToWeibo;

//时间到正文
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeToWeibo;

//时间到第一行图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeToFirst;

//时间到第二行图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeToSecond;

//时间到第三行图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeToThird;

/** ################⬆️ type = 原文 ⬆️################  */


/** ################⬇️ type = 转发 ⬇️#################  */

//转发头像
@property (weak, nonatomic) IBOutlet UIImageView *s_icon;

//转发昵称
@property (weak, nonatomic) IBOutlet UILabel *s_name;

//转发认证
@property (weak, nonatomic) IBOutlet UIImageView *s_vip;

//转发签名
@property (weak, nonatomic) IBOutlet UILabel *s_signature;

//转发正文
@property (weak, nonatomic) IBOutlet UILabel *s_weibo;

//转发时间
@property (weak, nonatomic) IBOutlet UILabel *s_time;

//转发地点
@property (weak, nonatomic) IBOutlet UIButton *s_address;

//被转发底视图
@property (weak, nonatomic) IBOutlet UIView *originalView;

//被转发底视图跳转详情Btn
@property (weak, nonatomic) IBOutlet UIButton *ori_clickBtn;

//被转发原文
@property (weak, nonatomic) IBOutlet UILabel *ori_weibo;

//被转发图片集
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ori_photo;

//底部Btn父视图
@property (weak, nonatomic) IBOutlet UIView *bottomView4Btn;

//底部视图
@property (weak, nonatomic) IBOutlet UIView *s_bottomView;

//图片到微博
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageToWeibo;

//图片到顶部
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageToTop;

//父视图到lable
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supToLab;

//父视图到第一行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supToFirst;

//父视图到第二行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supToSecond;

//父视图到第三行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supToThird;

/** ################⬆️ type = 转发 ⬆️################  */
















@property (nonatomic,copy) void (^didclickBtn) (NSInteger index);

@property (nonatomic,assign) NSInteger index;

//@property (nonatomic,copy) NSString *identifier;

//- (id)initWithIdentifier:(NSString*)identifier;

-(CJWeiBoCell *)createCellWithParameter:(CJCellParameter *)cellParameter;

@end
