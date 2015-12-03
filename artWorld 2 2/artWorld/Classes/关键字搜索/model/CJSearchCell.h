//
//  CJSearchCellModel.h
//  artWorld
//
//  Created by 张晓旭 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJSearchCell : UITableViewCell

/**#####################⬇️ 头视图lable ⬇️####################*/
@property (weak, nonatomic) IBOutlet UILabel *cellHeadLable;


/**########################⬇️ 联系人 ⬇️############################*/
//联系人头像
@property (weak, nonatomic) IBOutlet UIImageView *contactsIcon;

//联系人名字
@property (weak, nonatomic) IBOutlet UILabel *contactsName;

//VIP
@property (weak, nonatomic) IBOutlet UIImageView *vip;

//关注Btn
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;


/**##########################⬇️ 原文模式 ⬇️##############################*/
//微博头像
@property (weak, nonatomic) IBOutlet UIImageView *weiboIcon;

//微博博主
@property (weak, nonatomic) IBOutlet UILabel *weiboName;

//微博VIP
@property (weak, nonatomic) IBOutlet UIImageView *weiboVIP;

//微博时间
@property (weak, nonatomic) IBOutlet UILabel *weiboTime;

//微博描述
@property (weak, nonatomic) IBOutlet UILabel *weiboDesc;

//Button集合
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *photoArray;

//图片到作品简介
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoToDesc;

//图片到头像
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoToIcon;


/**##########################⬇️ 转发模式 ⬇️##############################*/
//头像
@property (weak, nonatomic) IBOutlet UIImageView *s_icon;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *s_name;

//认证
@property (weak, nonatomic) IBOutlet UIImageView *s_vip;

//时间
@property (weak, nonatomic) IBOutlet UILabel *s_time;

//转发正文
@property (weak, nonatomic) IBOutlet UILabel *s_weibo;

//原微博底视图
@property (weak, nonatomic) IBOutlet UIView *ori_supView;

//原微博
@property (weak, nonatomic) IBOutlet UILabel *ori_weibo;

//图片集
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *photoArr;

//图片到微博
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoToWeibo;

//图片到顶部
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoToTop;

//底部到微博
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToWeibo;

//底部到第一行图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToFirst;

//底部到第二行图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToSecond;

//底部到第三行图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToThird;


/**########################⬇️ 尾视图 ⬇️############################*/
//脚视图的Btn
@property (weak, nonatomic) IBOutlet UIButton *cellFootBtn;

//到更多联系人
@property (nonatomic,strong) void (^toMoreContact)();

//到更多联系人
@property (nonatomic,strong) void (^toMoreContent)();

@end
