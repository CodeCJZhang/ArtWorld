//
//  AW_MyInfoBottomCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPlaceholderTextView.h"
@interface AW_MyInfoBottomCell : UITableViewCell
/**
 *  @author cao, 15-08-21 15:08:22
 *
 *  个性签名
 */
@property (weak, nonatomic) IBOutlet UITextField *ownSinerText;
/**
 *  @author cao, 15-08-21 15:08:38
 *
 *  下部textView
 */
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *textView;
/**
 *  @author cao, 15-08-21 15:08:53
 *
 *  上部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-10-22 16:10:15
 *
 *  点击取消登陆按钮的回调
 */
@property(nonatomic,copy)void(^didClickedCancleBtn)();
/**
 *  @author cao, 15-11-09 09:11:03
 *
 *  个性签名改变时的回调
 */
@property(nonatomic,copy)void(^signatureEdite)(NSString *signatureString);
/**
 *  @author cao, 15-11-09 09:11:25
 *
 *  个人简介改变使后的回调
 */
@property(nonatomic,copy)void(^synopsisEdite)(NSString * synopsisString);
/**
 *  @author cao, 15-11-09 09:11:32
 *
 *  个人简介
 */
@property(nonatomic,copy)NSString * synopsisString;
/**
 *  @author cao, 15-11-09 09:11:36
 *
 *  个性签名
 */
@property(nonatomic,copy)NSString * signature;
@end
