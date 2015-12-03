//
//  AW_DeliveryAdressDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/1.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_DeliveryAdressDataSource.h"
#import "AW_DeliveryAdressCell.h"
#import "AW_AddDeliveyAdressCell.h"
#import "AW_DeliveryAdressAlertView.h" //弹出添加收货地址视图
#import "DeliveryAlertView.h"
#import "AW_DeliveryAdressModal.h"
#import "UIImage+IMB.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

@interface AW_DeliveryAdressDataSource()
/**
 *  @author cao, 15-10-10 15:10:15
 *
 *  删除的收货地址的索引
 */
@property(nonatomic)NSInteger tmpIndex;
/**
 *  @author cao, 15-09-07 09:09:32
 *
 *  添加收货地址cell
 */
@property(nonatomic,strong)AW_AddDeliveyAdressCell * addAdressCell;
/**
 *  @author cao, 15-09-07 09:09:50
 *
 *  收货地址cell
 */
@property(nonatomic,strong)AW_DeliveryAdressCell * deliveryCell;

@end

@implementation AW_DeliveryAdressDataSource

#pragma mark - Private Menthod
-(AW_DeliveryAdressCell*)deliveryCell{
    if (!_deliveryCell) {
        _deliveryCell = BundleToObj(@"AW_DeliveryAdressCell");
    }
    return _deliveryCell;
}
-(AW_AddDeliveyAdressCell*)addAdressCell{
    if (!_addAdressCell) {
        _addAdressCell = BundleToObj(@"AW_AddDeliveyAdressCell");
    }
    return _addAdressCell;
}

-(AW_DeliveryAdressModal*)freshAdressModal{
    if (!_freshAdressModal) {
        _freshAdressModal = [[AW_DeliveryAdressModal alloc]init];
    }
    return _freshAdressModal;
}

-(AW_DeliveryAdressModal*)editeModal{
    if (!_editeModal) {
        _editeModal = [[AW_DeliveryAdressModal alloc]init];
    }
    return _editeModal;
}

#pragma mark - GetData Menthod

-(void)getData{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在加载数据" maskType:SVProgressHUDMaskTypeBlack];
    //在这请求收货地址
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{@"userId":user_id};
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * str = [[NSString  alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * adressDict = @{@"jsonParam":str,@"token":@"",@"param":@"getAddress"};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:adressDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
            NSArray * adressArray = responseObject[@"info"];
            if (adressArray.count > 0) {
                [adressArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary * dict = obj;
                    AW_DeliveryAdressModal * modal = [[AW_DeliveryAdressModal alloc]init];
                    modal.deliveryName = dict[@"name"];
                    modal.deliveryAdress = dict[@"address"];
                    modal.deliveryPhoneNumber = dict[@"phone"];
                    modal.adress_Id = dict[@"id"];
                    modal.is_default = dict[@"is_default"];
                    if ([modal.is_default intValue] == 1) {
                        [weakSelf.dataArr insertObject:modal atIndex:0];
                    }else{
                      [weakSelf.dataArr addObject:modal];
                        //请求成功后的回调
                        if (_didRequestSucess) {
                            _didRequestSucess();
                        }
                    }
                }];
                [SVProgressHUD dismiss];
            }
        }
        [self dataDidLoad];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误消息：%@",[error localizedDescription]);
    }];
}
#pragma mark - ShowAlertView Menthod
/**
 *  @author cao, 15-09-07 17:09:42
 *
 *  点击编辑按钮后调用
 *
 *  @param modal 收货地址modal
 */
