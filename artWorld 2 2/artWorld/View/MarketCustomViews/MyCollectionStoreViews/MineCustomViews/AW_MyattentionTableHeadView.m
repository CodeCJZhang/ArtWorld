//
//  AW_MyattentionTableHeadView.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/20.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyattentionTableHeadView.h"
#import "IMB_Macro.h"

@interface AW_MyattentionTableHeadView()

/**
 *  @author zhe, 15-07-15 17:07:48
 *
 *  下面分割线
 */
@property (nonatomic,strong)CAShapeLayer *buttomLayer;
@end

@implementation AW_MyattentionTableHeadView

-(CAShapeLayer*)buttomLayer{
    if (!_buttomLayer) {
        _buttomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0/[UIScreen mainScreen].scale;
        _buttomLayer.frame = CGRectMake(0, 40, kSCREEN_WIDTH, lineHeight);
        _buttomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;;
    }
    return _buttomLayer;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.layer addSublayer:self.buttomLayer];
    UIImage * btnImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    btnImage = ResizableImageDataForMode(btnImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.addAttentionBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}
#pragma mark - ButtonClick Menthod
- (IBAction)addAttentionBtn:(id)sender {
    if (_didClickAttentionBtn) {
        _didClickAttentionBtn(_index);
    }
}

@end
