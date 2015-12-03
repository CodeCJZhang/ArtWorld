//
//  AW_MyShopCarDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyShopCarDataSource.h"
#import "AW_MyShopCarCell.h"
#import "AW_ArticleStoreCell.h"
#import "AW_MyShopCartModal.h"
#import "UIImageView+WebCache.h"
#import "AW_MyShopCarFootView.h"
#import "SVProgressHUD.h"
#import "AW_DeleteAlertMessage.h" //删除商品提示alertView
#import "DeliveryAlertView.h"
#import "AFNetworking.h"
#import "AW_Constants.h"

@interface AW_MyShopCarDataSource()
/**
 *  @author cao, 15-08-26 11:08:43
 *
 *  用来记录选中的商店名称(点击左侧选中按钮)
 */
@property(nonatomic,copy)NSString * selectStoreName;
/**
 *  @author cao, 15-09-11 11:09:32
 *
 *  存储编辑状态之前的价格
 */
@property(nonatomic)float editeTmpPrice;
/**
 *  @author cao, 15-11-24 21:11:36
 *
 *  临时的运费（用来计算总运费）
 */
@property(nonatomic)float tmpfreight;

@property(nonatomic,strong)NSMutableArray * storeEditeIndexArray;

@end
@implementation AW_MyShopCarDataSource

#pragma mark - Private Menthod

-(NSMutableDictionary*)colorDictionary{
    if (!_colorDictionary) {
        _colorDictionary = [NSMutableDictionary dictionary];
    }
    return _colorDictionary;
}

-(NSMutableArray *)storeEditeIndexArray{
    if (!_storeEditeIndexArray) {
        _storeEditeIndexArray = [[NSMutableArray alloc]init];
    }
    return _storeEditeIndexArray;
}
-(NSMutableArray*)editeArray{
    if (!_editeArray) {
        _editeArray = [[NSMutableArray alloc]init];
    }
    return _editeArray;
}

-(NSMutableArray*)invalidArticleArray{
    if (!_invalidArticleArray) {
        _invalidArticleArray = [[NSMutableArray alloc]init];
    }
    return _invalidArticleArray;
}

-(NSMutableArray*)allStoreIndexArray{
    if (_allStoreIndexArray) {
        _allStoreIndexArray = [[NSMutableArray alloc]init];
    }
    return _allStoreIndexArray;
}

-(NSMutableArray*)tmpArray{
    if (!_tmpArray) {
        _tmpArray = [[NSMutableArray alloc]init];
    }
    return _tmpArray;
}

-(NSMutableArray*)articleTmpArray{
    if (!_articleTmpArray) {
        _articleTmpArray = [[NSMutableArray alloc]init];
    }
    return _articleTmpArray;
}

-(NSMutableArray*)editeIndexArray{
    if (!_editeIndexArray) {
        _editeIndexArray = [[NSMutableArray alloc]init];
    }
    return _editeIndexArray;
}

-(NSMutableArray*)editeStoreArray{
    if (!_editeStoreArray) {
        _editeStoreArray = [[NSMutableArray alloc]init];
    }
    return _editeStoreArray;
}
-(NSMutableArray*)allStoreArray{
    if (!_allStoreArray) {
        _allStoreArray = [[NSMutableArray alloc]init];
    }
    return _allStoreArray;
}

-(NSMutableArray*)storeIndexArray{
    if (!_storeIndexArray) {
        _storeIndexArray = [[NSMutableArray alloc]init];
        [self.dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AW_MyShopCartModal * modal = obj;
            if (modal.storeModal.shop_Name) {
                AW_MyShopCartModal * storeModal  = obj;
                if (![_storeIndexArray containsObject:storeModal]) {
                    [_storeIndexArray addObject:storeModal];
                }
            }
        }];
    }
    return _storeIndexArray;
}