-(void)showAlertViewWithModal:(AW_DeliveryAdressModal*)modal{
    DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
    AW_DeliveryAdressAlertView * contentView = BundleToObj(@"AW_DeliveryAdressAlertView");
    contentView.frame = Rect(0, 0, 280, 236);
    if (modal) {
        contentView.deliveryName.text = modal.deliveryName;
        contentView.deliveryPhoneNumber.text = modal.deliveryPhoneNumber;
        contentView.deliveryAdress.text = modal.deliveryAdress;
        NSLog(@"%@",modal.is_default);
        contentView.didClickConfirmBtn = ^(AW_DeliveryAdressModal * tmpModal){
#warning 点击确定后刷新数据
            //点击确定按钮后进行回调，重新刷新数据
            self.editeModal.deliveryName = tmpModal.deliveryName;
            self.editeModal.deliveryAdress = tmpModal.deliveryAdress;
            self.editeModal.deliveryPhoneNumber = tmpModal.deliveryPhoneNumber;
            self.editeModal.adress_Id =  modal.adress_Id;
            self.editeModal.is_default = modal.is_default;
            if (_didClickedEditeConfirmBtn) {
                _didClickedEditeConfirmBtn(self.editeModal);
            }
        };
    }
    alertView.contentView = contentView;
    [alertView show];
}
/**
 *  @author cao, 15-09-07 17:09:23
 *
 *  添加收货地址
 */
-(void)addDeliveryAdress{
    DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
    AW_DeliveryAdressAlertView * contentView = BundleToObj(@"AW_DeliveryAdressAlertView");
    contentView.bounds = Rect(0, 0, 280, 236);
    //点击确定按钮后的回调(收货人，电话，收货地址都存在才插入到数组)
    contentView.didClickConfirmBtn = ^(AW_DeliveryAdressModal * modal){
        NSLog(@"%@",modal.adress_Id);
            self.freshAdressModal = modal;
        if (_didClickedConfirmButton) {
            _didClickedConfirmButton(self.freshAdressModal);
        }
    };
    alertView.contentView = contentView;
    [alertView show];
}

