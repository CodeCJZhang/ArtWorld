//
//  AW_MyShopCarCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/24.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MyShopCarCell : UITableViewCell
/**
 *  @author cao, 15-08-24 18:08:52
 *
 *  艺术品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
/**
 *  @author cao, 15-08-24 18:08:20
 *
 *  艺术品名字
 */
@property (weak, nonatomic) IBOutlet UILabel *articleName;
/**
 *  @author cao, 15-08-24 18:08:38
 *
 *  艺术品描述
 */
@property (weak, nonatomic) IBOutlet UILabel *articleDescribe;
/**
 *  @author cao, 15-08-24 18:08:48
 *
 *  艺术品现在的价格
 */
@property (weak, nonatomic) IBOutlet UILabel *articlePrice;

/**
 *  @author cao, 15-08-24 18:08:26
 *
 *  艺术品的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *articleNum;
/**
 *  @author cao, 15-08-25 14:08:36
 *
 *  艺术品左侧选择按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *articleSelectBtn;
/**
 *  @author cao, 15-08-26 11:08:00
 *
 *  用来记录所属商铺名称
 */
@property(nonatomic,strong)NSString * belongStoreName;
/**
 *  @author cao, 15-08-26 11:08:21
 *
 *  用来记录在该商铺购买的第几个艺术品
 */
@property(nonatomic)NSInteger articleIndex;
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击左侧选择按钮回调
 */
@property (nonatomic,copy)void (^didClickSelectBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-08 09:09:46
 *
 *  商品索引
 */
@property (nonatomic)NSInteger index;
/**
 *  @author cao, 15-10-09 18:10:58
 *
 *  点击找相似按钮的回调
 */
@property(nonatomic,copy)void(^didClickedSimilaryBtn)(NSString * articleKind);
/**
 *  @author cao, 15-10-09 18:10:45
 *
 *  艺术品类型
 */
@property(nonatomic,copy)NSString * articleKind;
/**
 *  @author cao, 15-09-21 19:09:48
 *
 *  找相似按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *similaryBtn;

//==========================下面是编辑视图的属性============================
/**
 *  @author cao, 15-09-08 16:09:24
 *
 *  商品编辑视图
 */
@property (weak, nonatomic) IBOutlet UIView *ArticleEditeView;
/**
 *  @author cao, 15-09-09 14:09:56
 *
 *  删除艺术品的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteArticleBtn;
/**
 *  @author cao, 15-09-10 09:09:42
 *
 *  增加艺术品按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addButton;
/**
 *  @author cao, 15-09-10 09:09:08
 *
 *  减少艺术品按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
/**
 *  @author cao, 15-09-09 14:09:08
 *
 *  选种商品的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *editeArticleNum;
/**
 *  @author cao, 15-09-09 14:09:37
 *
 *  选中商品的描述
 */
@property (weak, nonatomic) IBOutlet UILabel *editeArticleDes;

/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击编辑视图删除按钮回调
 */
@property (nonatomic,copy)void (^didClickDeleteButton)(NSInteger Index);
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击编辑视图下拉按钮回调
 */
@property (nonatomic,copy)void (^didClickPullBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击编辑视图增加商品按钮回调
 */
@property (nonatomic,copy)void (^didClickAddBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击编辑视图减少商品按钮回调
 */
@property (nonatomic,copy)void (^didClickReduceBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-19 10:09:52
 *
 *  点击显示商品详情tableView的按钮的回调
 */
@property(nonatomic,copy)void(^didClickDisplayDetailBtn)(NSInteger index);
/**
 *  @author cao, 15-09-19 10:09:59
 *
 *  显示商品详情tableView的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *displayDetailBtn;

@end
