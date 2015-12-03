//
//  AW_Artifact.h
//  artWorld
//
//  Created by 张亚哲 on 15/7/9.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @author zhe, 15-07-09 17:07:13
 *
 *  手工艺品
 */
@interface AW_Artifact : NSObject

/**
 *  @author zhe, 15-07-09 17:07:56
 *
 *  图片地址
 */
@property (nonatomic,copy)NSString *imageUrl;

/**
 *  @author zhe, 15-07-09 17:07:55
 *
 *  价格
 */
@property (nonatomic,copy)NSString *price;

/**
 *  @author zhe, 15-07-09 17:07:26
 *
 *  图片宽度
 */
@property (nonatomic,assign)float imageWidth;
/**
 *  @author zhe, 15-07-09 17:07:04
 *
 *  图片高度
 */
@property (nonatomic,assign)float imageHeight;

/**
 *  @author zhe, 15-07-09 17:07:44
 *
 *  产品描述
 */
@property (nonatomic,copy)NSString *describ;

/**
 *  @author zhe, 15-07-09 17:07:52
 *
 *  collectionviewcell size
 */
@property (nonatomic,assign)CGSize size;

#warning test
/**
 *  @author zhe, 15-07-09 17:07:49
 *
 *  测试图片
 */
@property (nonatomic,strong)UIImage *goodImage;

@end
