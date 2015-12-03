//
//  AW_MycollectionStoreCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MycollectionStoreCell.h"
#import "AW_Constants.h"

@implementation AW_MycollectionStoreCell

#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    /**
     *  @author cao, 15-08-27 16:08:51
     *
     *  设置头像的圆角
     */
    self.head_Image.layer.cornerRadius = 10;
    self.head_Image.clipsToBounds = YES;
    UIImage * btnImage = [UIImage imageNamed:@"我收藏的店铺---关注背景"];
    btnImage = ResizableImageDataForMode(btnImage, 8, 8, 8, 8, UIImageResizingModeStretch);
    [self.cancleBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    //设置字体颜色
    self.storeName.textColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
}

#pragma mark - buttonClicked Menthod
- (IBAction)buttonClickedMenthod:(id)sender {
    UIButton * btn = sender;
    _btnIndex = btn.tag;
    if (_didClickCellBtn) {
        _didClickCellBtn(_btnIndex);
    }
}

- (IBAction)talkAndCanleBtnClicked:(id)sender {
    UIButton * btn = sender;
    _btnIndex = btn.tag;
    if (_didClickTalkAndCancleBtn) {
        _didClickTalkAndCancleBtn(_btnIndex,_storeId);
    }
}

#pragma mark - HeightForStroeName Menthod
-(float)heightForStoreName:(NSString*)shopName{
    NSString * tmpStoreName;
    if (shopName) {
        if (shopName.length > 20) {
            tmpStoreName = [shopName substringToIndex:20];
        }else{
            tmpStoreName = shopName;
        }
    }
    
    self.storeName.preferredMaxLayoutWidth = kSCREEN_WIDTH - 146;
    self.storeName.text = tmpStoreName;
    //计算文字高度
    NSMutableParagraphStyle * paragrafStyle = [[NSMutableParagraphStyle alloc]init];
    paragrafStyle.lineBreakMode = NSLineBreakByWordWrapping;
    self.storeName.lineBreakMode = NSLineBreakByWordWrapping;
    self.storeName.numberOfLines = 0;
    NSDictionary * fontAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    //使用字体大小来计算每一行的高度，每一行片段的起点，而不是base line的起点
    CGSize LabelSize = [tmpStoreName boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 146, CGFLOAT_MAX) options:
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading attributes:fontAttributes context:nil].size;
    [self.storeName sizeToFit];
    [self layoutIfNeeded];
    [self.contentView layoutIfNeeded];
    return LabelSize.height;
}

@end
