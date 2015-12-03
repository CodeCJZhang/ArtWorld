//
//  AW_MyCollectionDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyCollectionDataSource.h"
#import "AW_MyCollectArticleCell.h"
#import "AW_MyCollectionModal.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AW_Constants.h"

@interface AW_MyCollectionDataSource()

@end

@implementation AW_MyCollectionDataSource

#pragma mark - GetData Menthod

-(void)getData{
    __weak typeof(self) weakSelf = self;
    
    //在这进行我收藏的艺术品请求
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{@"userId":user_id};
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * artDict = @{@"param":@"collCommodity",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:artDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        //将艺术品的总数记录下来
        self.totalClassNum = [responseObject[@"info"]valueForKey:@"totalNumber"];
        if ([responseObject[@"code"]intValue] == 0) {
            if (_requestSucess) {
                _requestSucess(_totalClassNum);
            }
            NSArray * artArray = [responseObject[@"info"]valueForKey:@"data"];
            [artArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * artDict = obj;
                
                //插入分割线
               AW_MyCollectionModal * spearatorModal = [[AW_MyCollectionModal alloc]init];
                spearatorModal.cellType = ENUM_COLLECTION_SEPATATE;
                spearatorModal.rowHeight = kMarginBetweenCompontents;
                [weakSelf.dataArr addObject:spearatorModal];
                
               //插入艺术品
                AW_MyCollectionModal * modal = [[AW_MyCollectionModal alloc]init];
                AW_CommodityModal * commidityModal = [[AW_CommodityModal alloc]init];
                modal.commidityModal = commidityModal;
                if (artDict[@"clear_img"]) {
                    commidityModal.commidity_width = [artDict[@"width"]intValue];
                    commidityModal.commidity_height = [artDict[@"height"]intValue];
                    commidityModal.clearImageURL = artDict[@"clear_img"];
                    commidityModal.fuzzyImageURL = artDict[@"fuzzy_img"];
                }
                commidityModal.commodity_Id = artDict[@"id"];
                commidityModal.commodity_Name = artDict[@"name"];
                commidityModal.commodityPrice = artDict[@"price"];
                commidityModal.isInvalid = artDict[@"isInvalid"];
                modal.rowHeight = 96;
                if ([commidityModal.isInvalid boolValue] == YES) {
                    modal.cellType = ENUM_COLLECTION_INVALID;
                }else if ([commidityModal.isInvalid boolValue] == NO){
                    modal.cellType = ENUM_COLLECTION_COLLECTION;
                }
                modal.separatorModal = spearatorModal;
                [weakSelf.dataArr addObject:modal];
            }];
            //插入分割线
            AW_MyCollectionModal * spearatorModal = [[AW_MyCollectionModal alloc]init];
            spearatorModal.cellType = ENUM_COLLECTION_SEPATATE;
            spearatorModal.rowHeight = kMarginBetweenCompontents;
            [weakSelf.dataArr addObject:spearatorModal];
            
            [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息:%@",[error localizedDescription]);
    }];
}