#pragma mark - UITableViewDataSource Menthod

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //把添加收货地址的那一列也加进来
    return self.dataArr.count + 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString * cellId = @"addDeliveryAdressCell";
    AW_AddDeliveyAdressCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_AddDeliveyAdressCell");
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    static NSString * adressCellId = @"adressCell";
    AW_DeliveryAdressCell * adressCell = [tableView dequeueReusableCellWithIdentifier:adressCellId];
    if (!adressCell) {
        adressCell = BundleToObj(@"AW_DeliveryAdressCell");
        adressCell.backgroundColor = [UIColor clearColor];
        adressCell.contentView.backgroundColor = [UIColor clearColor];
    }
    /**
     *  @author cao, 15-09-02 16:09:02
     *
     *  赋值
     */
    if (indexPath.row == 0) {
        //选中时的背景视图
        UIView * backgroungView = [[UIView alloc]initWithFrame:cell.bounds];
        UIView * backgroungView1 = [[UIView alloc]initWithFrame:Rect(8, 8, kSCREEN_WIDTH - 16, 34)];
        backgroungView.backgroundColor = HexRGB(0x87CEEB);
        backgroungView1.backgroundColor = [UIColor whiteColor];
        [backgroungView addSubview:backgroungView1];
        backgroungView1.clipsToBounds = YES;
        backgroungView1.layer.cornerRadius = 6.0f;
        cell.selectedBackgroundView = backgroungView;
        return cell;
    }else {
        AW_DeliveryAdressModal * modal = self.dataArr[indexPath.row - 1];
        //选中时的背景视图
        UIView * backgroungView = [[UIView alloc]initWithFrame:adressCell.bounds];
        UIView * backgroungView1 = [[UIView alloc]initWithFrame:Rect(8, 8, kSCREEN_WIDTH - 16, 104)];
        backgroungView.backgroundColor = HexRGB(0x87CEEB);
        backgroungView1.backgroundColor = [UIColor whiteColor];
        [backgroungView addSubview:backgroungView1];
        backgroungView1.clipsToBounds = YES;
        backgroungView1.layer.cornerRadius = 6.0f;
        adressCell.selectedBackgroundView = backgroungView;
        adressCell.deliveryPerson.text = modal.deliveryName;
        adressCell.deliveryAdress.text = modal.deliveryAdress;
        adressCell.deliveryPhoneNumber.text = modal.deliveryPhoneNumber;
        //获取选中了哪个cell
        adressCell.Index = indexPath.row;
        
        if ([modal.is_default intValue] == 1) {
            adressCell.defealtImageBtn.selected = YES;
        }else if ([modal.is_default intValue] == 0){
            adressCell.defealtImageBtn.selected = NO;
        }
        //点击cell上的编辑按钮后的回调
        //将adressCell变为weak类型
        __weak typeof(adressCell) weakAdressCell = adressCell;
        adressCell.didClickEditeBtn = ^(NSInteger index){
            /**
             *  @author cao, 15-09-07 15:09:14
             *
             *  用来判断点击的编辑按钮属于哪个cell(通过点击的编辑按钮获得cell的索引)
             *  通过button的父视图一级一级的向上找，直到找到cell(通过层级关系获得按钮所在cell)
             */
            UIView *v = [weakAdressCell.editeBtn superview];
            UIView *v1 = [v superview];
            UIView *v2 = [v1 superview];
            UIView *v3 = [v2 superview];
            //获取button所在的cell
            AW_DeliveryAdressCell *cell = (AW_DeliveryAdressCell *)[v3 superview];
            //获取cell对应的section和row
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            NSLog(@"选中了第%ld个cell的编辑按钮",cellIndexPath.row);
            self.adressIndex = cellIndexPath.row ;
            AW_DeliveryAdressModal * adressModal1 = self.dataArr[self.adressIndex - 1];
            NSLog(@"%ld",self.adressIndex - 1);
            NSLog(@"%@",adressModal1.adress_Id);
            if (!adressModal1.adress_Id) {
                //adress_id 不存在
                //在这请求收货地址
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                NSString * user_id = [user objectForKey:@"user_id"];
                NSDictionary * dict = @{@"userId":user_id};
                NSError * error = nil;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                NSString * str = [[NSString  alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary * adressDict = @{@"jsonParam":str,@"token":@"",@"param":@"getAddress"};
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:ARTSCOME_INT parameters:adressDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSArray * adressArray = responseObject[@"info"];
                    if (adressArray.count > 0) {
                        [adressArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict = obj;
                            NSLog(@"%@",dict);
                            if (self.adressIndex - 1 == idx) {
                                adressModal1.adress_Id = dict[@"id"];
                                adressModal1.is_default = dict[@"is_default"];
                            }
                        }];
                         [self showAlertViewWithModal:adressModal1];
                    }
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    
                }];
            }else{
                //adress_id 存在
             [self showAlertViewWithModal:adressModal1];
            }
        };
         //点击cell上的设为默认地址按钮后的回调
        adressCell.didClickDefaultBtn = ^(NSInteger index){
            AW_DeliveryAdressModal * adressModal = self.dataArr[index - 1];
            NSLog(@"%ld",index);
            NSLog(@"%ld",self.dataArr.count);
            //如果不是默认收货地址才进行请求
            if ([adressModal.is_default intValue] == 0){
                if (!adressModal.adress_Id){
                   //不存在adress_id
                    [SVProgressHUD showWithStatus:@"正在加载数据" maskType:SVProgressHUDMaskTypeBlack];
                    //在这请求收货地址
                    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                    NSString * user_id = [user objectForKey:@"user_id"];
                    NSDictionary * dict = @{@"userId":user_id};
                    NSError * error = nil;
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                    NSString * str = [[NSString  alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSDictionary * adressDict = @{@"jsonParam":str,@"token":@"",@"param":@"getAddress"};
                    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                    [manager POST:ARTSCOME_INT parameters:adressDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSLog(@"%@",responseObject);
                        if ([responseObject[@"code"]intValue] == 0) {
                            NSArray * adressArray = responseObject[@"info"];
                            if (adressArray.count > 0) {
                                [adressArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    NSDictionary * dict = obj;
                                    if (index - 1 == idx) {
                                        adressModal.adress_Id = dict[@"id"];
                                    }
                                }];
                                
                                //在这进行请求设为默认收货地址请求
                                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                                NSString * user_id = [user objectForKey:@"user_id"];
                                NSLog(@"%@",adressModal.adress_Id);
                                NSDictionary * dict = @{
                                                        @"id":adressModal.adress_Id,
                                                        @"name":adressModal.deliveryName,
                                                        @"phone":adressModal.deliveryPhoneNumber,
                                                        @"address":adressModal.deliveryAdress,
                                                        @"is_default":@"1",
                                                        @"user_id":user_id,
                                                        };
                                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
                                NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                                NSDictionary * defaultDict = @{@"jsonParam":str,@"token":@"",@"param":@"updateAddress"};
                                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                                [manager POST:ARTSCOME_INT parameters:defaultDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                    NSLog(@"%@",responseObject);
                                    if ([responseObject[@"code"]intValue] == 0) {
                                        //请求默认收货地址成功后,再改变modal的值
                                        adressModal.is_default = @"1";
                                        [self.dataArr removeObject:adressModal];
                                        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                            AW_DeliveryAdressModal * modal =  obj;
                                            modal.is_default = @"0";
                                        }];
                                        
                                        [self.dataArr insertObject:adressModal atIndex:0];
                                        [self.tableView reloadData];
                                        //设置默认收货地址成功后的回调
                                        _Modal = adressModal;
                                        if (_defaultAdressSucess) {
                                            _defaultAdressSucess(_Modal);
                                        }
                                    }
                                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                    NSLog(@"%@",[error localizedDescription]);
                                }];
                                
                                [SVProgressHUD dismiss];
                            }
                        }

                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        NSLog(@"错误消息：%@",[error localizedDescription]);
                    }];
                    //存在adress_id
                }else{
                    [SVProgressHUD showWithStatus:@"请稍后" maskType:SVProgressHUDMaskTypeBlack];
                    //在这进行请求设为默认收货地址请求
                    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                    NSString * user_id = [user objectForKey:@"user_id"];
                    NSLog(@"%@",adressModal.adress_Id);
                    NSDictionary * dict = @{
                                            @"id":adressModal.adress_Id,
                                            @"name":adressModal.deliveryName,
                                            @"phone":adressModal.deliveryPhoneNumber,
                                            @"address":adressModal.deliveryAdress,
                                            @"is_default":@"1",
                                            @"user_id":user_id,
                                            };
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
                    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSDictionary * defaultDict = @{@"jsonParam":str,@"token":@"",@"param":@"updateAddress"};
                    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                    [manager POST:ARTSCOME_INT parameters:defaultDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSLog(@"%@",responseObject);
                        if ([responseObject[@"code"]intValue] == 0) {
                            //请求默认收货地址成功后,再改变modal的值
                            adressModal.is_default = @"1";
                            [self.dataArr removeObject:adressModal];
                            [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                AW_DeliveryAdressModal * modal =  obj;
                                modal.is_default = @"0";
                                [SVProgressHUD dismiss];
                            }];

                            [self.dataArr insertObject:adressModal atIndex:0];
                            [self.tableView reloadData];
                            //设置默认收货地址成功后的回调
                            _Modal = adressModal;
                            if (_defaultAdressSucess) {
                                _defaultAdressSucess(_Modal);
                            }
                        }
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }];
                }
            }else{
               //如果已经是默认收货地址，进行提示
                if (_isDefaultAdress) {
                    _isDefaultAdress();
                }
            }
        };
         //点击cell上的删除按钮后的回调
        adressCell.didClickDeleteBtn = ^(NSInteger index){
            UIView *v = [weakAdressCell.deleteBtn superview];
            UIView *v1 = [v superview];
            UIView *v2 = [v1 superview];
            UIView *v3 = [v2 superview];
            AW_DeliveryAdressCell *cell = (AW_DeliveryAdressCell *)[v3 superview];
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            NSLog(@"选中了第%ld个cell删除按钮",cellIndexPath.row);
            self.tmpIndex = cellIndexPath.row - 1;
            //在这进行请求删除收货地址 (请求成功后再删除数据)
            AW_DeliveryAdressModal * modal = self.dataArr[self.tmpIndex];
            if (!modal.adress_Id) {
                //adress_id 不存在
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                NSString * user_id = [user objectForKey:@"user_id"];
                NSDictionary * dict = @{@"userId":user_id};
                NSError * error = nil;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                NSString * str = [[NSString  alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary * adressDict = @{@"jsonParam":str,@"token":@"",@"param":@"getAddress"};
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:ARTSCOME_INT parameters:adressDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSArray * adressArray = responseObject[@"info"];
                    if (adressArray.count > 0) {
                        [adressArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict = obj;
                            NSLog(@"%@",dict);
                            if (self.tmpIndex == idx) {
                                modal.adress_Id = dict[@"id"];
                                modal.is_default = dict[@"is_default"];
                            }
                        }];
                        //请求删除订单
                        NSLog(@"收货地址id==%@==",modal.adress_Id);
                        NSDictionary * dict = @{@"id":modal.adress_Id};
                        NSError * error = nil;
                        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                        NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSDictionary * deleteDict = @{@"jsonParam":str,@"token":@"android",@"param":@"delAddress"};
                        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                        [manager POST:ARTSCOME_INT parameters:deleteDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                            NSLog(@"%@",responseObject);
                            if ([responseObject[@"code"]intValue] == 0) {
                                //(请求成功以后) 点击删除按钮后将数据从dataArray中删除，并刷新数据
                                [SVProgressHUD showWithStatus:@"正在删除" maskType:SVProgressHUDMaskTypeBlack];
                                [SVProgressHUD dismissAfterDelay:1];
                                [self performSelector:@selector(deleteMenthod) withObject:nil afterDelay:1];
                                if (_didClickedDeleteBtn) {
                                    _didClickedDeleteBtn(self.tmpIndex);
                                }
                            }
                        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                            NSLog(@"错误消息：%@",[error localizedDescription]);
                        }];
                    }
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    
                }];
            }else{
                [SVProgressHUD showWithStatus:@"正在删除" maskType:SVProgressHUDMaskTypeBlack];
              //adress_id 存在
                //请求删除订单
                NSLog(@"收货地址id==%@==",modal.adress_Id);
                NSDictionary * dict = @{@"id":modal.adress_Id};
                NSError * error = nil;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary * deleteDict = @{@"jsonParam":str,@"token":@"android",@"param":@"delAddress"};
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:ARTSCOME_INT parameters:deleteDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSLog(@"%@",responseObject);
                    if ([responseObject[@"code"]intValue] == 0) {
                        //(请求成功以后) 点击删除按钮后将数据从dataArray中删除，并刷新数据
                        [SVProgressHUD dismissAfterDelay:1];
                        [self performSelector:@selector(deleteMenthod) withObject:nil afterDelay:1];
                        if (_didClickedDeleteBtn) {
                            _didClickedDeleteBtn(self.tmpIndex);
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    NSLog(@"错误消息：%@",[error localizedDescription]);
                }];
            
            }
        };
        return adressCell;
    }
}
-(void)deleteMenthod{
    [self.dataArr removeObjectAtIndex:self.tmpIndex];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate Menthod

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }else{
        return 120;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self addDeliveryAdress];
    }else{
        AW_DeliveryAdressModal * modal = self.dataArr[indexPath.row - 1];
        _addressModal = modal;
        if (_didSelectAdressCell) {
            _didSelectAdressCell(_addressModal);
        }
        //使用代理将modal传到上一个界面
        [_delegate didClickAdressCell:modal];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
   //添加动画效果
}

@end
