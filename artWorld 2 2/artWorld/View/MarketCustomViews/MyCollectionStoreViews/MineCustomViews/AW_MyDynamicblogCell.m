//
//  AW_MyDynamicblogCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyDynamicblogCell.h"
#import "AW_Constants.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface AW_MyDynamicblogCell()
/**
 *  @author cao, 15-09-24 09:09:31
 *
 *  图片到日期之间的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageToDateConstraint;
/**
 *  @author cao, 15-09-24 09:09:52
 *
 *  图片顶部到label的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageToLabelConstaint;
/**
 *  @author cao, 15-09-21 22:09:45
 *
 *  到第三行图片的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeContraint;
/**
 *  @author cao, 15-09-21 22:09:03
 *
 *  到第二行图片的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoConstraint;
/**
 *  @author cao, 15-09-21 22:09:17
 *
 *  到第一行图片的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneContraint;
/**
 *  @author cao, 15-09-21 22:09:30
 *
 *  到文本框的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zeroConstraint;
/**
 *  @author cao, 15-09-21 22:09:11
 *
 *  到定位地址的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourWithoutAdressContraint;
/**
 *  @author cao, 15-09-21 22:09:54
 *
 *  没有定位地址到第三行图片的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeWithoutAdressConstraint;
/**
 *  @author cao, 15-09-21 22:09:22
 *
 *  没有定位地址到第二行图片的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoWithoutAdressConstraint;
/**
 *  @author cao, 15-09-21 22:09:50
 *
 *  没有定位地址到第一行图片的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneWithoutAdressConstraint;
/**
 *  @author cao, 15-09-21 22:09:10
 *
 *  没有定位地址到文本框的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zeroWithoutAdressConstraint;
/**
 *  @author zhe, 15-07-15 17:07:48
 *
 *  下面分割线
 */
@property (nonatomic,strong)CAShapeLayer *buttomSepartor;

/**
 *  @author zhe, 15-07-15 17:07:14
 *
 *  左边分割线
 */
@property (nonatomic,strong)CAShapeLayer *leftSepartor;
/**
 *  @author zhe, 15-07-15 17:07:40
 *
 *  右边分割线
 */
@property (nonatomic,strong)CAShapeLayer *rightSepartor;
/**
 *  @author cao, 15-09-21 23:09:38
 *
 *  显示定位地址的view
 */
@property (weak, nonatomic) IBOutlet UIView *adressView;
/**
 *  @author cao, 15-10-16 23:10:21
 *
 *  赞图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *praisedImageView;

@end

@implementation AW_MyDynamicblogCell

#pragma mark - Separator Menthod
-(CAShapeLayer*)leftSepartor{
    if (!_leftSepartor) {
        _leftSepartor = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = (1.0f/[UIScreen mainScreen].scale);
        _leftSepartor.frame = CGRectMake(((kSCREEN_WIDTH-16)/3)+4+2, 7, lineWidth, _bottomLayer.frame.size.height-14);
        _leftSepartor.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _leftSepartor;
}

-(CAShapeLayer*)rightSepartor{
    if (!_rightSepartor) {
        _rightSepartor = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = (1.0f/[UIScreen mainScreen].scale);
        _rightSepartor.frame = CGRectMake(((kSCREEN_WIDTH-16)/3)*2+10, 7, lineWidth, _bottomLayer.frame.size.height-14);
        _rightSepartor.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _rightSepartor;
}

-(CAShapeLayer*)buttomSepartor{
    if (!_buttomSepartor) {
        _buttomSepartor = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = (1.0f/[UIScreen mainScreen].scale);
        _buttomSepartor.frame = CGRectMake(0, 0, kSCREEN_WIDTH, lineHeight);
        _buttomSepartor.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _buttomSepartor;
}

#pragma mark - Public Menthod

/**
 *  @author cao, 15-09-22 14:09:56
 *
 *  对图片进行处理
 *
 *  @param imageArray 图片数组
 *  @param isShow     定位地址
 */

