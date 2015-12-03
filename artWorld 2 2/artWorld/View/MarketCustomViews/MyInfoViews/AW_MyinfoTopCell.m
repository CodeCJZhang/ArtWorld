//
//  AW_MyinfoTopCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyinfoTopCell.h"
#import "IMB_Macro.h"

@interface AW_MyinfoTopCell()<UITextFieldDelegate>
/**
 *  @author cao, 15-08-21 14:08:25
 *
 *  顶部视图
 */
@property (weak, nonatomic) IBOutlet UIView *headContainerView;
/**
 *  @author cao, 15-08-21 14:08:41
 *
 *  上部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-08-21 14:08:52
 *
 *  中部视图
 */
@property (weak, nonatomic) IBOutlet UIView *middleView;
/**
 *  @author cao, 15-08-21 14:08:01
 *
 *  下部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 *  @author cao, 15-08-21 14:08:35
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer* topLarer;
/**
 *  @author cao, 15-08-21 14:08:44
 *
 *  中分割线
 */
@property(nonatomic,strong)CAShapeLayer* middleLayer;
/**
 *  @author cao, 15-08-21 14:08:02
 *
 *  下分割线
 */
@property(nonatomic,strong)CAShapeLayer* bottomLayer;
@end

@implementation AW_MyinfoTopCell

-(CAShapeLayer*)topLarer{
    if (!_topLarer) {
        _topLarer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _topLarer.frame = CGRectMake(0, 124, [[UIScreen mainScreen]bounds].size.width, lineHeight);
        _topLarer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _topLarer;
}

-(CAShapeLayer*)middleLayer{
    if (!_middleLayer) {
        _middleLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _middleLayer.frame = CGRectMake(0, 168, [[UIScreen mainScreen]bounds].size.width, lineHeight);
        _middleLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _middleLayer;
}

-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/([UIScreen mainScreen].scale);
        _bottomLayer.frame = CGRectMake(0, 212, [[UIScreen mainScreen]bounds].size.width, lineHeight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameText.delegate = self;
    /**
     *  @author cao, 15-08-21 18:08:50
     *
     *  设置圆角
     */
    //self.headImageBtn.layer.cornerRadius = 30;
   // self.headImageBtn.clipsToBounds = YES;
    self.nameText.clearButtonMode = UITextFieldViewModeAlways;
    self.headContainerView.backgroundColor = HexRGB(0x88c244);
    [self.layer addSublayer:self.topLarer];
    [self.layer addSublayer:self.middleLayer];
    [self.layer addSublayer:self.bottomLayer];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

/**
 *  @author cao, 15-09-01 20:09:09
 *
 *  修改密码按钮
 *
 *  @param sender
 */
- (IBAction)changgePassword:(id)sender {
    UIButton * button = sender;
    _index = button.tag;
    if(_selectKindBtn){
        _selectKindBtn(_index);
    }
}

#pragma mark - UITextFieldDelegate Menthod
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _nickName = textField.text;
    if (_didEditeNickName) {
        _didEditeNickName(_nickName);
    }
}
@end
