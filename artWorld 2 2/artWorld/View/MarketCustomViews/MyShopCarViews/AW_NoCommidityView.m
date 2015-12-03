//
//  AW_NoCommidityView.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_NoCommidityView.h"
#import "AW_Constants.h"

@interface AW_NoCommidityView()
/**
 *  @author cao, 15-10-15 10:10:27
 *
 *  提示文本信息
 */
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
/**
 *  @author cao, 15-10-15 10:10:37
 *
 *  随便逛逛按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *StrollBtn;


@end

@implementation AW_NoCommidityView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.textLabel.textColor = HexRGB(0x88c244);
    self.StrollBtn.layer.cornerRadius = 4.0;
    self.StrollBtn.clipsToBounds = YES;
}

#pragma mark - ButtonClicked Menthod

- (IBAction)buttonClicked:(id)sender {
    if (_didClickedStrollBtn) {
        _didClickedStrollBtn();
    }
}

@end
