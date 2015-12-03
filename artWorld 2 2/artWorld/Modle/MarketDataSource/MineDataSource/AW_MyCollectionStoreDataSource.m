//
//  AW_MyCollectionStoreDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyCollectionStoreDataSource.h"
#import "AW_MycollectionStoreCell.h"
#import "AW_MyCollectionStoreModal.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AW_Constants.h"

@interface AW_MyCollectionStoreDataSource()

/**
 *  @author cao, 15-11-28 14:11:16
 *
 *  商铺cell
 */
@property(nonatomic,strong)AW_MycollectionStoreCell * storeCell;

@end

@implementation AW_MyCollectionStoreDataSource

#pragma mark - Private Menthod
-(AW_MycollectionStoreCell*)storeCell{
    if (!_storeCell) {
        _storeCell = [[NSBundle mainBundle]loadNibNamed:@"AW_MycollectionStoreCell" owner:self options:nil][0];
    }
    return _storeCell;
}

#pragma mark - GetData Menthod

-(void)getData{
    __weak typeof(self) weakSelf = self;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{
                            @"userId":user_id,
                            @"pageSize":@"10",
                            @"pageNumber":self.currentPage,
                            };
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * storeDict = @{@"param":@"collShopList",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:storeDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
            self.totolPage = [responseObject[@"info"]valueForKey:@"totalNumber"];
            NSArray * storeArray = [responseObject[@"info"]valueForKey:@"data"];
            [storeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * tmpDict = obj;
                //插入分割线
                AW_MyCollectionStoreModal * separate = [[AW_MyCollectionStoreModal alloc]init];
                separate.rowHeight = kMarginBetweenCompontents;
                separate.isSeparate = YES;
                [weakSelf.dataArr addObject:separate];
                
                //插入店铺数据
                AW_StoreModal * tmpStoreModal = [[AW_StoreModal alloc]init];
                AW_MyCollectionStoreModal * storeModal = [[AW_MyCollectionStoreModal alloc]init];
                tmpStoreModal.shoper_id = tmpDict[@"id"];
                tmpStoreModal.shop_Id = tmpDict[@"shop_id"];
                tmpStoreModal.shoper_IM_Id = tmpDict[@"phone"];
                tmpStoreModal.head_img = tmpDict[@"head_img"];
                tmpStoreModal.shop_Name = tmpDict[@"name"];
                tmpStoreModal.works_num = tmpDict[@"works_num"];
                tmpStoreModal.concern_num = tmpDict[@"concern_num"];
                tmpStoreModal.fan_num = tmpDict[@"fan_num"];
                tmpStoreModal.dynamic_num = tmpDict[@"dynamic_num"];
                tmpStoreModal.shop_province = tmpDict[@"province_name"];
                tmpStoreModal.shop_city = tmpDict[@"city_name"];
                storeModal.rowHeight = [self.storeCell heightForStoreName:tmpDict[@"name"]] + 104;
                storeModal.storeModal = tmpStoreModal;
                [weakSelf.dataArr addObject:storeModal];
            }];
            //插入分割线
            AW_MyCollectionStoreModal * separate = [[AW_MyCollectionStoreModal alloc]init];
            separate.rowHeight = kMarginBetweenCompontents;
            separate.isSeparate = YES;
            [weakSelf.dataArr addObject:separate];
            
            //判断是否显示下拉刷新
            if (([weakSelf.currentPage intValue]*10 < [weakSelf.totolPage intValue]) && [weakSelf.totolPage intValue] > 10) {
                self.tableView.footerHidden = NO;
            }else{
                self.tableView.footerHidden = YES;
            }
            //请求成功后的回调
            if (_didRequestSucess) {
                _didRequestSucess(_totolPage);
            }
            [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

#pragma mark - RefreshData Menthod 
/**
 *  @author cao, 15-08-27 16:08:05
 *
 *  刷新数据
 */
-(void)refreshData{
    self.currentPage = @"1";
    if (self.dataArr.count > 0) {
        [self.dataArr removeAllObjects];
    }
    [self performSelector:@selector(getData) withObject:nil afterDelay:1];
}

-(void)nextPageData{
    
    NSLog(@"当前的页数:%@",self.currentPage);
    if ([self.totolPage intValue] > 10 && ([self.currentPage intValue]*10 <[self.totolPage intValue])){
        //只有页数大于1时才进行上提分页(将当前页码加上1)
        self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] + 1];
        [self performSelector:@selector(getData) withObject:nil afterDelay:1];
    }
}

