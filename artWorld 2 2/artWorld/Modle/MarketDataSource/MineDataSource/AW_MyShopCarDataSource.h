//
//  AW_MyShopCarDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_MyShopCarFootView.h"
#import "AW_MyShopCartModal.h"
/**
 *  @author cao, 15-08-25 14:08:29
 *
 *  我的购物车数据源
 */
@interface AW_MyShopCarDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-11-06 09:11:18
 *
 *  记录艺术品的总数
 */
@property(nonatomic,copy)NSString * totalNum;
/**
 *  @author cao, 15-09-09 17:09:50
 *
 *  商铺索引
 */
@property(nonatomic,strong)NSMutableArray * storeIndexArray;
/**
 *  @author cao, 15-10-30 17:10:25
 *
 *  请求成功后的回调
 */
@property(nonatomic,copy)void(^requestSucess)(NSInteger  invaluteNum);
/**
 *  @author cao, 15-09-08 12:09:01
 *
 *  失效艺术品的数量
 */
@property(nonatomic)NSInteger invalidArticleNumber;
/**
 *  @author cao, 15-09-08 12:09:38
 *
 *  用来记录失效的艺术品数组
 */
@property(nonatomic,strong)NSMutableArray * invalidArticleArray;
/**
 *  @author cao, 15-09-08 15:09:42
 *
 *  用来记录艺术品所属商铺cell的索引
 */
@property(nonatomic)NSInteger storeIndex;
/**
 *  @author cao, 15-09-08 17:09:49
 *
 *  所有的商铺索引数组
 */
@property(nonatomic,strong)NSMutableArray * allStoreIndexArray;
/**
 *  @author cao, 15-09-08 17:09:02
 *
 *  用于记录选中的storecell的modal的临时数组
 */
@property(nonatomic,strong)NSMutableArray * tmpArray;
/**
 *  @author cao, 15-09-08 17:09:17
 *
 *  用于记录选中的articleCell的modal的临时数组
 */
@property(nonatomic,strong)NSMutableArray * articleTmpArray;
/**
 *  @author cao, 15-09-08 19:09:50
 *
 *  用来记录进入编辑状态后的艺术品cellModal
 */
@property(nonatomic,strong)NSMutableArray * editeIndexArray;
/**
 *  @author cao, 15-09-08 19:09:58
 *
 *  用来记录进入编辑状态的商铺modal数组
 */
@property(nonatomic,strong)NSMutableArray * editeStoreArray;
/**
 *  @author cao, 15-09-09 15:09:43
 *
 *  用来记录全部商铺的名称（用来获取商铺cell的个数）
 */
@property(nonatomic,strong)NSMutableArray * allStoreArray;
/**
 *  @author cao, 15-09-08 12:09:52
 *
 *  获得测试数据
 */
-(void)getTextData;
/**
 *  @author cao, 15-09-11 09:09:32
 *
 *  选中艺术品的总价格
 */
@property(nonatomic)float totalPrice;
/**
 *  @author cao, 15-09-09 15:09:35
 *
 *  和controller关联的底部视图
 */
@property(nonatomic,strong)AW_MyShopCarFootView * FootView;
/**
 *  @author cao, 15-09-10 10:09:08
 *
 *  点击商铺cell右侧编辑按钮(存入编辑状态的艺术品cellModal)
 */
@property(nonatomic,strong)NSMutableArray * editeArray;

/**
 *  @author cao, 15-09-10 10:09:29
 *
 *  用来记录进入编辑状态后的艺术品数量
 */
@property(nonatomic)NSInteger everyArticleNum;
/**
 *  @author cao, 15-09-19 14:09:18
 *
 *  点击详情按钮后的回调
 */
@property(nonatomic,copy)void(^didClickDetailBtn)(AW_MyShopCartModal *articleModaal);
/**
 *  @author cao, 15-10-09 18:10:51
 *
 *  商品价格
 */
@property(nonatomic)float tmpPrice;
/**
 *  @author cao, 15-10-09 19:10:28
 *
 *  点击找相似商品按钮的回调
 */
@property(nonatomic,copy)void(^didClickSimilaryBtn)(NSString * similary_id);
/**
 *  @author cao, 15-10-14 21:10:06
 *
 *  用来记录失效商品的数量
 */
@property(nonatomic,copy)NSString*  invaluteArticleNum;
/**
 *  @author cao, 15-10-15 11:10:42
 *
 *  商品数量为0时进行的回调
 */
@property(nonatomic,copy)void(^noneCommidity)();
/**
 *  @author cao, 15-10-30 17:10:00
 *
 *  点击艺术品的回调
 */
@property(nonatomic,copy)void(^didClickedArtCell)(NSString * art_id);
/**
 *  @author cao, 15-10-30 17:10:03
 *
 *  艺术品id
 */
@property(nonatomic,copy)NSString * art_id;
/**
 *  @author cao, 15-10-30 21:10:41
 *
 *  失效艺术品id
 */
@property(nonatomic,copy)NSString * similary_id;
/**
 *  @author cao, 15-10-31 15:10:17
 *
 *  用来记录颜色
 */
@property(nonatomic,copy)NSMutableDictionary * colorDictionary;
/**
 *  @author cao, 15-11-17 22:11:11
 *
 *  请求成功后的回调
 */
@property(nonatomic,copy)void(^didrequestSucess)(NSString * totalArt ,NSString * invaluteArt);

@end
