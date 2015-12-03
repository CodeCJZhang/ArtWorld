//
//  AW_MyInfoDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyInfoDataSource.h"
#import "AW_MyinfoTopCell.h"
#import "AW_MyinfoMiddleCell.h"
#import "AW_MyInfoBottomCell.h"
#import "AW_PersonalInformationModal.h" //个人信息模型
#import "IMB_Macro.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface AW_MyInfoDataSource()
/**
 *  @author cao, 15-11-06 18:11:46
 *
 *  用户字典
 */
@property(nonatomic,strong)NSDictionary * userDict;
/**
 *  @author cao, 15-11-06 18:11:49
 *
 *  收货地址字典
 */
@property(nonatomic,strong)NSDictionary * adressDict;
/**
 *  @author cao, 15-11-06 18:11:52
 *
 *  个人偏好字典
 */
@property(nonatomic,strong)NSArray * hobbyArray;
/**
 *  @author cao, 15-08-21 15:08:54
 *
 *  上部的单元格
 */
@property(nonatomic,strong)AW_MyinfoTopCell * topCell;
/**
 *  @author cao, 15-08-21 15:08:16
 *
 *  中间的单元格
 */
@property(nonatomic,strong)AW_MyinfoMiddleCell * middleCell;
/**
 *  @author cao, 15-08-21 15:08:29
 *
 *  下部的单元格
 */
@property(nonatomic,strong)AW_MyInfoBottomCell * bottomCell;
/**
 *  @author cao, 15-10-16 17:10:36
 *
 *  用来接个人资料的modal
 */
@property(nonatomic,strong)AW_PersonalInformationModal * personModal;

@end
@implementation AW_MyInfoDataSource

#pragma mark - GetData Menthod