#pragma mark - GetData Menthod
-(void)getTextData{
    //添加提示信息
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    __weak typeof(self) weakSelf = self;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [userDefault objectForKey:@"user_id"];
    NSDictionary * dict = @{@"userId":user_id};
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary * shopDict = @{@"param":@"getShoppingCartCD",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:shopDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"message"]);
        self.totalNum = [responseObject[@"info"]valueForKey:@"totalNumber"];
        //记录失效商品的数量
        if (![[responseObject[@"info"]valueForKey:@"invalidNum"]isEqual:@""]){
           self.invaluteArticleNum = [responseObject[@"info"]valueForKey:@"invalidNum"];
        }
        NSArray * dataArray = [responseObject[@"info"]valueForKey:@"data"];
        NSLog(@"%@",dataArray);
        if ([responseObject[@"code"]intValue] == 0){
            //请求成功后调用
            if (_didrequestSucess) {
                _didrequestSucess(self.totalNum,self.invaluteArticleNum);
            }
            if (dataArray.count > 0) {
                [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary * storeDict = obj;
                    if (![storeDict isKindOfClass:[NSNull class]]) {
                        //插入分割线
                        AW_MyShopCartModal * separate = [[AW_MyShopCartModal alloc]init];
                        separate.isSeparate = YES;
                        separate.rowHeight = kMarginBetweenCompontents;
                        [weakSelf.dataArr addObject:separate];
                        //插入店铺modal
                        AW_MyShopCartModal * modal = [[AW_MyShopCartModal alloc]init];
                        AW_StoreModal * storeModal = [[AW_StoreModal alloc]init];
                        storeModal.shop_Id = storeDict[@"id"];
                        storeModal.shop_Name = storeDict[@"name"];
                        storeModal.shoper_IM_Id = storeDict[@"phone"];
                        modal.storeModal = storeModal;
                        modal.subArray = [[NSMutableArray alloc]init];
                        [weakSelf.dataArr addObject:modal];
                        //记录所有的商铺名称
                        [self.allStoreArray addObject:modal];
                        
                        NSMutableArray * tmp = [[NSMutableArray alloc]init];
                        [storeDict[@"arts"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * commidityDict = obj;
                            //插入商品modal
                            AW_MyShopCartModal * commidityModal = [[AW_MyShopCartModal alloc]init];
                            AW_CommodityModal * articleModal = [[AW_CommodityModal alloc]init];
                            articleModal.commodity_Id = commidityDict[@"commodity_id"];
                            NSLog(@"%@",articleModal.commodity_Id);
                            articleModal.shopCart_id = commidityDict[@"id"];
                            articleModal.clearImageURL = commidityDict[@"clear_img"];
                            articleModal.fuzzyImageURL = commidityDict[@"fuzzy_img"];
                            articleModal.commodity_Name = commidityDict[@"name"];
                            articleModal.commodityNumber = commidityDict[@"num"];
                            articleModal.commodityPrice = commidityDict[@"price"];
                            articleModal.commodity_color = commidityDict[@"commodity_attr"];
                            articleModal.all_colors = commidityDict[@"color"];
                            articleModal.isInvalid = @"NO";
                            articleModal.belongStoreName = storeDict[@"name"];
                            articleModal.belongSrote_id = storeDict[@"id"];
                            articleModal.commidity_freight = commidityDict[@"freight"];
                            
                            if (!storeModal.shoper_id) {
                                storeModal.shoper_id = commidityDict[@"user_id"];
                            }
                            commidityModal.commodityModal = articleModal;
                            [modal.subArray addObject:commidityModal];
                            [weakSelf.dataArr addObject:commidityModal];
                        }];
                        
                    }
                }];
            }
            
            //插入失效的艺术品
            [[responseObject[@"info"]valueForKey:@"dataInvalid"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * invaluteDict = obj;
                if (![invaluteDict isKindOfClass:[NSNull class]]) {
                    //插入分割线
                    AW_MyShopCartModal * separate = [[AW_MyShopCartModal alloc]init];
                    separate.isSeparate = YES;
                    separate.rowHeight = kMarginBetweenCompontents;
                    [weakSelf.dataArr addObject:separate];
                    //插入失效的商品
                    AW_MyShopCartModal * invaluteModal = [[AW_MyShopCartModal alloc]init];
                    AW_CommodityModal * commidityModal = [[AW_CommodityModal alloc]init];
                    commidityModal.commodity_Id = invaluteDict[@"commodity_id"];
                    commidityModal.clearImageURL = invaluteDict[@"clear_img"];
                    commidityModal.fuzzyImageURL = invaluteDict[@"fuzzy_img"];
                    commidityModal.commodity_Name = invaluteDict[@"name"];
                    commidityModal.shopCart_id = invaluteDict[@"id"];
                    commidityModal.invalidReason = invaluteDict[@"invalidReason"];
                    commidityModal.isInvalid = @"YES";
                    invaluteModal.commodityModal = commidityModal;
                    //将失效商品插入失效数组
                    [self.invalidArticleArray addObject:invaluteModal];
                    [weakSelf.dataArr addObject:invaluteModal];
                }
            }];
            //插入分割线
            AW_MyShopCartModal * tmpSeparate = [[AW_MyShopCartModal alloc]init];
            tmpSeparate.isSeparate = YES;
            tmpSeparate.rowHeight = kMarginBetweenCompontents;
            [weakSelf.dataArr addObject:tmpSeparate];
            [SVProgressHUD dismiss];
             [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
}