-(void)hasText:(NSString*)text ImageArray:(NSArray *)imageArray showAdress:(BOOL)isShow{
    NSInteger imageCount = imageArray.count;
    if (text) {
        _blogContent.hidden = NO;
        self.imageToDateConstraint.priority = 998;
        if (self.imageToLabelConstaint.priority != 999) {
            self.imageToLabelConstaint.priority = 999;
        }
    }else{
        _blogContent.hidden = YES;
        self.imageToLabelConstaint.priority = 998;
        if (self.imageToDateConstraint.priority != 999) {
            self.imageToDateConstraint.priority = 999;
        }
    }
    
 if (isShow == YES) {
     self.adressView.hidden = NO;
    if (imageCount > 6 && imageCount < 10) {
            self.zeroConstraint.priority = 996;
            self.oneContraint.priority = 997;
            self.twoConstraint.priority = 998;
            if (self.threeContraint.priority != 999){
                self.threeContraint.priority = 999;
         }
     }else if (imageCount > 3 && imageCount < 7){
        self.zeroConstraint.priority = 997;
        self.oneContraint.priority = 998;
        self.threeContraint.priority = 996;
        if (self.twoConstraint.priority != 999) {
            self.twoConstraint.priority = 999;
           }
     }else if (imageCount > 0 && imageCount < 4){
        self.zeroConstraint.priority = 998;
        self.twoConstraint.priority = 997;
        self.threeContraint.priority = 996;
        if (self.oneContraint.priority != 999) {
            self.oneContraint.priority = 999;
           }
     }else{
         self.oneContraint.priority = 998;
         self.twoConstraint.priority = 997;
         self.threeContraint.priority = 996;
         if (self.zeroConstraint.priority != 999) {
             self.zeroConstraint.constant = 999;
         }
    }
 }else{
    //如果没有地址定位,将地址定位视图隐藏
     self.adressView.hidden = YES;
     if (imageCount > 6 && imageCount < 10) {
         self.zeroWithoutAdressConstraint.priority = 996;
         self.oneWithoutAdressConstraint.priority = 997;
         self.twoWithoutAdressConstraint.priority = 998;
         self.fourWithoutAdressContraint.priority = 995;
         if (self.threeWithoutAdressConstraint.priority != 999) {
             self.threeWithoutAdressConstraint.priority = 999;
         }
     }else if (imageCount > 3 && imageCount < 7){
         self.zeroWithoutAdressConstraint.priority = 997;
         self.oneWithoutAdressConstraint.priority = 998;
         self.threeWithoutAdressConstraint.priority = 996;
         self.fourWithoutAdressContraint.priority = 995;
         if (self.twoWithoutAdressConstraint.priority != 999) {
             self.twoWithoutAdressConstraint.priority = 999;
         }
     }else if (imageCount > 0 && imageCount < 4){
         self.zeroWithoutAdressConstraint.priority = 998;
         self.threeWithoutAdressConstraint.priority = 997;
         self.twoWithoutAdressConstraint.priority = 996;
         self.fourWithoutAdressContraint.priority = 995;
         if (self.oneWithoutAdressConstraint.priority != 999) {
             self.oneWithoutAdressConstraint.priority = 999;
         }
     }else{
         self.oneWithoutAdressConstraint.priority = 998;
         self.twoWithoutAdressConstraint.priority = 997;
         self.threeWithoutAdressConstraint.priority = 996;
         self.fourWithoutAdressContraint.priority = 995;
         if (self.zeroWithoutAdressConstraint.priority != 999) {
             self.zeroWithoutAdressConstraint.priority = 999;
         }
     }
 }
    //将没有图片的button隐藏
    [self.ImageViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = obj;
        if (idx < imageCount) {
            button.hidden = NO;
        }else{
            button.hidden = YES;
        }
    }];
}

/**
 *  @author cao, 15-08-17 18:08:31
 *
 *  加载数据
 *
 *  @param dynamicModal 我的动态模型
 */
-(void)configDataWithDynamicModal:(AW_MicroBlogListModal *)dynamicModal{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dynamicModal.userModal.head_img]placeholderImage:PLACE_HOLDERIMAGE];
    if (dynamicModal.userModal.isVerified == YES) {
        self.vipImage.hidden = NO;
    }else{
        self.vipImage.hidden = YES;
    }
    if (dynamicModal.isPraised == YES) {
        self.praisedImageView.image = [UIImage imageNamed:@"赞-空"];
    }else{
        self.praisedImageView.image = [UIImage imageNamed:@"收藏"];
    }
    _blogerName.text = dynamicModal.userModal.nickname;
    _publicDate.text = dynamicModal.create_time;
    _blogContent.text = dynamicModal.microBlog_Content;
    //判断一下图片数量只有小于10时才走下面的方法,不然的话一直崩溃
    if (dynamicModal.imageArray.count < 10) {
        for (int i  =0; i < dynamicModal.imageArray.count; i++) {
            UIButton * button = _ImageViewArray[i];
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:dynamicModal.imageArray[i]] forState:UIControlStateNormal placeholderImage:PLACE_HOLDERIMAGE];
        }
    }
}

#pragma mark - Private Menthod
- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius = 10.0f;
    self.headImageView.clipsToBounds = YES;
    //添加灰色分割线
    [self.bottomLayer.layer addSublayer:self.buttomSepartor];
    [self.bottomLayer.layer addSublayer:self.leftSepartor];
    [self.bottomLayer.layer addSublayer:self.rightSepartor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClickedMenthod:(id)sender {
    UIButton * btn = sender;
    _buttonTag = btn.tag;
    if (_didClickedBtns) {
        _didClickedBtns(_buttonTag);
    }
}

- (IBAction)imageBtnClicked:(id)sender {
    UIButton*btn = sender;
    _imageBtnTag = btn.tag;
    if (_didClickedImageBtns) {
        _didClickedImageBtns(_imageBtnTag);
    }
}

@end
