//
//  AW_CheckPhoneDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_CheckPhoneDataSource.h"
#import "NSString+Convert.h"
#import "AW_CheckPhoneManModal.h"
#import "AW_CheckPhonePersonCell.h"
#import "UIImage+IMB.h"
#import "MBProgressHUD.h"
#import <AddressBook/AddressBook.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface AW_CheckPhoneDataSource()
/**
 *  @author cao, 15-09-15 21:09:18
 *
 *  索引数组
 */
@property(nonatomic,strong)NSMutableArray * indexArray;
/**
 *  @author cao, 15-09-15 21:09:28
 *
 *  电话联系人字典
 */
@property(nonatomic,strong)NSMutableDictionary * phoneDictionry;
/**
 *  @author cao, 15-11-13 17:11:11
 *
 *  电话联系人数组（电话联系人，联系人名称）
 */
@property(nonatomic,strong)NSMutableDictionary * adressBookDict;

@end

@implementation AW_CheckPhoneDataSource

-(NSMutableDictionary*)adressBookDict{
    if (!_adressBookDict) {
        _adressBookDict = [[NSMutableDictionary alloc]init];
    }
    return _adressBookDict;
}

-(NSMutableDictionary*)phoneDictionry{
    if (!_phoneDictionry) {
        _phoneDictionry = [[NSMutableDictionary alloc]init];
    }
    return _phoneDictionry;
}
-(NSMutableArray*)indexArray{
    if (!_indexArray) {
        _indexArray = [[NSMutableArray alloc]init];
    }
    return _indexArray;
}

#pragma mark - GetAddressBook Menthod
//获取打开权限
- (void)loadPerson{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            [self copyAddressBook:addressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
           
        });
    }
}

//然后循环获取每个联系人的信息,建个model存起来。
- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for ( int i = 0; i < numberOfPeople; i++){
        //获取手机联系人姓名
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        if (firstName == nil) {
            firstName = @"";
        }else if (lastName == nil){
            lastName = @"";
        }
        NSString * person_name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        if (!person_name) {
            person_name = @"";
        }else{
            person_name = person_name;
        }
        NSLog(@"%@",person_name);
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++){
            //获取电话Label
           // NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            NSArray  * array= [personPhone componentsSeparatedByString:@"-"];
            NSMutableString * person_phone = [[NSMutableString alloc]init];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString * str = obj;
                [person_phone appendString:str];
            }];
            NSLog(@"%@",person_phone);
            if (![self.adressBookDict.allKeys containsObject:person_name] && person_name) {
                [self.adressBookDict setValue:person_name forKey:person_phone];
            }
        }
    }
}