#pragma mark - UItableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyShopCartModal * modal = self.dataArr[indexPath.row];
    if (modal.isSeparate == YES) {
        return [self configSeparateCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if([modal.commodityModal.isInvalid isEqualToString:@"YES"]){
        return [self configInvalidCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if([modal.commodityModal.isInvalid isEqualToString:@"NO"]){
        return [self configArticleCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else{
        return [self configArticleStoredCellWithModal:modal tableView:tableView indexPath:indexPath];
     }
}
#pragma mark - UITableViewDelegate  Menthod

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AW_MyShopCartModal * modal = self.dataArr[indexPath.row];
    if (modal.isSeparate == YES) {
        return 8;
    }else if(modal.isSeparate == NO && [modal.commodityModal.isInvalid isEqualToString:@"YES"]){
        return 96;
    }else if(modal.isSeparate == NO && [modal.commodityModal.isInvalid isEqualToString:@"NO"]){
        return 88;
    }else{
        return 42;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyShopCartModal * modal = self.dataArr[indexPath.row];
    if ([modal.commodityModal.isInvalid isEqualToString:@"NO"]) {
        _art_id = modal.commodityModal.commodity_Id;
        if (_didClickedArtCell) {
            _didClickedArtCell(_art_id);
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
//==================↓点击底部视图全选按钮方法↓============
    self.FootView.didClickSelectBtn = ^(NSInteger index){
        weakSelf.FootView.selectBtn.selected = !weakSelf.FootView.selectBtn.selected;
        if (self.FootView.selectBtn.selected == YES) {
            //点击全选按钮时，首先将艺术品的总价格设置为0;
            weakSelf.totalPrice = 0;
            [weakSelf.storeIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                AW_MyShopCartModal * storeModal = obj;
                //将商铺modal存入数组
                if (![weakSelf.tmpArray containsObject:storeModal]) {
                    [weakSelf.tmpArray addObject:storeModal];
                }
                NSInteger storeIndex = [weakSelf.dataArr indexOfObject:storeModal];
                AW_ArticleStoreCell * cell1 = (AW_ArticleStoreCell*)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:storeIndex inSection:0]];
                cell1.storeSelectBtn.selected = YES;
                [storeModal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSIndexPath * path = [NSIndexPath indexPathForRow:storeIndex inSection:0];
                    NSIndexPath * articlePath = [NSIndexPath indexPathForRow:path.row + idx + 1 inSection:0];
                    //将艺术品modal存入数组
                    AW_MyShopCartModal * cellModal = obj;
                    if (![weakSelf.articleTmpArray containsObject:cellModal]) {
                        [weakSelf.articleTmpArray addObject:cellModal];
                    }
                    AW_MyShopCarCell * articlecell = (AW_MyShopCarCell*)[weakSelf.tableView cellForRowAtIndexPath:articlePath];
                    articlecell.articleSelectBtn.selected = YES;
                //改变底部footView显示的艺术品总价格
                    float  tmpPrice = [cellModal.commodityModal.commodityPrice floatValue]*[cellModal.commodityModal.commodityNumber integerValue];
                    weakSelf.totalPrice = self.totalPrice + tmpPrice;
                    weakSelf.FootView.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",weakSelf.totalPrice];
                }];
            }];
        }else if (self.FootView.selectBtn.selected == NO){
            [weakSelf.storeIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                AW_MyShopCartModal * storeModal = obj;
                //将商铺modal存入数组
                [weakSelf.tmpArray removeObject:storeModal];
                NSInteger storeIndex = [weakSelf.dataArr indexOfObject:storeModal];
                AW_ArticleStoreCell * cell1 = (AW_ArticleStoreCell*)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:storeIndex inSection:0]];
                cell1.storeSelectBtn.selected = NO;
                [storeModal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                     NSIndexPath * path = [NSIndexPath indexPathForRow:storeIndex inSection:0];
                    NSIndexPath * articlePath = [NSIndexPath indexPathForRow:path.row + idx + 1 inSection:0];
                    //将艺术品索引存入数组
                    AW_MyShopCartModal * cellModal = obj;
                    [weakSelf.articleTmpArray removeObject:cellModal];
                    AW_MyShopCarCell * articlecell = (AW_MyShopCarCell*)[weakSelf.tableView cellForRowAtIndexPath:articlePath];
                    articlecell.articleSelectBtn.selected = NO;
                    //改变footView的显示艺术品的总价格
                    float  tmpPrice = [cellModal.commodityModal.commodityPrice floatValue]*[cellModal.commodityModal.commodityNumber integerValue];
                    weakSelf.totalPrice = self.totalPrice - tmpPrice;
                    weakSelf.FootView.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",weakSelf.totalPrice];
                }];
            }];
        }
    };
}

#pragma mark - ConfigUITableViewCell  Menthod
-(AW_MyShopCarCell*)configArticleCellWithModal:(AW_MyShopCartModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
   static NSString * cellId = @"articleCell";
    AW_MyShopCarCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AW_MyShopCarCell" owner:self options:nil][0];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //判断网络状态和是否开启了省流量模式
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"patternState"]isEqualToString:@"yes"]&&[[user objectForKey:@"NetState"]isEqualToString:@"切换到WWAN网络"]) {
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commodityModal.fuzzyImageURL] placeholderImage:PLACE_HOLDERIMAGE];
    }else{
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commodityModal.clearImageURL] placeholderImage:PLACE_HOLDERIMAGE];
    }

    NSLog(@"===%@===",modal.commodityModal.commodity_Name);
    cell.articleName.text = [NSString stringWithFormat:@"%@",modal.commodityModal.commodity_Name];
    cell.articleDescribe.text = [NSString stringWithFormat:@"%@",modal.commodityModal.commodity_color];
    cell.articlePrice.text = [NSString stringWithFormat:@"￥%.2f",modal.commodityModal.commodityPrice.floatValue];
    cell.articleNum.text = [NSString stringWithFormat:@"%@",modal.commodityModal.commodityNumber];
    cell.belongStoreName = [NSString stringWithFormat:@"%@",modal.commodityModal.belongStoreName];
   
    cell.editeArticleDes.text = [NSString stringWithFormat:@"%@",modal.commodityModal.commodity_color];
    
