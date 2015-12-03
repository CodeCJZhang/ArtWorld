//
//  AW_SimalaryProduceCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author cao, 15-10-23 17:10:21
 *
 *  相似产品cell
 */
@interface AW_SimalaryProduceCell : UITableViewCell

/**
 *  @author cao, 15-10-23 17:10:34
 *
 *  相似艺术品collectionView
 */
@property (weak, nonatomic) IBOutlet UICollectionView *similaryCollectionView;
/**
 *  @author cao, 15-10-25 15:10:57
 *
 *  点击相似艺术品的回调
 */
@property(nonatomic,copy)void(^didClickSimilaryCell)(NSInteger index);
/**
 *  @author cao, 15-10-23 17:10:33
 *
 *  相似艺术品数组
 */
@property(nonatomic,strong)NSArray * similaryArray;
/**
 *  @author cao, 15-10-25 15:10:56
 *
 *  进行赋值
 *
 *  @param similaryArr
 */
-(void)setKindArr:(NSArray *)similaryArr;

@end