#pragma mark - GetData Menthod
-(void)getData{
    //获取手机联系人电话和姓名
    [self loadPerson];
    __weak typeof(self) weakSelf = self;
    NSMutableString * phoneString = [[NSMutableString alloc]init];
    [[self.adressBookDict allKeys]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * str = obj;
        [phoneString appendString:str];
        [phoneString appendString:@","];
    }];
    NSLog(@"%@",phoneString);
   //在这进行请求
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{@"userId":user_id,@"phones":phoneString};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * phoneDict = @{@"param":@"getUserByMaillist",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:phoneDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSArray * phoneArray  =  responseObject[@"info"];
        if ([responseObject[@"code"]intValue] == 0) {
            [phoneArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * tmpDict = obj;
                AW_CheckPhoneManModal * modal = [[AW_CheckPhoneManModal alloc]init];
                modal.nickname = tmpDict[@"nickname"];
                modal.person_name = [self.adressBookDict valueForKey:tmpDict[@"phone"]];
                modal.person_id = tmpDict[@"id"];
                modal.isAttended = [tmpDict[@"isAttended"]boolValue];
                modal.head_img = tmpDict[@"head_img"];
                modal.phone = tmpDict[@"phone"];
                modal.person_name_pinyin = [modal.person_name convertToPinYinWithoutTone];
                
                NSString * key = [[modal.person_name_pinyin substringToIndex:1]uppercaseString];
                NSLog(@"%@",key);
                NSMutableArray * phoneArray = self.phoneDictionry[key];
                if (!phoneArray) {
                    phoneArray = [[NSMutableArray alloc]init];
                    [self.phoneDictionry setValue:phoneArray forKey:key];
                    self.indexArray = [[[self.phoneDictionry allKeys]sortedArrayUsingSelector:@selector(compare:)] copy];
                }
                [phoneArray addObject:modal];
 
            }];
             [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
   
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * keyString = self.indexArray[section];
    NSArray * tmpArray = self.phoneDictionry[keyString];
    return tmpArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * key = self.indexArray[indexPath.section];
    NSArray * tmpArray = self.phoneDictionry[key];
    AW_CheckPhoneManModal * modal = tmpArray[indexPath.row];
   static NSString * cellId = @"checkCell";
    AW_CheckPhonePersonCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_CheckPhonePersonCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    cell.indexPath = indexPath;
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:modal.head_img] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",modal.person_name];
    cell.smallNameLabel.text = [NSString stringWithFormat:@"%@",modal.nickname];
    if (modal.isAttended == YES) {
        cell.attentionBtn.selected = YES;
    }else{
        cell.attentionBtn.selected = NO;
    }
    //店家关注按钮的回调
    __weak typeof(cell) weakCell = cell;
    cell.didClickAttentionBtn = ^(NSIndexPath *indexPath){
        NSString * key = self.indexArray[indexPath.section];
        NSArray * tmpArray = self.phoneDictionry[key];
        AW_CheckPhoneManModal * modal1 = tmpArray[indexPath.row];
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * user_id = [user objectForKey:@"user_id"];
        if (modal1.isAttended == NO) {
            
            //添加关注请求
            NSDictionary * dict = @{@"personId":modal1.person_id,@"userId":user_id};
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * attentionDict = @{@"param":@"addAttention",@"jsonParam":str};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:attentionDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    modal1.isAttended = YES;
                    weakCell.attentionBtn.selected = YES;
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"%@",[error localizedDescription]);
            }];
        }else if (modal1.isAttended == YES){
            
           //取消关注请求
            NSDictionary * dict = @{@"personId":modal1.person_id,@"userId":user_id};
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
            NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * attentionDict = @{@"param":@"cancelAttention",@"jsonParam":str};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:attentionDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    modal1.isAttended = NO;
                    weakCell.attentionBtn.selected = NO;
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"%@",[error localizedDescription]);
            }];
        }
    };

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDekegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//让分割线显示完全
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    //return self.indexArray;
    NSMutableArray * indexArray = [[NSMutableArray alloc]init];
    for(char c ='A';c<='Z';c++){
        //当前字母
        NSString *zimu=[NSString stringWithFormat:@"%c",c];
        if (![zimu isEqualToString:@"I"]&&![zimu isEqualToString:@"O"]&&![zimu                                                                  isEqualToString:@"U"]&&![zimu isEqualToString:@"V"]){
            [indexArray addObject:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return indexArray;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23;
}

//点击索引时调用
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    _sectionTitle = title;
    if (_didClickedSectionIndex) {
        _didClickedSectionIndex(_sectionTitle);
    }
    NSLog(@"%@",title);
    NSLog(@"%ld",index);
    if ([self.indexArray containsObject:title]) {
        NSInteger index1 = [self.indexArray indexOfObject:title];
        return index1;
    }else{
      return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, 23)];
    UILabel * keyLabel = [[UILabel alloc]initWithFrame:Rect(8, 0, kSCREEN_WIDTH, 23)];
    [headView addSubview:keyLabel];
    keyLabel.text = self.indexArray[section];
    keyLabel.font = [UIFont systemFontOfSize:15];
    keyLabel.textColor = [UIColor lightGrayColor];
    return headView;
}

//uitableview处理section的不悬浮，禁止section停留的方法
/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 23;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}*/

@end