//============↓如果数组中包含modal就让选择按钮显示选中状态↓==============
    if ([self.articleTmpArray containsObject:modal]){
        cell.articleSelectBtn.selected = YES;
    }else{
        cell.articleSelectBtn.selected = NO;
    }
    //如果数组中包含modal，就让其进入编辑状态
    if (self.editeIndexArray.count > 0) {
        //点击全部编辑按钮时:
        if ([self.editeIndexArray containsObject:modal]) {
            NSLog(@"%@",self.editeIndexArray);
            cell.ArticleEditeView.hidden = NO;
        }else{
            cell.ArticleEditeView.hidden = YES;
        }
    }else{
        //点击storeCell上的编辑按钮时:
            if ([self.editeArray containsObject:modal]) {
                cell.ArticleEditeView.hidden = NO;
            }else{
                cell.ArticleEditeView.hidden = YES;
        }
    }
//====================↓点击艺术品cell编辑视图的删除按钮↓===============
    __weak typeof(cell) tmpCell = cell;
    cell.didClickDeleteButton = ^(NSInteger index){
        
        DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
        AW_DeleteAlertMessage * contentView = BundleToObj(@"AW_DeleteAlertMessage");
        contentView.bounds = Rect(0, 0, 272, 130);
        alertView.contentView = contentView;
        [alertView showWithoutAnimation];
        //点击取消或确定删除商品按钮的回调
        contentView.didClickedBtn = ^(NSInteger index){
            if (index == 1) {
                UIView * v = [tmpCell.deleteArticleBtn superview];
                UIView * v1 = [v superview];
                UIView * v2 = [v1 superview];
                AW_MyShopCarCell * cell = (AW_MyShopCarCell*)[v2 superview];
                NSIndexPath * cellParh = [self.tableView indexPathForCell:cell];
                NSLog(@"点击了第%ld个cell的删除按钮",cellParh.row);
                AW_MyShopCartModal * cellModal = self.dataArr[cellParh.row];
        //在这进行删除请求(请求成功后才进行删除数据)
                NSDictionary * dict = @{@"id":cellModal.commodityModal.shopCart_id};
                NSError * error = nil;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary * deleteDict = @{@"param":@"delShoppingCart",@"jsonParam":str};
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:ARTSCOME_INT parameters:deleteDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSLog(@"%@",responseObject);
                    if ([responseObject[@"code"]intValue] == 0) {
                        //获得该艺术品所属的商铺索引
                        __block AW_MyShopCartModal * tmpStoreModal;
                        __block NSInteger  separateIndex;
                        __block NSIndexPath *storePath;
                        [self.dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            AW_MyShopCartModal * storeModal = obj;
                            if ([storeModal.storeModal.shop_Name isEqualToString:cell.belongStoreName]) {
                                tmpStoreModal = self.dataArr[idx];
                                separateIndex = idx - 1;
                                storePath = [NSIndexPath indexPathForRow:idx inSection:0];
                                NSLog(@"%@",tmpStoreModal.subArray);
                                [tmpStoreModal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
                                    
                                    AW_MyShopCartModal * tmp = obj;
                                    NSLog(@"%@",tmp.commodityModal.commodity_Name);
                                    
                                    if([cellModal.commodityModal.commodity_Id intValue] == [tmp.commodityModal.commodity_Id intValue]) {
                                        //一定要先modal.subArray数组中删除要删除的艺术品infoModal
                                        //然后再将该艺术品的数据从self.dataArr中删除
                                        [tmpStoreModal.subArray removeObject:tmp];
                                        AW_MyShopCartModal * cellModal = obj;
                                        if ([self.articleTmpArray containsObject:cellModal]) {
                                            NSInteger price = [cellModal.commodityModal.commodityNumber integerValue]*[cellModal.commodityModal.commodityPrice floatValue];
                                            NSLog(@"%ld",price);
                                            NSLog(@"%f",self.totalPrice);
                                            self.totalPrice = self.totalPrice - price;
                                            self.FootView.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
                                        }
                                    }
                                }];
                            }
                        }];
                        if (self.editeIndexArray.count > 0){
                            //点击全部编辑按钮
                            [self.editeIndexArray removeObject:cellModal];
                            NSLog(@"%f",self.totalPrice);
                        }else{
                            //点击商铺cell编辑按钮
                            [self.editeArray removeObject:cellModal];
                        }
                        [self.dataArr removeObjectAtIndex:cellParh.row];
                        NSLog(@"%ld",tmpStoreModal.subArray.count);
#warning 编辑删除商品后点击【完成】，退出应用Bug
                        if (tmpStoreModal.subArray.count == 0) {
                            //如果该商铺下的艺术品为零，商铺cell的编辑状态也取消
                            [self.editeArray removeObject:tmpStoreModal];
                            [self.tmpArray removeObject:tmpStoreModal];
                            [self.storeIndexArray removeObject:tmpStoreModal];
                            NSLog(@"%@",self.editeArray);
                            
                            //先将商铺cell数据删除,然后将多余的分割线删除
                            [self.dataArr removeObject:tmpStoreModal];
                            [self.dataArr removeObjectAtIndex:separateIndex];
                        }
                        if ([self.articleTmpArray containsObject:cellModal]) {
                            [self.articleTmpArray removeObject:cellModal];
                            self.editeTmpPrice = 0;
                            self.tmpPrice = 0;
                            NSLog(@"%f",self.totalPrice);
                        }
                        NSLog(@"%@",self.editeArray);
                        //添加提示信息
                        [SVProgressHUD showWithStatus:@"正在删除" maskType:SVProgressHUDMaskTypeBlack];
                        [SVProgressHUD dismissAfterDelay:1];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            //刷新列表
                            [self.tableView reloadData];
                        });
                        //有效商品和失效商品都被删除后,进行调用
                        if (self.dataArr.count <= 2){
                            if (_noneCommidity) {
                                _noneCommidity();
                            }
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    NSLog(@"错误信息==%@=",[error localizedDescription]);
                }];
                
            }else if (index == 2){
                NSLog(@"取消删除");
            }
        };
    };