#pragma mark - UITableViewDataSource  Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyCollectionStoreModal * modal;
    if (self.dataArr.count > 0) {
        modal = self.dataArr[indexPath.row];
    }
    if (modal.isSeparate == YES) {
        return [self configSeparateCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else{
        return [self configCollectionStoreCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate Menthod

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyCollectionStoreModal * modal;
    if (self.dataArr.count > 0) {
        modal = self.dataArr[indexPath.row];
    }
    return modal.rowHeight;
}

#pragma mark - ConfigTableViewCell Menthod
-(AW_MycollectionStoreCell*)configCollectionStoreCellWithModal:(AW_MyCollectionStoreModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"storeCell";
    AW_MycollectionStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_MycollectionStoreCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    NSString *shopName;
    if (modal.storeModal.shop_Name) {
        if (modal.storeModal.shop_Name.length > 20) {
            shopName = [modal.storeModal.shop_Name substringToIndex:20];
            if (cell.rightConstant.priority != 998) {
                cell.rightConstant.priority = 998;
            }
        }else{
            shopName = modal.storeModal.shop_Name;
            if (modal.storeModal.shop_Name.length < 10) {
                if (cell.rightConstant.priority != 1) {
                    cell.rightConstant.priority = 1;
                }
            }
        }
    }
    [cell.head_Image sd_setImageWithURL:[NSURL URLWithString:modal.storeModal.head_img]placeholderImage:PLACE_HOLDERIMAGE];
    cell.storeName.text = [NSString stringWithFormat:@"%@",shopName];
    if ((![modal.storeModal.shop_province isKindOfClass:[NSNull class]]) && (![modal.storeModal.shop_city isKindOfClass:[NSNull class]])) {
        cell.adress.text = [[NSString stringWithFormat:@"%@",modal.storeModal.shop_province]stringByAppendingString:[NSString stringWithFormat:@"%@",modal.storeModal.shop_city]];
        cell.adressImage.hidden = NO;
    }else{
        cell.adressImage.hidden = YES;
    }
    cell.produceNum.text = [NSString stringWithFormat:@"%@",modal.storeModal.works_num];
    cell.attentionNum.text = [NSString stringWithFormat:@"%@",modal.storeModal.concern_num];
    cell.dynamicNum.text = [NSString stringWithFormat:@"%@",modal.storeModal.dynamic_num];
    cell.fansNum.text = [NSString stringWithFormat:@"%@",modal.storeModal.fan_num];
    //点击按钮后的回调
    __weak typeof(cell) weakCell = cell;
    cell.didClickCellBtn = ^(NSInteger index ){
        UIView * view = [weakCell.profuceBtn superview];
        UIView * view1 = [view superview];
        UIView * view2 = [view1 superview];
        AW_MycollectionStoreCell * cell = (AW_MycollectionStoreCell*)[view2 superview];
        NSIndexPath * path = [tableView indexPathForCell:cell];
        AW_MyCollectionStoreModal * collectionModal = self.dataArr[path.row];
        NSLog(@"选中的商铺环信id：========%@======",collectionModal.storeModal.shoper_IM_Id);
 
        if (_didClickBtn) {
            _didClickBtn(index ,collectionModal);
        }
    };
    cell.didClickTalkAndCancleBtn = ^(NSInteger index ,NSInteger storeID){
        UIView * v = [weakCell.cancleBtn superview];
        UIView * v1 = [v superview];
        AW_MycollectionStoreCell * cell = (AW_MycollectionStoreCell*)[v1 superview];
        NSIndexPath * path1 = [tableView indexPathForCell:cell];
        AW_MyCollectionStoreModal * collectionModal1 = self.dataArr[path1.row];
        NSLog(@"选中的商铺名称为：========%@======",collectionModal1.storeModal.shoper_IM_Id);

        if (_didClickTalkBtn) {
            _didClickTalkBtn(index,collectionModal1);
        }
        //点击取消收藏按钮后，将数据删除(将多余的分割线也删除)
        if (index == 5) {
            //在这进行取消收藏店铺请求
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * user_id = [user objectForKey:@"user_id"];
            NSDictionary * dict = @{@"userId":user_id,@"personId":collectionModal1.storeModal.shop_Id};
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * storeDict = @{@"jsonParam":str,@"token":@"android",@"param":@"collShop"};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:storeDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    //请求成功后删除数据
                    if (_didClickedCancleBtn) {
                        _didClickedCancleBtn();
                    }
                    [self.dataArr removeObject:collectionModal1];
                    [self.dataArr removeObjectAtIndex:path1.row - 1];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"%@",[error localizedDescription]);
            }];
        }
    };
    cell.vipImage.hidden = NO;
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITableViewCell*)configSeparateCellWithModal:(AW_MyCollectionStoreModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"separateCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
