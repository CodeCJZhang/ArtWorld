//
//  AW_DescribeLabelCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/19.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_DescribeLabelCell.h"
#import "AW_Constants.h"

@interface AW_DescribeLabelCell()

@end
@implementation AW_DescribeLabelCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - CellHeight 
-(CGFloat)labelHeightWith:(NSString *)describeString{
    self.detailLabel.preferredMaxLayoutWidth = kSCREEN_WIDTH - 16;
    self.detailLabel.text = describeString;
    NSMutableParagraphStyle * paragrafStyle = [[NSMutableParagraphStyle alloc]init];
    paragrafStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGSize labelSize = [describeString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 16, 999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return labelSize.height;
}

@end