-(void)getFailureData{
    
    __weak typeof(self) weakSelf = self;
    //在这进行我收藏的艺术品请求
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{@"userId":user_id};
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * artDict = @{@"param":@"collCommodity",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
   [manager POST:ARTSCOME_INT parameters:artDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       NSLog(@"%@",responseObject);
       if ([responseObject[@"code"]intValue] == 0) {
           NSArray * artArray = [responseObject[@"info"]valueForKey:@"data"];
           [artArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
               NSDictionary * artDict = obj;
               //插入失效的艺术品
               if ([artDict[@"isInvalid"]boolValue] == YES) {
                   //插入分割线
                   AW_MyCollectionModal * spearatorModal = [[AW_MyCollectionModal alloc]init];
                   spearatorModal.cellType = ENUM_COLLECTION_SEPATATE;
                   spearatorModal.rowHeight = kMarginBetweenCompontents;
                   [weakSelf.dataArr addObject:spearatorModal];
                   
                   //插入艺术品
                   AW_MyCollectionModal * modal = [[AW_MyCollectionModal alloc]init];
                   AW_CommodityModal * commidityModal = [[AW_CommodityModal alloc]init];
                   modal.commidityModal = commidityModal;
                   if (artDict[@"clear_img"]) {
                       commidityModal.commidity_width = [artDict[@"width"]intValue];
                       commidityModal.commidity_height = [artDict[@"height"]intValue];
                       commidityModal.clearImageURL = artDict[@"clear_img"];
                       commidityModal.fuzzyImageURL = artDict[@"fuzzy_img"];
                   }
                   commidityModal.commodity_Id = artDict[@"id"];
                   commidityModal.commodity_Name = artDict[@"name"];
                   commidityModal.commodityPrice = artDict[@"price"];
                   commidityModal.isInvalid = artDict[@"isInvalid"];
                   modal.rowHeight = 96;
                   if ([commidityModal.isInvalid boolValue] == YES) {
                       modal.cellType = ENUM_COLLECTION_INVALID;
                   }else if ([commidityModal.isInvalid boolValue] == NO){
                       modal.cellType = ENUM_COLLECTION_COLLECTION;
                   }
                   modal.separatorModal = spearatorModal;
                   [weakSelf.dataArr addObject:modal];
               }
           }];
           //插入分割线
           AW_MyCollectionModal * spearatorModal = [[AW_MyCollectionModal alloc]init];
           spearatorModal.cellType = ENUM_COLLECTION_SEPATATE;
           spearatorModal.rowHeight = kMarginBetweenCompontents;
           [weakSelf.dataArr addObject:spearatorModal];
           
           [self dataDidLoad];
       }
   } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息:%@",[error localizedDescription]);
   }];
}

#pragma mark - UITableViewDataSource  Menthod

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyCollectionModal * modal = self.dataArr[indexPath.row];
 
    switch (modal.cellType) {
        case ENUM_COLLECTION_SEPATATE:{
            return [self configSeparateCellWithModal:modal tableView:tableView indexPath:indexPath];
        }break;
        case ENUM_COLLECTION_INVALID:{
            return [self configInvalidArticleCellWithModal:modal tableView:tableView indexPath:indexPath];
        }break;
        case ENUM_COLLECTION_COLLECTION:{
            return [self configArticleCellWithModal:modal tableView:tableView indexPath:indexPath];}
        default:
            break;
    }
    return nil;
}

#pragma mark - UITableViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyCollectionModal * modal = self.dataArr[indexPath.row];
    return modal.rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    AW_MyCollectionModal * modal = self.dataArr[indexPath.row];
    if ([cell isKindOfClass:[AW_MyCollectArticleCell class]] && [modal.commidityModal.isInvalid boolValue] == NO) {
        _articleModal = modal.commidityModal;
        if (_didSelectCell) {
            _didSelectCell(_articleModal);
        }
    }
}

#pragma mark - ConfigCell Menthod