-(void)getData{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    __weak typeof(self) weakSelf = self;
    //在这进行个人资料请求
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{@"userId":user_id};
    NSError * error  = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * infoDict = @{@"param":@"ownData",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager POST:ARTSCOME_INT parameters:infoDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0){
            //用户信息
            weakSelf.userDict = [responseObject[@"info"]valueForKey:@"user"];
            //收货地址信息
            weakSelf.adressDict = [responseObject[@"info"]valueForKey:@"delivery_address"];
            NSLog(@"%@",weakSelf.adressDict);
            //个人偏好数组
            weakSelf.hobbyArray = [responseObject[@"info"]valueForKey:@"hobby"];
            NSLog(@"%@",weakSelf.hobbyArray);
            NSArray * dataArray = @[@"上部cell",@"",@"中部cell",@"",@"下部cell"];
            AW_PersonalInformationModal *middleInfoModal = [[AW_PersonalInformationModal alloc]init];
            
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString * string = obj;
                if ([string isEqualToString:@"上部cell"]) {
                    AW_PersonalInformationModal * topInfoModal = [[AW_PersonalInformationModal alloc]init];
                    AW_DeliveryAdressModal * adressModal = [[AW_DeliveryAdressModal alloc]init];
                    //头部信息
                    topInfoModal.head_img = weakSelf.userDict[@"head_img"];
                    topInfoModal.nickname = weakSelf.userDict[@"nickname"];
                    topInfoModal.phone = weakSelf.userDict[@"phone"];
                    if (![weakSelf.adressDict isKindOfClass:[NSNull class]]) {
                        adressModal.deliveryAdress = weakSelf.adressDict[@"address"];
                        adressModal.adress_Id = weakSelf.adressDict[@"id"];
                    }
                    topInfoModal.adressModal = adressModal;
                    topInfoModal.rowHeight = 256;
                    topInfoModal.cellType = @"topCell";
                    [weakSelf.dataArr addObject:topInfoModal];
                }else if([string isEqualToString:@""]){
                    AW_PersonalInformationModal * separate = [[AW_PersonalInformationModal alloc]init];
                    separate.rowHeight = 8;
                    separate.cellType = @"sepratorCell";
                    [weakSelf.dataArr addObject:separate];
                }else if([string isEqualToString:@"中部cell"]){
                    
                    //中部信息
                        if ([self.userDict[@"birthday"]isKindOfClass:[NSNull class]]) {
                            middleInfoModal.birthday = @"";
                        }else{
                            middleInfoModal.birthday = self.userDict[@"birthday"];
                        }
                    
                    if ([self.userDict[@"hometown_province"]isKindOfClass:[NSNull class]]) {
                            middleInfoModal.hometown_province_id = @"";
                        
                        }else{
                            middleInfoModal.hometown_province_id = self.userDict[@"hometown_province"];
                  }
                if ([self.userDict[@"hometown_city"]isKindOfClass:[NSNull class]]) {
                        middleInfoModal.hometown_city_id = @"";
                    }else{
                   middleInfoModal.hometown_city_id = self.userDict[@"hometown_city"];
                   }
               if ([self.userDict[@"hometown_province_name"]isKindOfClass:[NSNull class]]) {
                        middleInfoModal.hometown_province_name = @"";
                }else{
                    middleInfoModal.hometown_province_name = self.userDict[@"hometown_province_name"];
                  }
                if ([self.userDict[@"hometown_city_name"]isKindOfClass:[NSNull class]]) {
                       middleInfoModal.hometown_city_name = @"";
                }else{
                    middleInfoModal.hometown_city_name = self.userDict[@"hometown_city_name"];
                 }
                if ([self.userDict[@"province_name"]isKindOfClass:[NSNull class]]) {
                        middleInfoModal.province_name = @"";
                }else{
                    middleInfoModal.province_name = self.userDict[@"province_name"];
                 }
                if ([self.userDict[@"city_name"]isKindOfClass:[NSNull class]]) {
                    middleInfoModal.city_name = @"";
               }else{
                  middleInfoModal.city_name = self.userDict[@"city_name"];
                }
                        if ([self.userDict[@"province"]isKindOfClass:[NSNull class]]) {
                            middleInfoModal.province_id = @"";                            
                        }else{
                            middleInfoModal.province_id = self.userDict[@"province"];
                        }
                        if ([self.userDict[@"city"]isKindOfClass:[NSNull class]]) {
                            middleInfoModal.city_id = @"";
                        }else{
                            middleInfoModal.city_id = self.userDict[@"city"];
                        }
                    if ([self.userDict[@"personal_label"] isKindOfClass:[NSNull class]]) {
                        middleInfoModal.personal_label = @"";
                      
                    }else{
                        middleInfoModal.personal_label = self.userDict[@"personal_label"];
                    }
                    //插入hobbyModal(如果存在是才插入)
                   // middleInfoModal.hobbyArray = [tmpArray copy];
                    NSMutableString * hobbyString = [[NSMutableString alloc]init];
                    NSMutableString * hobbyIdString = [[NSMutableString alloc]init];
                        if (self.hobbyArray.count > 0) {
                            NSMutableArray * tmpArray = [[NSMutableArray alloc]init];
                            [self.hobbyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSDictionary * dict = obj;
                                AW_HobbyModal * hobby = [[AW_HobbyModal alloc]init];
                                hobby.hobby_id = dict[@"id"];
                                NSLog(@"%@",dict[@"id"]);
                                hobby.hobbyName = dict[@"name"];
                                hobby.hobby_type = dict[@"type_no"];
                                [tmpArray addObject:hobby];
                                
                                
                                [hobbyString appendString:hobby.hobbyName];
                                [hobbyString appendString:@","];
                                [hobbyIdString appendString:[NSString stringWithFormat:@"%@",hobby.hobby_id]];
                                [hobbyIdString appendString:@","];

                            }];

                            middleInfoModal.hobbyString = hobbyString;
                            middleInfoModal.hobbyId = hobbyIdString;
                            NSLog(@"%@",hobbyIdString);
                            NSLog(@"%@",hobbyString);
                        }else{
                           middleInfoModal.hobbyString = @"";
                           middleInfoModal.hobbyId = @"";
                        }
                    middleInfoModal.rowHeight = 220;
                    middleInfoModal.cellType = @"middleCell";
                    [weakSelf.dataArr addObject:middleInfoModal];
                }else if([string isEqualToString:@"下部cell"]){
                    AW_PersonalInformationModal * bottomInfoModal = [[AW_PersonalInformationModal alloc]init];
                    //底部信息
                    if ([self.userDict[@"synopsis"] isKindOfClass:[NSNull class]]) {
                        bottomInfoModal.synopsis = @"";
                    }else if(self.userDict[@"synopsis"]){
                        bottomInfoModal.synopsis = self.userDict[@"synopsis"];
                    }
                    if ([self.userDict[@"signature"]isKindOfClass:[NSNull class]]) {
                        bottomInfoModal.signature = @"";
                    }else{
                        bottomInfoModal.signature = self.userDict[@"signature"];
                    }
                    bottomInfoModal.rowHeight = 236;
                    bottomInfoModal.cellType = @"bottomCell";
                    [weakSelf.dataArr addObject:bottomInfoModal];
                }
            }];
            [SVProgressHUD dismiss];
            [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
 
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_PersonalInformationModal * modal = self.dataArr[indexPath.row];
    
    if ([modal.cellType isEqualToString:@"topCell"]) {
        return [self configTopCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else if([modal.cellType isEqualToString:@"middleCell"]){
       return[self configMiddleCellWithModal:modal tableView:tableView indexPath:indexPath];
    
    }else if([modal.cellType isEqualToString:@"bottomCell"]){
       return [self configBottomCellWithModal:modal tableView:tableView indexPath:indexPath];
    }else {
     return [self configSeparateCellWithModal:modal tableView:tableView indexPath:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_PersonalInformationModal * modal = self.dataArr[indexPath.row];
    NSLog(@"%f",modal.rowHeight);
    return modal.rowHeight;
    
}

#pragma mark - ConfigTableView Menthod

-(AW_MyinfoTopCell*)configTopCellWithModal:(AW_PersonalInformationModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
   static NSString * cellId = @"topCell";
    AW_MyinfoTopCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_MyinfoTopCell");
        cell.backgroundColor = [UIColor whiteColor];
        //cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.nameText.clearButtonMode = UITextFieldViewModeAlways;
    //将从相册选择的图片设置为头像
    if (self.headImage) {
        [cell.headImageBtn setBackgroundImage:self.headImage forState:UIControlStateNormal];
    }else{
    [cell.headImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:modal.head_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }
    if (![modal.nickname isKindOfClass:[NSNull class]]) {
        cell.nameText.text = [NSString stringWithFormat:@"%@",modal.nickname];
    }
    NSLog(@"%@",modal.adressModal.deliveryAdress);
    if (modal.adressModal.deliveryAdress ) {
        cell.adressLabel.text = [NSString stringWithFormat:@"%@",modal.adressModal.deliveryAdress];
    }
    if (![modal.phone isKindOfClass:[NSNull class]]) {
        cell.phoneLabel.text = [NSString stringWithFormat:@"%@",modal.phone];
    }
    //点击cell的回调
    cell.selectKindBtn = ^(NSInteger idx){
        if (_didSelect) {
            _didSelect(idx);
        }
    };
    //昵称编辑改变时的回调
    cell.didEditeNickName = ^(NSString * nickName){
        modal.nickname = nickName;
    };
    return cell;
}

-(AW_MyinfoMiddleCell*)configMiddleCellWithModal:(AW_PersonalInformationModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_MyinfoMiddleCell * cell;
   static NSString * cellId = @"middleCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_MyinfoMiddleCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.birthdayLabel.text = [NSString stringWithFormat:@"%@",modal.birthday];
    NSString * province = [NSString stringWithFormat:@"%@",modal.hometown_province_name];
    NSString * city = [NSString stringWithFormat:@"%@",modal.hometown_city_name];
     cell.homeText.text = [province stringByAppendingString:city] ;
     cell.liveAdress.text = [[NSString stringWithFormat:@"%@",modal.province_name]stringByAppendingString:[NSString stringWithFormat:@"%@",modal.city_name]];
     cell.ownTagText.clearButtonMode = UITextFieldViewModeAlways;
     cell.ownTagText.text = [NSString stringWithFormat:@"%@",modal.personal_label];
     cell.preferenceLabel.text = [NSString stringWithFormat:@"%@",modal.hobbyString];
    //点击cell的回调
     cell.selectBtn = ^(NSInteger index){
        if (_didSelectCellBtn) {
            _didSelectCellBtn(index);
        }
    };
    //个人标签编辑后的回调
    cell.personLabelEdite = ^(NSString * str){
        if (str) {
            modal.personal_label = str;
        }
    };
    return cell;
}

-(AW_MyInfoBottomCell*)configBottomCellWithModal:(AW_PersonalInformationModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AW_MyInfoBottomCell  *cell;
    static NSString  *cellId = @"bottomCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_MyInfoBottomCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.ownSinerText.clearButtonMode = UITextFieldViewModeAlways;
     cell.ownSinerText.text = [NSString stringWithFormat:@"%@",modal.signature];
      cell.textView.text = [NSString stringWithFormat:@"%@",modal.synopsis];
    cell.textView.placeholder = @"简介:简单介绍下自己吧,120字以内";
    //点击取消登陆按钮的回调
    cell.didClickedCancleBtn = ^(){
        //获取UserDefaults单例
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //移除UserDefaults中存储的用户信息(如果存在才进行移除)
        NSString * nameString = [userDefaults objectForKey:@"name"];
        if(nameString) {
            [userDefaults removeObjectForKey:@"name"];
            [userDefaults removeObjectForKey:@"password"];
            [UserDefaults removeObjectForKey:@"user_id"];
            [userDefaults synchronize];
        }
        if (_didClickCancleBtn){
            _didClickCancleBtn();
        }
    };
    
    //编辑个性签名后的回调
    cell.signatureEdite = ^(NSString * str){
        if (str) {
            modal.signature = str;
        }
    };

    //编辑个人简介后的回调
    cell.synopsisEdite = ^(NSString * str){
        if (str) {
            modal.synopsis = str;
        }
    };
    return cell;
}

-(UITableViewCell *)configSeparateCellWithModal:(AW_PersonalInformationModal *)modal tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"separate";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

@end
