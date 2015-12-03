//
//  AW_OtherBottomInfoCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_OtherBottomInfoCell.h"
#import "AW_Constants.h"

@interface AW_OtherBottomInfoCell()
/**
 *  @author cao, 15-08-21 15:08:21
 *
 *  上部分割线
 */
@property(nonatomic,strong)CAShapeLayer* topLarer;

@end
@implementation AW_OtherBottomInfoCell

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
    [self.layer addSublayer:self.topLarer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(CGFloat)heightWithString:(NSString *)string{
    self.persondescribe.preferredMaxLayoutWidth = kSCREEN_WIDTH - 16;
    self.persondescribe.text = [NSString stringWithFormat:@"%@",string];
    [self layoutIfNeeded];
    [self.contentView layoutIfNeeded];
    [self.persondescribe sizeToFit];
    
    //计算文字高度
    NSMutableParagraphStyle * paragrafStyle = [[NSMutableParagraphStyle alloc]init];
    paragrafStyle.lineBreakMode = NSLineBreakByWordWrapping;
    self.persondescribe.lineBreakMode = NSLineBreakByWordWrapping;
    self.persondescribe.numberOfLines = 0;
    NSDictionary * fontAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    //使用字体大小来计算每一行的高度，每一行片段的起点，而不是base line的起点
    CGSize blogLabelSize = [string boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 16, CGFLOAT_MAX) options:
                            NSStringDrawingUsesLineFragmentOrigin |
                            NSStringDrawingUsesFontLeading attributes:fontAttributes context:nil].size;
    return blogLabelSize.height + 44 + 21;
}

@end
