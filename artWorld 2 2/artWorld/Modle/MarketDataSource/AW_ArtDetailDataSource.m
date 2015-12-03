//
//  AW_ArtDetailDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//
#import "AW_ArtDetailDataSource.h"
#import "AW_ArtDetailHeadCell.h"
#import "AW_PostageCell.h"
#import "AW_ArtStoreCell.h"
#import "AW_SimilaryCollectionViewCell.h"
#import "AW_CheckDetailCell.h"
#import "AW_DetailCell.h"
#import "AW_ColorAndSizeCell.h"
#import "AW_CreateIdeaCell.h"
#import "AW_CreateIdeaDetailCell.h"
#import "AW_DetailOtherCell.h"
#import "AW_ArtDetailModal.h"//艺术品详情modal
#import "UIImageView+WebCache.h"
#import "AW_SimalaryProduceCell.h"
#import "AFNetworking.h"
#import "AW_ArtSizeCell.h"//尺寸cell
#import "AW_ArtColorCell.h"//颜色cell
#import "AW_ArtCraftCell.h"//工艺cell
#import "AW_ArtProduceCell.h"//生产地cell
#import "AW_DecadeOrAutherCell.h"//年代或作者cell
#import "SVProgressHUD.h"


@interface AW_ArtDetailDataSource()<UIScrollViewDelegate,UIWebViewDelegate>
/**
 *  @author cao, 15-10-25 14:10:52
 *
 *  记录艺术品的数量
 */
@property(nonatomic,copy)NSString * numString;
/**
 *  @author cao, 15-10-24 12:10:56
 *
 *  创作理念cell
 */
@property(nonatomic,strong)AW_CreateIdeaDetailCell * createIdeaCell;
/**
 *  @author cao, 15-10-24 12:10:21
 *
 *  艺术品详情cell
 */
@property(nonatomic,strong)AW_DetailCell * detailCell;
/**
 *  @author cao, 15-10-24 13:10:48
 *
 *  商品详情是否展开
 */
@property(nonatomic)BOOL isExpand;
/**
 *  @author cao, 15-11-15 21:11:04
 *
 *  展开的艺术品详情
 */
@property(nonatomic,strong)AW_ArtDetailModal * detailModal;
/**
 *  @author cao, 15-10-28 22:10:23
 *
 *  用户id
 */
@property(nonatomic,copy)NSString * user_id;
/**
 *  @author cao, 15-11-16 14:11:15
 *
 *  webView高度
 */
@property(nonatomic)CGFloat webHeight;
@end

@implementation AW_ArtDetailDataSource

-(AW_DetailCell*)detailCell{
    if (!_detailCell) {
        _detailCell  = BundleToObj(@"AW_DetailCell");
    }
    return _detailCell;
}

-(AW_CreateIdeaDetailCell*)createIdeaCell{
    if (!_createIdeaCell) {
        _createIdeaCell = BundleToObj(@"AW_CreateIdeaDetailCell");
    }
    return _createIdeaCell;
}

-(AW_CommodityModal*)commidity_Color_modal{
    if (!_commidity_Color_modal) {
        _commidity_Color_modal = [[AW_CommodityModal alloc]init];
    }
    return _commidity_Color_modal;
}

