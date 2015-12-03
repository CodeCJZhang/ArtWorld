//
//  AW_TarBarView.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/20.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_TarBarView.h"
#import "IMB_Macro.h"

@interface AW_TarBarView ()
/**
 *  @author zhe, 15-07-15 17:07:48
 *
 *  下面分割线
 */
@property (nonatomic,strong)CAShapeLayer *buttomLayer;

/**
 *  @author cao, 15-11-12 11:11:03
 *
 *  添加分割线的视图
 */
@property (weak, nonatomic) IBOutlet UIView *total2View;

@end

@implementation AW_TarBarView

#pragma mark - SeparateLine Menthod

-(CAShapeLayer*)left2layer{
    if (!_left2layer) {
        _left2layer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = (1.0f/[UIScreen mainScreen].scale);
        _left2layer.frame = CGRectMake(kSCREEN_WIDTH/3, 7, lineWidth, self.bounds.size.height - 14);
        _left2layer.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _left2layer;

}

-(CAShapeLayer*)right2Layer{
    if (!_right2Layer) {
        _right2Layer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = (1.0f/[UIScreen mainScreen].scale);
        _right2Layer.frame = CGRectMake(kSCREEN_WIDTH/3*2, 7, lineWidth, self.bounds.size.height - 14);
        _right2Layer.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _right2Layer;
    
}

-(CAShapeLayer*)leftLayer{
    if (!_leftLayer) {
        _leftLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = (1.0f/[UIScreen mainScreen].scale);
        _leftLayer.frame = CGRectMake(kSCREEN_WIDTH/4, 7, lineWidth, self.bounds.size.height - 14);
        _leftLayer.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _leftLayer;
}

-(CAShapeLayer*)midleLayer{
    if (!_midleLayer) {
        _midleLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = (1.0f/[UIScreen mainScreen].scale);
        _midleLayer.frame = CGRectMake((kSCREEN_WIDTH/4)*2, 7, lineWidth, self.bounds.size.height - 14);
        _midleLayer.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _midleLayer;
}

-(CAShapeLayer*)rightLayer{
    if (!_rightLayer) {
        _rightLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = (1.0f/[UIScreen mainScreen].scale);
        _rightLayer.frame = CGRectMake((kSCREEN_WIDTH/4)*3, 7, lineWidth, self.bounds.size.height - 14);
        _rightLayer.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _rightLayer;
}

-(CAShapeLayer*)buttomLayer{
    if (!_buttomLayer) {
        _buttomLayer =[[CAShapeLayer alloc]init];
        CGFloat lineHeight = (2.0f/[UIScreen mainScreen].scale);
        _buttomLayer.frame = CGRectMake(0, 41, kSCREEN_WIDTH, lineHeight);
        _buttomLayer.backgroundColor = HexRGB(0xff9e20).CGColor;//橙色
    }
    return _buttomLayer;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    //添加分割线

    [self.totalView.layer addSublayer:self.leftLayer];
    [self.totalView.layer addSublayer:self.midleLayer];
    [self.totalView.layer addSublayer:self.rightLayer];
   // [self.totalView.layer addSublayer:self.buttomLayer];
    [self.layer addSublayer:self.buttomLayer];
    [self.total2View.layer addSublayer:self.left2layer];
    [self.total2View.layer addSublayer:self.right2Layer];
    //[self.total2View.layer addSublayer:self.buttomLayer];
    
    _textColor = [UIColor blackColor];
    _selectedTextColor = [UIColor orangeColor];
    _horIndicatorColor = HexRGB(0xff9e20);
    _horIndicatorHeight = 2;
    
    [self addHorIndicatorView];
}

#pragma mark - Public  Menthod

- (void)addHorIndicatorView
{
    UIView *horIndicatorView = [[UIView alloc]init];
    horIndicatorView.backgroundColor = _horIndicatorColor;
    [self addSubview:horIndicatorView];
    self.horIndicatorView = horIndicatorView;
    //添加切换箭头
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我的--详情 切换三角"]];
    image.bounds = CGRectMake(0, 0,12, 5);
    [self.horIndicatorView addSubview:image];
    image.translatesAutoresizingMaskIntoConstraints = NO;
    //底部约束
    [self.horIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.horIndicatorView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    //水平居中
    [self.horIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.horIndicatorView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //宽度约束
    [image addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:12]];
    //高度约束
    [image addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:5]];
}

#pragma mark - ButtonClick Menthod

- (IBAction)bottonClickMenthod:(id)sender {
    UIButton * btn = sender;
    self.selectBtnTag = btn.tag;
    self.selectBtn =btn;
    //界面跳转
    _horIndicatorView.hidden = NO;
    [self clickedPageTabBarAtIndex:(btn.tag - 1)];
   //改变水平指示器的位置
    if (self.selectBtn.tag) {
        CGRect frame = _horIndicatorView.frame;
        frame.origin.x = (kSCREEN_WIDTH/4)*(self.selectBtn.tag - 1);
        [UIView animateWithDuration:0.2 animations:^{
            _horIndicatorView.frame = frame;}];
    }else{
        CGRect frame = _horIndicatorView.frame;
        frame.origin.x = 0;
        [UIView animateWithDuration:0.2 animations:^{
            _horIndicatorView.frame = frame;
        }];
    }
    //改变字体颜色
    [self changeLabelColor];
}

- (IBAction)buttonClickedWithoutProduce:(id)sender {
    UIButton * btn = sender;
    NSLog(@"%ld",btn.tag);
    self.selectBtnTag = btn.tag - 100;
    self.selectBtn = btn;
    //界面跳转
    [self clickedPageTabBarAtIndex:(btn.tag - 101)];
    _horIndicatorView.hidden = NO;
    self.horIndicatorView.bounds = Rect(0, 0, kSCREEN_WIDTH/3, 2);
    //改变水平指示器的位置
    if (self.selectBtn.tag){
        CGRect frame = _horIndicatorView.frame;
        NSLog(@"%f",frame.origin.x);
        frame.origin.x = (kSCREEN_WIDTH/3)*(self.selectBtn.tag - 101);
        [UIView animateWithDuration:0.2 animations:^{
            _horIndicatorView.frame = frame;}];
    }else{
        CGRect frame = _horIndicatorView.frame;
        frame.origin.x = 0;
        [UIView animateWithDuration:0.2 animations:^{
            _horIndicatorView.frame = frame;
        }];
    }
    //改变字体颜色
    if (btn.tag == 101) {
        self.attentionLabel.textColor =_selectedTextColor ;
        self.attentionNumber.textColor = _selectedTextColor;
        self.fansLabel.textColor =_textColor ;
        self.fansNumber.textColor = _textColor;
        self.dynamicLabel.textColor =_textColor ;
        self.dynamicNumber.textColor = _textColor;
    }else if (btn.tag == 102){
        self.attentionLabel.textColor =_textColor ;
        self.attentionNumber.textColor = _textColor;
        self.fansLabel.textColor =_selectedTextColor ;
        self.fansNumber.textColor = _selectedTextColor;
        self.dynamicLabel.textColor =_textColor ;
        self.dynamicNumber.textColor = _textColor;
    }else if (btn.tag == 103){
        self.attentionLabel.textColor =_textColor ;
        self.attentionNumber.textColor = _textColor;
        self.fansLabel.textColor =_textColor ;
        self.fansNumber.textColor = _textColor;
        self.dynamicLabel.textColor =_selectedTextColor ;
        self.dynamicNumber.textColor = _selectedTextColor;
    }
}
/**
 *  @author cao, 15-08-20 15:08:04
 *
 *  改变按钮和标签的颜色
 */
-(void)changeLabelColor{
    switch (self.selectBtn.tag) {
        case 1:
            self.produceLabel.textColor =_selectedTextColor ;
            self.produceNumber.textColor = _selectedTextColor;
            self.attentionLabel.textColor =_textColor ;
            self.attentionNumber.textColor = _textColor;
            self.fansLabel.textColor =_textColor ;
            self.fansNumber.textColor = _textColor;
            self.dynamicLabel.textColor =_textColor ;
            self.dynamicNumber.textColor = _textColor;
            break;
        case 2:
            self.produceLabel.textColor =_textColor ;
            self.produceNumber.textColor = _textColor;
            self.attentionLabel.textColor =_selectedTextColor ;
            self.attentionNumber.textColor = _selectedTextColor;
            self.fansLabel.textColor =_textColor ;
            self.fansNumber.textColor = _textColor;
            self.dynamicLabel.textColor =_textColor ;
            self.dynamicNumber.textColor = _textColor;
            break;
        case 3:
            self.produceLabel.textColor =_textColor ;
            self.produceNumber.textColor = _textColor;
            self.attentionLabel.textColor =_textColor ;
            self.attentionNumber.textColor = _textColor;
           self.fansLabel.textColor =_selectedTextColor ;
            self.fansNumber.textColor = _selectedTextColor;
            self.dynamicLabel.textColor =_textColor ;
            self.dynamicNumber.textColor = _textColor;
            break;
        case 4:
            self.produceLabel.textColor =_textColor ;
            self.produceNumber.textColor = _textColor;
            self.attentionLabel.textColor =_textColor ;
            self.attentionNumber.textColor = _textColor;
            self.fansLabel.textColor =_textColor ;
            self.fansNumber.textColor = _textColor;
            self.dynamicLabel.textColor =_selectedTextColor ;
            self.dynamicNumber.textColor = _selectedTextColor;
            break;
        default:
            break;
    }
}

#pragma mark - SwitchScrollView method

- (void)switchToPageIndex:(NSInteger)index{
    _horIndicatorView.hidden = NO;
    _index = index;
    if (_scrollViewDidScroll) {
        _scrollViewDidScroll(_index);
    }
}

#pragma mark - LayOutSubViews Menthod
- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