-(AW_MyCollectArticleCell*)configArticleCellWithModal:(AW_MyCollectionModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
   static NSString * cellId = @"collectionCell";
    AW_MyCollectArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AW_MyCollectArticleCell" owner:self options:nil][0];
    }
    //判断网络状态和是否开启了省流量模式
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"patternState"]isEqualToString:@"yes"]&&[[user objectForKey:@"NetState"]isEqualToString:@"切换到WWAN网络"]) {
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commidityModal.fuzzyImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    }else{
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commidityModal.clearImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    }
    
    cell.articleName.text = [NSString stringWithFormat:@"%@",modal.commidityModal.commodity_Name];
    cell.articlePrice.text = [NSString stringWithFormat:@"￥%.2f",modal.commidityModal.commodityPrice.floatValue];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //点击取消按钮后的回调
    __weak typeof (cell) weakCell = cell;
    cell.didClickCancleBtn = ^(NSInteger index){
        
        UIView * v = [weakCell.cancleButton superview];
        AW_MyCollectArticleCell * cell = (AW_MyCollectArticleCell*)[v superview];
        NSIndexPath * path = [tableView indexPathForCell:cell];
        NSLog(@"艺术品的索引为%ld",path.row);
        AW_MyCollectionModal * tmpModal = self.dataArr[path.row];

        //在这请求取消收藏艺术品
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSString * IdString = [userDefault objectForKey:@"user_id"];
        NSLog(@"用户id==%@==",IdString);
        NSLog(@"艺术品id==%@==",tmpModal.commidityModal.commodity_Id);
        NSError * error = nil;
        NSDictionary * dict = @{
                                @"userId":IdString,
                                @"id":tmpModal.commidityModal.commodity_Id,
                                };
        NSData * Data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString * string = [[NSString alloc]initWithData:Data encoding:NSUTF8StringEncoding];
        NSDictionary * cancleDict = @{@"param":@"cancelCollectionCommodity",@"jsonParam":string};
        AFHTTPSessionManager * httpManager = [AFHTTPSessionManager manager];
        [httpManager POST:ARTSCOME_INT parameters:cancleDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"%@",responseObject[@"message"]);
            if ([responseObject[@"code"]intValue] == 0) {
                //请求成功后删除数据
                //添加提示信息
                [SVProgressHUD showWithStatus:@"正在取消收藏" maskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD dismissAfterDelay:1];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    //将数据删除后,然后进行刷新(将多余的分割线也删除)
                    [self.dataArr removeObject:tmpModal];
                    [self.dataArr removeObject:tmpModal.separatorModal];
                    //将数据从界面上删除
                    [self.dataArr removeObject:tmpModal];
                    [self.dataArr removeObject:tmpModal.separatorModal];
                    
                    NSLog(@"===%ld===",self.dataArr.count);
                    [self.tableView reloadData];
                });
                _CollectionModal = tmpModal;
                if (_didClickedCancleBtn) {
                    _didClickedCancleBtn(_CollectionModal);
                }
                //tmpModal.commidityModal.isCollected = NO;
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",[error localizedDescription]);
        }];
    };
    return cell;
}

-(AW_MyCollectArticleCell*)configInvalidArticleCellWithModal:(AW_MyCollectionModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"invalidCollectionCell";
    AW_MyCollectArticleCell *  cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AW_MyCollectArticleCell" owner:self options:nil][1];
    }
    //判断网络状态和是否开启了省流量模式
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"patternState"]isEqualToString:@"yes"]&&[[user objectForKey:@"NetState"]isEqualToString:@"切换到WWAN网络"]) {
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commidityModal.fuzzyImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    }else{
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:modal.commidityModal.clearImageURL]placeholderImage:PLACE_HOLDERIMAGE];
    }
    
    cell.articleName.text = [NSString stringWithFormat:@"%@",modal.commidityModal.commodity_Name];
    cell.articlePrice.text = [NSString stringWithFormat:@"￥%@",modal.commidityModal.commodityPrice];
    //点击取消按钮后的回调
    __weak typeof (cell) weakCell = cell;
    cell.didClickCancleBtn = ^(NSInteger index){
        UIView * v = [weakCell.cancleButton superview];
        AW_MyCollectArticleCell * cell = (AW_MyCollectArticleCell*)[v superview];
        NSIndexPath * path = [tableView indexPathForCell:cell];
        AW_MyCollectionModal * tmpModal = self.dataArr[path.row];
        NSLog(@"艺术品的描述===%@===",tmpModal.commidityModal.commodity_Name);
        //添加提示信息
        [SVProgressHUD showWithStatus:@"正在取消收藏" maskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissAfterDelay:1];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            //将数据删除后,然后进行刷新(将多余的分割线也删除)
            [self.dataArr removeObject:tmpModal];
            [self.dataArr removeObject:tmpModal.separatorModal];
            //将数据从界面上删除
            [self.dataArr removeObject:tmpModal];
            [self.dataArr removeObject:tmpModal.separatorModal];
            [self.tableView reloadData];
        });
        _CollectionModal = tmpModal;
        if (_didClickedCancleBtn) {
            _didClickedCancleBtn(_CollectionModal);
        }
    };
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITableViewCell*)configSeparateCellWithModal:(AW_MyCollectionModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  static NSString * cellId = @"seperateCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
