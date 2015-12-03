//
//  AW_SelectPhotoView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_SelectPhotoView : UIView
/**
 *  @author cao, 15-09-28 11:09:09
 *
 *  点击照相机或相册的回调
 */
@property(nonatomic,copy)void(^didClickedCamera)(NSInteger index);
/**
 *  @author cao, 15-09-28 11:09:28
 *
 *  按钮标签
 */
@property(nonatomic)NSInteger buttonTag;

@end
