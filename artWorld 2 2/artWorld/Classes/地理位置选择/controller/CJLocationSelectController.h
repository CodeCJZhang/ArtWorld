//
//  CJLocationSelectController.h
//  artWorld
//
//  Created by 张晓旭 on 15/8/31.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJLocationSelectController,CJContatc;

@protocol CJLocationSelectControllerDelegate <NSObject>

-(void)locationSelectControllerAddAddress:(CJLocationSelectController *)locationSelectController contatc:(CJContatc *)contatc;

@end

@interface CJLocationSelectController : UITableViewController

@property (nonatomic,weak) id<CJLocationSelectControllerDelegate> delegate;

//上个被选中行索引
@property (nonatomic,strong) NSIndexPath *lastIndexPath;

@end
