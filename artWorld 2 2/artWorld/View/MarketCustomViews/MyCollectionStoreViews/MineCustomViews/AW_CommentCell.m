//
//  AW_CommentCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_CommentCell.h"
#import "AW_Constants.h"

@interface AW_CommentCell()<UITextViewDelegate>
/**
 *  @author cao, 15-09-16 21:09:54
 *
 *  textView背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *textBackImage;

@end

@implementation AW_CommentCell

#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    self.articlePrice.textColor = [UIColor orangeColor];
    /*UIImage * backgroundImage = [UIImage imageNamed:@"产品详情--产品类型选择bg-已选择"];
    backgroundImage = ResizableImageDataForMode(backgroundImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    self.textBackImage.image = backgroundImage;*/
     self.commentTextView.backgroundColor = HexRGB(0xf6f7f8);
    self.commentTextView.layer.cornerRadius = 7.0f;
    self.commentTextView.clipsToBounds = YES;
    
    [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"发表评论--好评-圆"] forState:UIControlStateNormal];
      [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"发表评论--默认好评"] forState:UIControlStateSelected];
    [self.middleBtn setBackgroundImage:[UIImage imageNamed:@"发表评论--中评-圆"] forState:UIControlStateNormal];
    [self.middleBtn setBackgroundImage:[UIImage imageNamed:@"发表评论--中评-展"] forState:UIControlStateSelected];
    [self.badBtn setBackgroundImage:[UIImage imageNamed:@"发表评论--差评-圆"] forState:UIControlStateNormal];
    [self.badBtn setBackgroundImage:[UIImage imageNamed:@"发表评论--差评-展"] forState:UIControlStateSelected];
    self.goodBtn.selected = YES;
    self.goodBtn.highlighted = NO;
    self.middleBtn.highlighted = NO;
    self.badBtn.highlighted = NO;
    self.commentTextView.placeholder = @"请填写评论内容";
    self.commentTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - ButtonClick Menthod
- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    _buttonTag = btn.tag;
    if (_didClickCommentBtn) {
        _didClickCommentBtn(_buttonTag);
    }
}

#pragma mark - UITextViewDelegate Menthod
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.comment_content = textView.text;
    if (_didEditeTextView) {
        _didEditeTextView(_comment_content);
    }
}

@end
