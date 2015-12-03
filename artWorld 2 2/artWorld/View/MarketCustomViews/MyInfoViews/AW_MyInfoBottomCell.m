//
//  AW_MyInfoBottomCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyInfoBottomCell.h"
#import "IMB_Macro.h"

@interface AW_MyInfoBottomCell()<UITextFieldDelegate,UITextViewDelegate>
/**
 *  @author cao, 15-08-21 15:08:21
 *
 *  上部分割线
 */
@property(nonatomic,strong)CAShapeLayer* topLarer;
/**
 *  @author cao, 15-09-27 19:09:59
 *
 *  退出按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/**
 *  @author cao, 15-09-27 19:09:08
 *
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation AW_MyInfoBottomCell


-(CAShapeLayer*)topLarer{
    if (!_topLarer) {
        _topLarer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _topLarer.frame = CGRectMake(0, 44, [[UIScreen mainScreen]bounds].size.width, lineHeight);
        _topLarer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _topLarer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ownSinerText.delegate = self;
    self.textView.delegate = self;
    self.ownSinerText.clearButtonMode = UITextFieldViewModeAlways;
    [self.layer addSublayer:self.topLarer];
    self.cancleBtn.layer.cornerRadius = 4.0f;
    self.cancleBtn.clipsToBounds = YES;
    self.bottomView.backgroundColor = HexRGB(0xf6f7f8);
    self.textView.placeholder=@"简介:介绍下自己吧。(120字以内)";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - CancleBtnClicked Menthod
- (IBAction)cancleBtnClicked:(id)sender {
    if (_didClickedCancleBtn) {
        _didClickedCancleBtn();
    }
}

#pragma mark - Delegate Menthod

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.signature = self.ownSinerText.text;
    if (_signatureEdite) {
        _signatureEdite(_signature);
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.synopsisString = self.textView.text;
    if (_synopsisEdite) {
        _synopsisEdite(self.synopsisString);
    }
}

@end