#pragma mark - GetData Menthod
-(void)getData{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    //进行艺术品详情请求
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [defaults objectForKey:@"user_id"];
    if (!user_id) {
        self.user_id = @"";
    }else{
        self.user_id = user_id;
    }
    NSLog(@"艺术品id===%@==",self.commidity_id);
    NSLog(@"%@",self.commidity_id);
        NSDictionary *dict = @{
                               @"userId":self.user_id,
                               @"id":self.commidity_id,
                               };
        NSError * error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *detailString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *detailParam = @{@"param":@"getCommodityDetail",@"jsonParam":detailString};
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        [manager POST:ARTSCOME_INT parameters:detailParam success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"%@",responseObject[@"message"]);
 
            if ([responseObject[@"code"]intValue] == 0) {
                NSDictionary * commidityDict =   [responseObject[@"info"]objectForKey:@"commodity"];
                NSDictionary * userDict = [responseObject[@"info"]valueForKey:@"user"];
                //将该商铺的用户id记录下来
                self.personId = userDict[@"id"];
                self.shop_state = userDict[@"shop_state"];
                self.shoper_IM_id = userDict[@"phone"];
                NSLog(@"%@",self.personId);
             
                //将店铺的id记录下来
                self.shop_id = commidityDict[@"shop_id"];
                __weak typeof(self) weakSelf = self;
                NSArray * array = @[@"headCell",@"",@"priceCell",@"",@"lookCell",@"artDescribeCell",@"sizeCell",@"colorCell",@"timeCell",@"AutherCell",@"CraftCell",@"ideaCell",@"ideaDescribeCell",@"ProducePlaceCell",@"sendCell",@"",@"storeCell",@"similarySeparator",@"similaryCell",@""];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString * string = obj;
                    if ([string isEqualToString:@"headCell"]) {
                        //插入headModal
                        NSArray * stringArray = [commidityDict[@"clear_img"] componentsSeparatedByString:@","];
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailHeadModal * headModal = [[AW_DetailHeadModal alloc]init];
                        modal.headModal = headModal;
                        NSMutableArray * imageArray = [[NSMutableArray alloc]init];
                        [stringArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString * imageString = obj;
                            if (idx < stringArray.count - 1) {
                                [imageArray addObject:imageString];
                            }
                            //存到颜色modal
                            if (idx == 0) {
                                weakSelf.commidity_Color_modal.clearImageURL = imageString;
                            }
                        }];
                        headModal.clearImageArray = [imageArray copy];
                        //将要分享的图片记录下来
                        if (imageArray.count > 0) {
                            self.share_image = imageArray[0];
                        }
                        headModal.fuzzy_img = commidityDict[@"fuzzy_img"];
                        headModal.artName = commidityDict[@"name"];
                        weakSelf.commidity_Color_modal.commodity_Name = commidityDict[@"name"];
                        headModal.isCollected = [commidityDict[@"isCollected"]boolValue];
                        headModal.evaluation =commidityDict[@"evaluation"];
                        headModal.evaluation_num = commidityDict[@"evaluation_num"];
                        modal.cellType = @"headCell";
                        modal.rowHeight = 307;
                        [weakSelf.dataArr addObject:modal];
                    }else if ([string isEqualToString:@"priceCell"]){
                        //插入价格modal
                        AW_ArtDetailModal * modal1 = [[AW_ArtDetailModal alloc]init];
                        AW_DetailPriceModal * priceModal = [[AW_DetailPriceModal alloc]init];
                        modal1.priceModal = priceModal;
                        priceModal.price = commidityDict[@"price"];
                        priceModal.freight = commidityDict[@"freight"];
                        modal1.rowHeight = 42;
                        modal1.cellType = @"priceCell";
                        [weakSelf.dataArr addObject:modal1];
                    }else if ([string isEqualToString:@"lookCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        
                        modal.cellType = @"lookCell";
                        if (![commidityDict[@"details"]isEqualToString:@""]) {
                            [weakSelf.dataArr addObject:modal];
                            
                        }
                        modal.rowHeight = 42;
                    }else if ([string isEqualToString:@"sizeCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailInfoModal * infoModal = [[AW_DetailInfoModal alloc]init];
                        modal.infoModal = infoModal;
                        infoModal.size = commidityDict[@"size"];
                        modal.rowHeight = 42;
                        modal.cellType = @"sizeCell";
                        if (![commidityDict[@"size"] isEqualToString:@""]) {
                            [weakSelf.dataArr addObject:modal];
                        }
                    } else if ([string isEqualToString:@"colorCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailInfoModal * infoModal = [[AW_DetailInfoModal alloc]init];
                        modal.infoModal = infoModal;
                        modal.rowHeight = 42;
                       weakSelf.commidity_Color_modal.commodity_color = commidityDict[@"color"];
                        NSLog(@"%@",[weakSelf.commidity_Color_modal.commodity_color description]);
                         modal.cellType = @"colorCell";
                        if (![weakSelf.commidity_Color_modal.commodity_color isKindOfClass:[NSNull class]]) {
                            [weakSelf.dataArr addObject:modal];
                        }
                    }else if ([string isEqualToString:@"timeCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailInfoModal * infoModal = [[AW_DetailInfoModal alloc]init];
                        modal.infoModal = infoModal;
                        infoModal.create_time = commidityDict[@"age"];
                        modal.rowHeight = 42;
                        modal.cellType = @"timeCell";
                        if (![commidityDict[@"age"]isEqualToString:@""]) {
                            [weakSelf.dataArr addObject:modal];
                        }
                    }else if ([string isEqualToString:@"AutherCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailInfoModal * infoModal = [[AW_DetailInfoModal alloc]init];
                        modal.infoModal = infoModal;
                        infoModal.auther_name = commidityDict[@"author"];
                        modal.rowHeight = 42;
                        modal.cellType = @"autherCell";
                        if (![commidityDict[@"author"]isEqualToString:@""]) {
                            [weakSelf.dataArr addObject:modal];
                        }
                    }else if ([string isEqualToString:@"CraftCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailInfoModal * infoModal = [[AW_DetailInfoModal alloc]init];
                        modal.infoModal = infoModal;
                        infoModal.technology = commidityDict[@"technology"];
                        modal.rowHeight = 42;
                        modal.cellType = @"CraftCell";
                        if (![commidityDict[@"technology"] isEqualToString:@""]) {
                          [weakSelf.dataArr addObject:modal];
                        }
                    }else if ([string isEqualToString:@"ideaCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        modal.rowHeight = 42;
                        modal.cellType = @"ideaCell";
                        if (![commidityDict[@"idea"] isEqualToString:@""]) {
                             [weakSelf.dataArr addObject:modal];
                        }
                    }else if([string isEqualToString:@"ideaDescribeCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailInfoModal *infoModal = [[AW_DetailInfoModal alloc]init];
                        modal.infoModal = infoModal;
                        modal.cellType = @"ideaDescribeCell";
                        infoModal.create_idea = commidityDict[@"idea"];
                        if (![commidityDict[@"idea"] isEqualToString:@""]){
                            modal.rowHeight = [weakSelf ideaHeightWithModal:modal];
                            [weakSelf.dataArr addObject:modal];
                        }
                    }else if ([string isEqualToString:@"ProducePlaceCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailInfoModal * infoModal = [[AW_DetailInfoModal alloc]init];
                        modal.infoModal = infoModal;
                        modal.rowHeight = 42;
                        infoModal.origin_place = commidityDict[@"origin"];
                        modal.cellType = @"ProducePlaceCell";
                        if (![commidityDict[@"origin"]isEqualToString:@""]) {
                            [weakSelf.dataArr addObject:modal];
                        }
                    }else if ([string isEqualToString:@"sendCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailInfoModal * infoModal = [[AW_DetailInfoModal alloc]init];
                        modal.infoModal = infoModal;
                        infoModal.delivery_place = userDict[@"delivery_place"];
                        infoModal.stockNum = [commidityDict[@"stock"]integerValue];
                        modal.rowHeight = 84;
                        modal.cellType = @"placeCell";
                        [weakSelf.dataArr addObject:modal];
                    }else if ([string isEqualToString:@"storeCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailAuthorModal * storeModal = [[AW_DetailAuthorModal alloc]init];
                        modal.authorModal = storeModal;
                        storeModal.user_id = userDict[@"user_id"];
 
                        storeModal.shopName = userDict[@"shop_name"];
                        storeModal.head_img = userDict[@"head_img"];
                        storeModal.province_name = userDict[@"province_name"];
                        storeModal.city_name = userDict[@"city_name"];
                        storeModal.works_num = userDict[@"works_num"];
                        storeModal.fan_num = userDict[@"fan_num"];
                        storeModal.dynamic_num = userDict[@"dynamic_num"];
                        modal.rowHeight = 172;
                        modal.cellType = @"storeCell";
                        [weakSelf.dataArr addObject:modal];
                        
                    }else if ([string isEqualToString:@"similarySeparator"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        NSArray * tmpArray = [responseObject[@"info"]valueForKey:@"similar"];
                        if (tmpArray.count > 0) {
                            modal.rowHeight = kMarginBetweenCompontents;
                            modal.cellType = @"separatorCell";
                            [weakSelf.dataArr addObject:modal];
                        }
                    
                    }else if([string isEqualToString:@"similaryCell"]){
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        NSArray * tmpArray = [responseObject[@"info"]valueForKey:@"similar"];
                        if (tmpArray.count > 0){
                            NSMutableArray * array = [[NSMutableArray alloc]init];
                            [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSDictionary * dict = obj;
                                AW_DetailSimilaryModal * SimilaryModal = [[AW_DetailSimilaryModal alloc]init];
                                SimilaryModal.art_id = dict[@"id"];
                                SimilaryModal.clear_img = dict[@"clear_img"];
                                SimilaryModal.fuzzy_img = dict[@"fuzzy_img"];
                                [array addObject:SimilaryModal];
                            }];
                            modal.subArray = [array copy];
                            modal.rowHeight = 116;
                            modal.cellType = @"similaryCell";
                            [weakSelf.dataArr addObject:modal];
                        }
                    }else if ([string isEqualToString:@"artDescribeCell"]){
                        
                        weakSelf.detailModal = [[AW_ArtDetailModal alloc]init];
                        AW_DetailInfoModal * infoModal = [[AW_DetailInfoModal alloc]init];
                        weakSelf.detailModal.infoModal = infoModal;
                        infoModal.details = commidityDict[@"details"];
                        weakSelf.detailModal.cellType = @"artDescribeCell";
                        //将艺术品描述记录下来
                        self.commidity_describe = commidityDict[@"details"];
                    }else{
                        AW_ArtDetailModal * modal = [[AW_ArtDetailModal alloc]init];
                        modal.rowHeight = kMarginBetweenCompontents;
                        modal.cellType = @"separatorCell";
                        [weakSelf.dataArr addObject:modal];
                    }
                }];
                [SVProgressHUD dismiss];
                [self dataDidLoad];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",[error localizedDescription]);
        }];
}

#pragma mark - countHeight Menthod

-(CGFloat)ideaHeightWithModal:(AW_ArtDetailModal*)modal{
    self.createIdeaCell.ideaLabel.preferredMaxLayoutWidth = self.createIdeaCell.bounds.size.width - 16;
    self.createIdeaCell.ideaLabel.text = modal.infoModal.create_idea;
    [self.createIdeaCell layoutIfNeeded];
    [self.createIdeaCell.contentView layoutIfNeeded];
    CGSize size = [self.createIdeaCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - UITableViewDataSource Menthod

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_ArtDetailModal * modal = self.dataArr[indexPath.row];
    if ([modal.cellType isEqualToString:@"headCell"]){
        return [self configHeadCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if ([modal.cellType isEqualToString:@"priceCell"]) {
        return [self configPriceCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if ([modal.cellType isEqualToString:@"lookCell"]) {
        return [self configCheckDetailCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
    else if ([modal.cellType isEqualToString:@"colorCell"]) {
        return [self configColorCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if ([modal.cellType isEqualToString:@"sizeCell"]){
        return [self configSizeCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if ([modal.cellType isEqualToString:@"timeCell"]){
        return [self configTimeOrAutherCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if ([modal.cellType isEqualToString:@"autherCell"]){
        return [self configTimeOrAutherCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
    else if([modal.cellType isEqualToString:@"CraftCell"]){
        return [self configCraftCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
    else if ([modal.cellType isEqualToString:@"ideaCell"]) {
        return [self configIdeaCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
    else if ([modal.cellType isEqualToString:@"ideaDescribeCell"]) {
        return [self configIdeaDetailCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
    else if ([modal.cellType isEqualToString:@"placeCell"]) {
        return [self configPlaceCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
    else if ([modal.cellType isEqualToString:@"ProducePlaceCell"]){
        return [self configOringeProduceCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
    else if ([modal.cellType isEqualToString:@"storeCell"]) {
        return [self configStoreCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
    else if ([modal.cellType isEqualToString:@"similaryCell"]) {
        return [self configSimilaryCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
    else if ([modal.cellType isEqualToString:@"artDescribeCell"]) {
        return [self configDetailCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
    else if ([modal.cellType isEqualToString:@"separatorCell"]) {
        return [self configSeparatorCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else{
        return nil;
    }
}

#pragma mark - UITbaleViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_ArtDetailModal * modal = self.dataArr[indexPath.row];
    return modal.rowHeight;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ConfigTableView  Menthod
-(AW_ArtDetailHeadCell*)configHeadCellWithModal:(AW_ArtDetailModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_ArtDetailHeadCell * cell;
    static NSString * cellId = @"headCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (modal.headModal.clearImageArray.count == 0) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AW_ArtDetailHeadCell" owner:self options:nil][1];
        //[cell.topImageView setImage:[UIImage imageNamed:@"default_art(1)"]];
    }else{
        cell = BundleToObj(@"AW_ArtDetailHeadCell");
        [cell setAdImageArr:modal.headModal.clearImageArray];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.artDescribe.text = [NSString stringWithFormat:@"%@",modal.headModal.artName];
    cell.evalutePersonLabel.text = [NSString stringWithFormat:@"%@人评论",modal.headModal.evaluation_num];
    if ([modal.headModal.evaluation intValue] == 0){
         modal.headModal.evaluation = @"5";
        [cell floatForStarViewWith:@"5"];
    }else{
     [cell floatForStarViewWith:modal.headModal.evaluation];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.artDescribe.text = [NSString stringWithFormat:@"%@",modal.headModal.artName];
    cell.EvaluateLabel.text = [NSString stringWithFormat:@"%.1f",modal.headModal.evaluation.floatValue];
    cell.evalutePersonLabel.text = [NSString stringWithFormat:@"%@人评论",modal.headModal.evaluation_num];

    cell.didClickedBtn = ^(NSInteger index){
        if (_didClickedHeadCellBtn) {
            _didClickedHeadCellBtn(index);
        }
    };
    cell.didClickedICrouselView = ^(NSInteger index,NSArray * imageArray){
        if (_didClickedIcarousel) {
            _didClickedIcarousel(index,imageArray);
        }
    };
    return cell;
}

-(AW_PostageCell*)configPriceCellWithModal:(AW_ArtDetailModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_PostageCell * cell;
    static  NSString * cellId = @"priceCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_PostageCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",modal.priceModal.price.floatValue];
    if (![modal.priceModal.freight isKindOfClass:[NSNull class]]) {
       cell.postageLabel.text = [NSString stringWithFormat:@"￥%.2f",modal.priceModal.freight.floatValue];
    }
    return cell;
}

-(AW_CheckDetailCell*)configCheckDetailCellWithModal:(AW_ArtDetailModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_CheckDetailCell * cell;
    static NSString * cellId  = @"checkDetailCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_CheckDetailCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    __weak typeof(self) weakSelf = self;
    if (self.isExpand) {
        cell.expendImage.selected = YES;
        cell.bottomLayer.hidden = YES;
    }else{
        cell.expendImage.selected = NO;
        cell.bottomLayer.hidden = NO;
    }
    //点击查看详情的回调
    __weak typeof(cell) weakCell = cell;
    cell.didClickBtn = ^(){
        self.isExpand = !self.isExpand;
        if (self.isExpand) {
        weakCell.expendImage.selected = YES;
       [weakSelf.dataArr insertObject:weakSelf.detailModal atIndex:indexPath.row + 1];
            weakCell.bottomLayer.hidden = YES;
        }else{
            weakCell.expendImage.selected = NO;
            weakCell.bottomLayer.hidden = NO;
            [self.dataArr removeObject:self.detailModal];
            
        }

        [self.tableView reloadData];
    };
    return cell;
}

-(AW_DetailCell*)configDetailCellWithModal:(AW_ArtDetailModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_DetailCell * cell;
    static NSString * cellId = @"detailCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_DetailCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSLog(@"%f",self.webHeight);
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-size: %f; font-family: \"%@\"; color: %@;}\n"
                          "</style> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>", 14.0,nil,[UIColor lightGrayColor], self.detailModal.infoModal.details];
    [cell.artDetailDescribe loadHTMLString:jsString baseURL:nil];
    NSLog(@"%@",self.detailModal.infoModal.details);
    
    //webView加载完成后的回调
    cell.didLoadWebView = ^(CGFloat height){
        NSLog(@"%f",height);
        if (self.detailModal.rowHeight != height){
            self.detailModal.rowHeight = height;
            [self.tableView reloadData];
            
            NSLog(@"%f",height);
        }
    };
    [cell addBottomLayerWithHeight:self.detailModal.rowHeight];
    return cell;
}

-(AW_ArtSizeCell*)configSizeCellWithModal:(AW_ArtDetailModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_ArtSizeCell * cell;
    static NSString * cellId = @"sizeCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ArtSizeCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.artSizeLabel.text = [NSString stringWithFormat:@"%@",modal.infoModal.size];
    return cell;
}

-(AW_ArtColorCell*)configColorCellWithModal:(AW_ArtDetailModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"colorCell";
    AW_ArtColorCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ArtColorCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.artColor) {
        cell.artColorLabel.text = [NSString stringWithFormat:@"%@",self.artColor];
        modal.infoModal.color = self.artColor;
    }
    NSLog(@"==%@==",modal.infoModal.color);
    //点击颜色cell的回调
    cell.didClickedBtn = ^(){
        if (_didClickedColorButton) {
            _didClickedColorButton(self.commidity_Color_modal);
        }
    };
    return cell;
}

-(AW_ArtCraftCell*)configCraftCellWithModal:(AW_ArtDetailModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"craftCell";
    AW_ArtCraftCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ArtCraftCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.CraftLabel.text = [NSString stringWithFormat:@"%@",modal.infoModal.technology];
    return cell;
}

-(AW_CreateIdeaCell*)configIdeaCellWithModal:(AW_ArtDetailModal *)modal  tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_CreateIdeaCell * cell;
    static NSString * cellId = @"ideaCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_CreateIdeaCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(AW_CreateIdeaDetailCell*)configIdeaDetailCellWithModal:(AW_ArtDetailModal *)modal  tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_CreateIdeaDetailCell * cell;
    static NSString * cellId = @"ideaDeatailCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_CreateIdeaDetailCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.ideaLabel.text = [NSString stringWithFormat:@"%@",modal.infoModal.create_idea];
    [cell addBottomLayerWithHeight:modal.rowHeight];
    return cell;
}

-(AW_ArtProduceCell*)configOringeProduceCellWithModal:(AW_ArtDetailModal *)modal  tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"produceCell";
    AW_ArtProduceCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell){
        cell = BundleToObj(@"AW_ArtProduceCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.produceLabel.text = [NSString stringWithFormat:@"%@",modal.infoModal.origin_place];
    return cell;
}

-(AW_DetailOtherCell*)configPlaceCellWithModal:(AW_ArtDetailModal *)modal  tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_DetailOtherCell* cell;
    static NSString * cellId = @"otherPlaceCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_DetailOtherCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.storageNum.text = [NSString stringWithFormat:@"%ld",modal.infoModal.stockNum];
    //初始化时商品数量为1
    self.commidity_account = @"1";
    if (self.numString.length == 0){
     cell.numTextField.text = @"1";
    self.numString = @"1";
    }else{
     cell.numTextField.text = self.numString;
    }
    __weak typeof(cell) weakCell = cell;
    //编辑结束时的回调
    cell.endEdite = ^(NSString *str){
        if ([str integerValue] > modal.infoModal.stockNum) {
            //商品数量大于库存时的回调
            if (_numgreaterThanStore) {
                _numgreaterThanStore();
            }
            weakCell.numTextField.text = @"1";
        }else{
            self.commidity_account = str;
        }
    };
    
    //增加商品时的回调
    cell.didClick = ^(NSInteger index){
        if (index == 1) {
            if ([cell.numTextField.text integerValue] > 1) {
                weakCell.numTextField.text = [NSString stringWithFormat:@"%ld",[weakCell.numTextField.text integerValue] - 1];
            }else{
                if (_didClicked) {
                    _didClicked();
                }
            }
        }else if (index == 2){
            if ([weakCell.numTextField.text integerValue] + 1 > modal.infoModal.stockNum) {
                //商品数量大于库存时的回调
                if (_numgreaterThanStore) {
                    _numgreaterThanStore();
                }
            }else{
            weakCell.numTextField.text = [NSString stringWithFormat:@"%ld",[weakCell.numTextField.text integerValue] + 1];
            }
        }
        self.numString = weakCell.numTextField.text;
        self.commidity_account = weakCell.numTextField.text;
        NSLog(@"数量==%@==",self.commidity_account);
    };
    return cell;
}

-(AW_ArtStoreCell*)configStoreCellWithModal:(AW_ArtDetailModal *)modal  tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_ArtStoreCell * cell;
    static NSString * cellId = @"storeCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_ArtStoreCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.storeImage sd_setImageWithURL:[NSURL URLWithString:modal.authorModal.head_img]placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    if (modal.authorModal.shopName) {
        NSString * shopString;
        if (modal.authorModal.shopName.length > 20) {
            shopString = [modal.authorModal.shopName substringToIndex:19];
        }else{
            shopString = modal.authorModal.shopName;
            //设置vip图片到屏幕右侧的距离
            if (modal.authorModal.shopName.length < 12) {
                if (cell.toRightLength.priority != 1) {
                    cell.toRightLength.priority = 1;
                }
            }
        }
        cell.storeName.text = [NSString stringWithFormat:@"%@",shopString];
    }
    if (![modal.authorModal.province_name isKindOfClass:[NSNull class]]) {
        cell.storeAdress.text = [modal.authorModal.province_name stringByAppendingString:modal.authorModal.city_name];
        cell.adressImage.hidden = NO;
    }else{
        cell.adressImage.hidden = YES;
    }
    
    cell.produceNum.text = [NSString stringWithFormat:@"%@",modal.authorModal.works_num];
    cell.fansNum.text = [NSString stringWithFormat:@"%@",modal.authorModal.fan_num];
    cell.dynamicNum.text = [NSString stringWithFormat:@"%@",modal.authorModal.dynamic_num];
    cell.didClickedButtons = ^(NSInteger index){
        if (_didClickedStoreCell) {
            _didClickedStoreCell(index);
        }
    };
    return cell;
}

-(AW_DecadeOrAutherCell*)configTimeOrAutherCellWithModal:(AW_ArtDetailModal *)modal  tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_DecadeOrAutherCell * cell;
    static NSString * cellId = @"autherOrTimeCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_DecadeOrAutherCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([modal.cellType isEqualToString:@"timeCell"]) {
        cell.autherOrTimeLabel.text = [NSString stringWithFormat:@"%@",modal.infoModal.create_time];
        cell.describeLabel.text = @"年代 :";
    }
    if ([modal.cellType isEqualToString:@"autherCell"]) {
        cell.autherOrTimeLabel.text = [NSString stringWithFormat:@"%@",modal.infoModal.auther_name];
        cell.describeLabel.text = @"作者 :";
    }

    return cell;
}

-(AW_SimalaryProduceCell*)configSimilaryCellWithModal:(AW_ArtDetailModal *)modal  tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_SimalaryProduceCell * cell;
    static NSString * cellId = @"similaryCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_SimalaryProduceCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //点击相似艺术品的回调
    cell.didClickSimilaryCell = ^(NSInteger index){
        NSLog(@"点击了第==%ld==个相似的艺术品",index);
        AW_DetailSimilaryModal * artModal = modal.subArray[index];
        _similaryArt_id = artModal.art_id;
        if (_didClickedSimilaryBtn) {
            _didClickedSimilaryBtn(_similaryArt_id);
        }
    };
    [cell setKindArr:modal.subArray];
    return cell;
}

-(UITableViewCell*)configSeparatorCellWithModal:(AW_ArtDetailModal *)modal  tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;
    static NSString * cellId = @"separatorCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - UIScrollerViewDelegate Menthod
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.beforeY = scrollView.contentOffset.y;
    NSLog(@"前====%f===",scrollView.contentOffset.y);
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.afterY = scrollView.contentOffset.y;
 NSLog(@"后====%f===",scrollView.contentOffset.y);
    if (_didEndScroll) {
        _didEndScroll(_beforeY,_afterY);
    }
}

@end