//===============↓点击艺术品cell编辑视图的增加按钮↓==========
    //进入编辑状态后，滚动时不让显示艺术品的数量消失
    if (cell.ArticleEditeView.hidden == NO) {
        cell.editeArticleNum.text = modal.editeArticleNum;
    }
    //防止当艺术品数量为1时，滑动时编辑label的数量会消失
    if ([[NSString stringWithFormat:@"%@",cell.articleNum.text] isEqualToString:@"1"]) {
        cell.editeArticleNum.text = @"1";
    }
    cell.didClickAddBtn = ^(NSInteger index){
        UIView * v = [tmpCell.addButton superview];
        UIView * v1 = [v superview];
        UIView * v2 = [v1 superview];
        AW_MyShopCarCell * cell = (AW_MyShopCarCell*)[v2 superview];
        NSIndexPath * cellPath = [self.tableView indexPathForCell:cell];
        
        AW_MyShopCartModal * modal = self.dataArr[cellPath.row];
        NSLog(@"点击了第%d个cell的添加按钮",cellPath.row);
        tmpCell.reduceButton.enabled = YES;
        NSInteger editeNum = [modal.editeArticleNum integerValue];
        editeNum ++ ;
        NSLog(@"%d",editeNum);
        
        //在这进行商品数量改变的请求(***如果前后的商品数量不一致***)
        NSLog(@"购物车id ==%@==",modal.commodityModal.shopCart_id);
        NSLog(@"商品数量==%@==",[NSString stringWithFormat:@"%d",editeNum]);
        
            NSDictionary * dict = @{@"id":modal.commodityModal.shopCart_id,@"num":[NSString stringWithFormat:@"%d",editeNum]};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * changeDict = @{@"param":@"updateShoppingCartNum",@"jsonParam":str};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:changeDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    NSLog(@"修改成功。。。。");
                    NSLog(@"%d",editeNum);
                    tmpCell.editeArticleNum.text = [NSString stringWithFormat:@"%d",editeNum];
                    NSLog(@"%@",tmpCell.editeArticleNum.text);
                    tmpCell.articleNum.text = [NSString stringWithFormat:@"%d",editeNum];
                    modal.commodityModal.commodityNumber = [NSString stringWithFormat:@"%d",editeNum];
                    modal.editeArticleNum = [NSString stringWithFormat:@"%d",editeNum];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息:%@",[error localizedDescription]);
            }];
    };
    
//=================↓点击艺术品cell编辑视图的减少按钮↓===================
    cell.didClickReduceBtn = ^(NSInteger index){
        UIView * v = [tmpCell.reduceButton superview];
        UIView * v1 = [v superview];
        UIView * v2 = [v1 superview];
        AW_MyShopCarCell * cell = (AW_MyShopCarCell*)[v2 superview];
        NSIndexPath * cellPath = [self.tableView indexPathForCell:cell];
        NSLog(@"点击了第%d个cell的减少按钮",cellPath.row);
        AW_MyShopCartModal * modal = self.dataArr[cellPath.row];
        NSInteger editeNum = [modal.editeArticleNum integerValue];
        editeNum -- ;
        NSLog(@"%d",editeNum);
        if (editeNum == 0) {
           tmpCell.reduceButton.enabled = NO;
        }else if (editeNum > 0){
           tmpCell.reduceButton.enabled = YES;
            
            //在这进行商品数量改变的请求(***如果前后的商品数量不一致***)
            NSLog(@"购物车id ==%@==",modal.commodityModal.shopCart_id);
            NSLog(@"商品数量==%@==",[NSString stringWithFormat:@"%ld",editeNum]);
            NSDictionary * dict = @{@"id":modal.commodityModal.shopCart_id,@"num":[NSString stringWithFormat:@"%ld",editeNum]};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * changeDict = @{@"param":@"updateShoppingCartNum",@"jsonParam":str};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:changeDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    NSLog(@"修改成功。。。。");
                    NSLog(@"%ld",editeNum);
                    tmpCell.editeArticleNum.text = [NSString stringWithFormat:@"%ld",editeNum];
                    NSLog(@"%@",tmpCell.editeArticleNum.text);
                    tmpCell.articleNum.text = [NSString stringWithFormat:@"%ld",editeNum];
                    modal.commodityModal.commodityNumber = [NSString stringWithFormat:@"%ld",editeNum];
                    modal.editeArticleNum = [NSString stringWithFormat:@"%ld",editeNum];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息:%@",[error localizedDescription]);
            }];
        }
        
    };

