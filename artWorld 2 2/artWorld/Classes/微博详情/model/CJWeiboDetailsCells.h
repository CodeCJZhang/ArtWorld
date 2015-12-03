//
//  CJWeiboDetailsCells.h
//  artWorld
//
//  Created by 张晓旭 on 15/9/23.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJParameter;

@interface CJWeiboDetailsCells : UITableViewCell

//行高
//@property (nonatomic,assign) CGFloat cellHeight;

-(CJWeiboDetailsCells *)createCellWithParameter:(CJParameter *)cellParameter;

@end
