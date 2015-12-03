//
//  AW_ConnectStoreView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_MyShopCartModal.h"

@interface AW_ConnectStoreView : UIView
/**
 *  @author cao, 15-09-21 16:09:28
 *
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/**
 *  @author cao, 15-09-21 16:09:29
 *
 *  点击cell某一行的回调
 */
@property(nonatomic,copy)void(^didClickedCell)(AW_MyShopCartModal *storeModal);
/**
 *  @author cao, 15-09-21 16:09:48
 *
 *  商店名称
 */
@property(nonatomic,strong)AW_MyShopCartModal * storeModal;
/**
 *  @author cao, 15-09-21 15:09:36
 *
 *  店铺名称数组
 */
@property(nonatomic,strong)NSArray * storeNameArray;

@end