//======↓点击艺术品cell编辑视图的展示商品tableView详情↓========
    cell.didClickDisplayDetailBtn = ^(NSInteger index){
        UIView * v = [tmpCell.displayDetailBtn superview];
        UIView * v1 = [v superview];
        UIView * v2 = [v1 superview];
        AW_MyShopCarCell *articleCell = (AW_MyShopCarCell*)[v2 superview];
        NSIndexPath * cellPath = [self.tableView indexPathForCell:articleCell];
        AW_MyShopCartModal * detailModal = self.dataArr[cellPath.row];
        NSLog(@"%@",detailModal.commodityModal.commodityTyde);
        NSLog(@"点击了第%ld个cell的显示tableView详情按钮",cellPath.row);
        //把modal传过去
        if (_didClickDetailBtn) {
            _didClickDetailBtn(detailModal);
        }
    };
//===================↓点击艺术品cell左侧的选择按钮↓===================
    __weak typeof(cell) weakCell = cell;
    cell.didClickSelectBtn = ^(NSInteger index){
        UIView * v = [weakCell.articleSelectBtn superview];
        UIView * v1 = [v superview];
        AW_MyShopCarCell * cell = (AW_MyShopCarCell*)[v1 superview];
        NSIndexPath * cellIndexPath = [tableView indexPathForCell:cell];
        //选中或取消选中的艺术品的总价格
        AW_MyShopCartModal * tmpModal = self.dataArr[cellIndexPath.row];
        float  tmpPrice = [tmpModal.commodityModal.commodityPrice floatValue]*[tmpModal.commodityModal.commodityNumber integerValue];
        //将选中的articleCell的modal记录下来(如果存在就将其删除，选中2次)
        if (![self.articleTmpArray containsObject:tmpModal]) {
            [self.articleTmpArray addObject:tmpModal];
            //如果是艺术品cell是选中状态，将价格增加
            if (cell.ArticleEditeView.hidden == YES) {
                self.totalPrice = self.totalPrice + tmpPrice;
                NSLog(@"艺术品的总价格为￥%.2f",self.totalPrice);
                self.FootView.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
            }
        }else{
            [self.articleTmpArray removeObject:tmpModal];
            //只要任何一个艺术品的选择按钮不被选中，全选按钮也取消选中
            self.FootView.selectBtn.selected = NO;
            //如果艺术品取消选中状态，将价格减少
            if (cell.ArticleEditeView.hidden == YES) {
                self.totalPrice = self.totalPrice - tmpPrice;
                self.FootView.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
            }
        }
        NSLog(@"艺术品cell索引：%ld",cellIndexPath.row);
        NSLog(@"该艺术品所属的商铺名称：%@",cell.belongStoreName);
        //获取该艺术品所属的商铺cell的索引
        __weak typeof(self) weakSelf = self;
        [self.dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AW_MyShopCartModal * storeModal = obj;
            if ([storeModal.storeModal.shop_Name isEqualToString:cell.belongStoreName]) {
                weakSelf.storeIndex = idx;
                NSLog(@"===%ld==",idx);
            }
        }];
        /**
         *  @author cao, 15-09-08 15:09:46
         *
         *判断该艺术品所属商铺下的艺术品的选中状态，
         *只有艺术品都被选中时商铺cell上的选中按钮才显示选中
         */
        AW_MyShopCartModal * storeModal = self.dataArr[self.storeIndex];
        NSMutableArray * countArray = [[NSMutableArray alloc]init];
        [storeModal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            NSIndexPath * path = [NSIndexPath indexPathForRow:self.storeIndex + idx + 1 inSection:0];
            AW_MyShopCarCell * cell = (AW_MyShopCarCell*)[self.tableView cellForRowAtIndexPath:path];
            if (cell.articleSelectBtn.selected == YES) {
                [countArray addObject:obj];
            }
        }];
        NSLog(@"====%ld===",storeModal.subArray.count);
        NSLog(@"====%ld===",countArray.count);
        if (countArray.count == storeModal.subArray.count) {
            NSIndexPath * path = [NSIndexPath indexPathForRow:self.storeIndex inSection:0];
            AW_ArticleStoreCell * cell = (AW_ArticleStoreCell*)[self.tableView cellForRowAtIndexPath:path];
            //将storeCell的modal存下来
            AW_MyShopCartModal * storeModal = self.dataArr[path.row];
            if (![self.tmpArray containsObject:storeModal]) {
                [self.tmpArray addObject:storeModal];
                //触发底部视图全选操作
                if (self.tmpArray.count == self.storeIndexArray.count) {
                    self.FootView.selectBtn.selected = YES;
                }else{
                    self.FootView.selectBtn.selected = NO;
                }
            }
            cell.storeSelectBtn.selected = YES;
        }else{
            NSIndexPath * path = [NSIndexPath indexPathForRow:self.storeIndex inSection:0];
            AW_ArticleStoreCell * cell = (AW_ArticleStoreCell*)[self.tableView cellForRowAtIndexPath:path];
            //将storeCell的索引删除
            AW_MyShopCartModal * storeModal = self.dataArr[path.row];
            if ([self.tmpArray containsObject:storeModal]) {
                [self.tmpArray removeObject:storeModal];
            }
            cell.storeSelectBtn.selected = NO;
        }
    };
    return cell;
}
-(AW_MyShopCarCell*)configInvalidCellWithModal:(AW_MyShopCartModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"invalidCell";
    AW_MyShopCarCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AW_MyShopCarCell" owner:self options:nil][1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //判断网络状态和是否开启了省流量模式
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"patternState"]isEqualToString:@"yes"]&&[[user objectForKey:@"NetState"]isEqualToString:@"切换到WWAN网络"]) {
         [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commodityModal.fuzzyImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    }else{
         [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commodityModal.clearImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    }

    cell.articleName.text = [NSString stringWithFormat:@"%@",modal.commodityModal.commodity_Name];
    cell.articleDescribe.text  = [NSString stringWithFormat:@"%@",modal.commodityModal.invalidReason];
    //点击找相似商品按钮的回调
    __weak typeof(cell) weakCell = cell;
    cell.didClickedSimilaryBtn = ^(NSString * articleKind){
        UIView * v = [weakCell.similaryBtn superview];
        UIView * v1 = [v superview];
        AW_MyShopCarCell * tmpCell = (AW_MyShopCarCell*)[v1 superview];
        NSIndexPath * path = [tableView indexPathForCell:tmpCell];
        AW_MyShopCartModal * tmpModal = self.dataArr[path.row];
        NSLog(@"失效产品数量索引====%ld===",path.row);
        _similary_id = tmpModal.commodityModal.commodity_Id;
        if (_didClickSimilaryBtn){
            _didClickSimilaryBtn(_similary_id);
        }
    };
    return cell;
 }

-(AW_ArticleStoreCell*)configArticleStoredCellWithModal:(AW_MyShopCartModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"StoreCell";
    AW_ArticleStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AW_ArticleStoreCell" owner:self options:nil][0];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.storeName.text = [NSString stringWithFormat:@"%@",modal.storeModal.shop_Name];
     //=============↓如果商铺cell全部选中全选按钮也选中↓==========
    if (self.tmpArray.count == self.storeIndexArray.count) {
        self.FootView.selectBtn.selected = YES;
    }else{
        self.FootView.selectBtn.selected = NO;
    }
    //============↓如果包含在其中，就让他选中↓============
    if ([self.tmpArray containsObject:modal]) {
        cell.storeSelectBtn.selected = YES;
    }
    else{
        cell.storeSelectBtn.selected = NO;
    }
    //如果数组中包含indexPath就让storeCell保持在编辑状态
    if (self.editeIndexArray.count > 0) {
        //点击全部编辑按钮时:
        if ([self.storeIndexArray containsObject:modal]){
            cell.storeEditeBtn.hidden = YES;
        }else{
            cell.storeEditeBtn.hidden = NO;
        }
    }else{
        //点击storeCell上的编辑按钮时:
        if ([self.editeArray containsObject:modal]) {
            cell.storeEditeBtn.selected = YES;
        }else{
            cell.storeEditeBtn.selected = NO;
        }
    }
 
//===================↓点击商铺cell左侧的选择按钮↓================
    __weak typeof(cell) weakCell = cell;
    cell.didClickSelectBtn = ^(NSInteger index){
        weakCell.storeSelectBtn.selected = !weakCell.storeSelectBtn.selected;
        UIView *v = [weakCell.storeSelectBtn superview];
        UIView *v1 = [v superview];
        AW_ArticleStoreCell *cell = (AW_ArticleStoreCell *)[v1 superview];
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
        //将选中的storeCell索引记录下来
        AW_MyShopCartModal * storeModal = self.dataArr[cellIndexPath.row];
        if (![self.tmpArray containsObject:storeModal]) {
            [self.tmpArray addObject:storeModal];
            //触发全选按钮操作
            if (self.tmpArray.count == self.storeIndexArray.count) {
                self.FootView.selectBtn.selected = YES;
            }else{
                self.FootView.selectBtn.selected = NO;
            }
        }
        else{
            [self.tmpArray removeObject:storeModal];
            //只要任何一个商铺的选择按钮不被选中，全选按钮也取消选中
            self.FootView.selectBtn.selected = NO;
        }
        NSLog(@"商铺cell索引：%ld",cellIndexPath.row);
        NSLog(@"该商铺下的艺术品个数为%ld个",modal.subArray.count);
        if (weakCell.storeSelectBtn.selected == YES){
            //将该商铺下的所有艺术品都选中
            [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSIndexPath * path = [NSIndexPath indexPathForRow:cellIndexPath.row + idx + 1 inSection:0];
                //将articleCell的modal存下来
                AW_MyShopCartModal * cellModal = obj;
                if (![self.articleTmpArray containsObject:cellModal]) {
                    [self.articleTmpArray addObject:cellModal];
                 //改变底部footView显示的艺术品总价格
                     float  tmpPrice = [cellModal.commodityModal.commodityPrice floatValue]*[cellModal.commodityModal.commodityNumber integerValue];
                    self.totalPrice = self.totalPrice + tmpPrice;
                    self.FootView.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
                }
                AW_MyShopCarCell * cell = (AW_MyShopCarCell*)[tableView cellForRowAtIndexPath:path];
                cell.articleSelectBtn.selected = YES;
            }];
        }else if(weakCell.storeSelectBtn.selected == NO){
            //将该商铺下的所有艺术品都取消选中
            [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSIndexPath * path = [NSIndexPath indexPathForRow:cellIndexPath.row + idx + 1 inSection:0];
                //如果articleCell的modal存在，就将其删除
                AW_MyShopCartModal * cellModal = obj;
                if ([self.articleTmpArray containsObject:cellModal]) {
                    [self.articleTmpArray removeObject:cellModal];
                    //改变底部footView显示的艺术品总价格
                    float  tmpPrice = [cellModal.commodityModal.commodityPrice floatValue]*[cellModal.commodityModal.commodityNumber integerValue];
                    self.totalPrice = self.totalPrice - tmpPrice;
                    self.FootView.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
                }
                AW_MyShopCarCell * cell = (AW_MyShopCarCell*)[tableView cellForRowAtIndexPath:path];
                cell.articleSelectBtn.selected = NO;
            }];
        }
    };
    
