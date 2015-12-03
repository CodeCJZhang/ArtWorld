//
//  AW_SelectColorView.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/25.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_SelectColorView : UIView

/**
 *  @author cao, 15-10-25 11:10:37
 *
 *  艺术品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *artImage;
/**
 *  @author cao, 15-10-25 11:10:48
 *
 *  艺术品描述
 */
@property (weak, nonatomic) IBOutlet UILabel *artDescribe;
/**
 *  @author cao, 15-10-25 11:10:49
 *
 *  选中按钮后的回调
 */
@property(nonatomic,copy)void(^didClickedBtns)(NSInteger index);
/**
 *  @author cao, 15-11-26 16:11:02
 *
 *  点击颜色按钮的回调
 */
@property(nonatomic,copy)void(^clickedColorBtnCell)(NSString * color);

/**
 *  @author cao, 15-10-25 12:10:02
 *
 *  按钮标签
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-11-26 16:11:40
 *
 *  获取颜色数组
 *
 *  @param colorArray 颜色数组
 */
-(void)setColorArray:(NSArray *)colorArray;

@end
