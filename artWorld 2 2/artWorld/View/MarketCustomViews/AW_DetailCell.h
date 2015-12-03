//
//  AW_DetailCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AW_DetailCell : UITableViewCell
/**
 *  @author cao, 15-10-23 21:10:20
 *
 *  艺术品描述
 */
@property (weak, nonatomic) IBOutlet UIWebView *artDetailDescribe;
/**
 *  @author cao, 15-11-16 10:11:33
 *
 *  webView高度
 */
@property(nonatomic)CGFloat webViewHeight;
/**
 *  @author cao, 15-11-16 11:11:20
 *
 *  webView高度
 */
@property(nonatomic,copy)void(^didLoadWebView)(CGFloat height);
/**
 *  @author cao, 15-12-03 16:12:32
 *
 *  添加分割线
 *
 *  @param height webView的高度
 */
-(void)addBottomLayerWithHeight:(float)height;

@end