//==================↓点击商铺cell右侧的编辑按钮↓===================
    cell.didClickEditeBtn = ^(NSInteger index){
        UIView *v = [weakCell.storeEditeBtn superview];
        UIView *v1 = [v superview];
        AW_ArticleStoreCell *cell = (AW_ArticleStoreCell *)[v1 superview];
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
        NSLog(@"商铺cell索引：%@",cellIndexPath);
        //将进入编辑状态的商铺Modal存入数组
        AW_MyShopCartModal * storeModal = self.dataArr[cellIndexPath.row];
        if (![self.editeArray containsObject:storeModal]) {
            [self.editeArray addObject:storeModal];
        }else{
            [self.editeArray removeObject:storeModal];
        }
        if (weakCell.storeEditeBtn.selected == YES){
            //将该商铺下的所有艺术品进入编辑状态
             self.editeTmpPrice = 0;
            [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSIndexPath * path = [NSIndexPath indexPathForRow:cellIndexPath.row + idx + 1 inSection:0];
                //将进入编辑状态的cell的Modal存入数组
                AW_MyShopCartModal * cellModal = obj;
                if (![self.editeArray containsObject:cellModal]) {
                    [self.editeArray addObject:cellModal];
                }
            //首先将编辑之前的艺术品价格记录下来,在编辑完成之后再对艺术品价格进行处理(只有进入选中状态的艺术品cell才走下面这个方法)
                if ([self.articleTmpArray containsObject:cellModal]) {
                    float  tmpPrice = [cellModal.commodityModal.commodityPrice floatValue]*[cellModal.commodityModal.commodityNumber integerValue];
                    //先将原来的艺术品价格删除(在编辑完成后重新赋值)
                    self.editeTmpPrice = self.editeTmpPrice + tmpPrice;
                    NSLog(@"%.2f",self.editeTmpPrice);
                }
                AW_MyShopCarCell * cell = (AW_MyShopCarCell*)[tableView cellForRowAtIndexPath:path];
                cell.ArticleEditeView.hidden = NO;
                //当shangpucell上的编辑按钮进入编辑状态后,初始化编辑状态时的商品数量
                cell.editeArticleNum.text = cell.articleNum.text;
                cellModal.editeArticleNum = cell.articleNum.text;
            }];
        }else if(weakCell.storeEditeBtn.selected == NO){
            //将该商铺下的所有艺术品都进入非编辑状态
            __block AW_MyShopCartModal * cellModal;
            [modal.subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                NSIndexPath * path = [NSIndexPath indexPathForRow:cellIndexPath.row + idx + 1 inSection:0];
                //将进入编辑状态的cell的从视图中删除
                cellModal = obj;
                if ([self.editeArray containsObject:cellModal]) {
                    [self.editeArray removeObject:cellModal];
                    AW_MyShopCarCell * cell = (AW_MyShopCarCell*)[tableView cellForRowAtIndexPath:path];
                    cell.ArticleEditeView.hidden = YES;
                }
                
             //改变底部footView显示的艺术品总价格(只有进入选中状态的艺术品cell才走下面这个方法)
                if ([self.articleTmpArray containsObject:cellModal]) {
                    float tmpPrice = [cellModal.commodityModal.commodityPrice floatValue]*[cellModal.commodityModal.commodityNumber integerValue];
                    self.totalPrice = self.totalPrice + tmpPrice ;
                    NSLog(@"%.2f",self.totalPrice);
                }
            }];
            //if ([self.articleTmpArray containsObject:cellModal]) {
               self.totalPrice = self.totalPrice - self.editeTmpPrice;
           // }
            NSLog(@"%.2f",self.totalPrice);
             self.FootView.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
        }
    };
    return cell;
    
}
-(UITableViewCell*)configSeparateCellWithModal:(AW_MyShopCartModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"separate";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
