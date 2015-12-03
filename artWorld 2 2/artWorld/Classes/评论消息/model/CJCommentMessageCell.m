//
//  CJCommentMessageCell.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJCommentMessageCell.h"

@interface CJCommentMessageCell ()

//恢复按钮
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;

//原微博底视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation CJCommentMessageCell

- (void)awakeFromNib {
    _replyBtn.layer.cornerRadius = 3.0;
    _replyBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    _replyBtn.layer.borderWidth = 0.5;
    _bottomView.layer.cornerRadius = 3.0;
}

//点击回复按钮
- (IBAction)replyBtn:(id)sender
{
    _toReply();
}

@end
