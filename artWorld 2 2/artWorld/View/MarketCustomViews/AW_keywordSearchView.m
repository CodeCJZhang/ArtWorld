//
//  AW_keywordSearchView.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/28.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_keywordSearchView.h"
#import "AW_Constants.h"

@interface AW_keywordSearchView ()

/**
 *  @author cao, 15-10-28 14:10:29
 *
 *  底部分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;

@end

@implementation AW_keywordSearchView

-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _bottomLayer.frame = Rect(0, 44, kSCREEN_WIDTH, lineHeight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.layer addSublayer:self.bottomLayer];
    UIImage *backImage = [UIImage imageNamed:@"icon_iphone_29-1"];
    backImage = ResizableImageDataForMode(backImage, 10, 10, 10, 10, UIImageResizingModeStretch);
    self.backgroundView.background = backImage;
    [self.searchTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark - ButtonClicked Menthod

- (IBAction)searchBtnClicked:(id)sender {
    _searchString = self.searchTextField.text;
    if (_didClickedSearchBtn) {
        _didClickedSearchBtn(_searchString);
    }
}

@end
