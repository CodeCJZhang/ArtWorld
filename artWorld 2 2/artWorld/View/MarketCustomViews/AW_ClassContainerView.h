//
//  AW_ClassContainerView.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ClassContainerView : UIView

/**
 *  @author cao, 15-10-26 17:10:59
 *
 *  点击收起按钮的回调
 */
@property(nonatomic,copy)void(^didClickedButton)();

@end
