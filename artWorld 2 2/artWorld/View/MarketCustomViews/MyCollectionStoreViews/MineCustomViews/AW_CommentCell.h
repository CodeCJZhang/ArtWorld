//
//  AW_CommentCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPlaceholderTextView.h"

@interface AW_CommentCell : UITableViewCell
/**
 *  @author cao, 15-09-16 17:09:18
 *
 *  艺术品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
/**
 *  @author cao, 15-09-16 17:09:34
 *
 *  艺术品描述
 */
@property (weak, nonatomic) IBOutlet UILabel *articleDes;
/**
 *  @author cao, 15-09-16 17:09:45
 *
 *  艺术品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *articlePrice;
/**
 *  @author cao, 15-09-16 17:09:54
 *
 *  好评按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
/**
 *  @author cao, 15-09-16 17:09:08
 *
 *  好评label
 */
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
/**
 *  @author cao, 15-09-16 17:09:20
 *
 *  中评按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
/**
 *  @author cao, 15-09-16 17:09:32
 *
 *  中评label
 */
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
/**
 *  @author cao, 15-09-16 17:09:52
 *
 *  差评按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *badBtn;
/**
 *  @author cao, 15-09-16 17:09:01
 *
 *  差评label
 */
@property (weak, nonatomic) IBOutlet UILabel *badLabel;
/**
 *  @author cao, 15-09-16 17:09:14
 *
 *  评论textView
 */
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *commentTextView;

/**
 *  @author cao, 15-09-16 17:09:19
 *
 *  点击评论按钮后的回调
 */
@property(nonatomic,copy)void(^didClickCommentBtn)(NSInteger index);
/**
 *  @author cao, 15-09-16 17:09:37
 *
 *  按钮标签
 */
@property(nonatomic)NSInteger buttonTag;
/**
 *  @author cao, 15-11-11 16:11:26
 *
 *  编辑评论内容的回调
 */
@property(nonatomic,copy)void(^didEditeTextView)(NSString * text);
/**
 *  @author cao, 15-11-11 16:11:29
 *
 *  评论内容
 */
@property(nonatomic,copy)NSString * comment_content;

@end
