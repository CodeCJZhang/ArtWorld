//
//  AW_MyFansDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyFansDataSource.h"
#import "AW_MyattentionCell.h"//我的粉丝cell和我的关注cell相同
#import "AW_FansModal.h" //我的粉丝modal
#import "UIImageView+WebCache.h"//SDWebImage
#import "AW_MyFansTableHeadView.h"//我的粉丝tableView头视图
#import "AFNetworking.h"
#import "AW_DeleteAlertMessage.h"
#import "DeliveryAlertView.h"

@interface AW_MyFansDataSource()
/**
 *  @author cao, 15-08-20 21:08:49
 *
 *  头部视图
 */
@property(nonatomic,strong)AW_MyFansTableHeadView * headView;
/**
 *  @author cao, 15-11-09 21:11:49
 *
 *  他的粉丝头视图
 */
@property(nonatomic,strong)AW_MyFansTableHeadView * otherHeadView;
/**
 *  @author cao, 15-10-27 15:10:55
 *
 *  记录总页数
 */
@property(nonatomic,copy)NSString * totolPage;
/**
 *  @author cao, 15-10-27 15:10:08
 *
 *  当前的页数
 */
@property(nonatomic,copy)NSString * currentPage;
/**
 *  @author cao, 15-09-18 15:09:51
 *
 *  粉丝数组
 */
@property(nonatomic,strong)NSMutableArray * fansArray;

@end

@implementation AW_MyFansDataSource

-(AW_MyFansTableHeadView*)headView{
    if (!_headView) {
        _headView = BundleToObj(@"AW_MyFansTableHeadView");
    }
    return _headView;
}

-(AW_MyFansTableHeadView*)otherHeadView{
    if (!_otherHeadView) {
        _otherHeadView = [[NSBundle mainBundle]loadNibNamed:@"AW_MyFansTableHeadView" owner:self options:nil][1];
    }
    return _otherHeadView;
}

-(NSMutableArray*)fansArray{
    if (!_fansArray) {
        _fansArray = [[NSMutableArray alloc]init];
    }
    return _fansArray;
}

#pragma mark - GetData Menthod
-(void)getData{
     __weak typeof(self)  weakSelf = self;
    //在这进行请求
    NSLog(@"%@",self.person_id);
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    if (!user_id) {
        user_id = @"";
    }
    NSDictionary * dict = @{@"personId":self.person_id,
                            @"userId":user_id,
                            @"pageSize":@"10",
                            @"pageNumber":self.currentPage,
                            };
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * fansDict = @{@"param":@"othersFans",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:fansDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSArray * fansArray = [responseObject[@"info"]valueForKey:@"data"];
        if ([responseObject[@"code"]intValue] == 0) {
            [fansArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * fansDict = obj;
                //插入粉丝列表
                AW_FansModal * fanListModal = [[AW_FansModal alloc]init];
                AW_UserModal * userModal = [[AW_UserModal alloc]init];
                fanListModal.userModal = userModal;
                userModal.user_id = fansDict[@"id"];
                userModal.user_hxid = fansDict[@"phone"];
                userModal.head_img = fansDict[@"head_img"];
                userModal.nickname = fansDict[@"nickname"];
                userModal.signature = fansDict[@"signature"];
                userModal.authentication_state = fansDict[@"authentication_state"];
                fanListModal.isAttended = [fansDict[@"isAttended"]boolValue];
                [weakSelf.dataArr addObject:fanListModal];
            }];
            if (([weakSelf.currentPage intValue]*10 < [weakSelf.totolPage intValue]) && [weakSelf.totolPage intValue] > 10) {
                self.tableView.footerHidden = NO;
            }else{
                self.tableView.footerHidden = YES;
            }
            [self dataDidLoad];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

/**
 *  @author cao, 15-08-18 15:08:57
 *
 *  刷新粉丝数据
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
#pragma mark - UITableViewDataSource Menthod

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    if (!([self.person_id intValue] == [user_id intValue])) {
      self.tableView.tableHeaderView = self.otherHeadView;
    }else{
     self.tableView.tableHeaderView = self.headView;
    }
    self.tableView.tableFooterView = [[UIView alloc]init];
    AW_FansModal * fansModal;
    if (self.dataArr.count > 0) {
       fansModal  = self.dataArr[indexPath.row];
    }
    
    static NSString * cellIdentifier  = @"MyFansCell";
    /**
     *  @author cao, 15-08-18 15:08:33
     *
     *  我的粉丝cell和我的关注cell为同一个
     */
    AW_MyattentionCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = BundleToObj(@"AW_MyattentionCell");
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.portraitImage sd_setImageWithURL:[NSURL URLWithString:fansModal.userModal.head_img]placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",fansModal.userModal.nickname];
    if (![fansModal.userModal.signature isKindOfClass:[NSNull class]]) {
        cell.describLabel.text = [NSString stringWithFormat:@"%@",fansModal.userModal.signature];
    }
    if ([fansModal.userModal.authentication_state intValue] == 3) {
        cell.vipImage.image = [UIImage imageNamed:@"vip图标"];
        cell.vipImage.hidden = NO;
    }else{
        cell.vipImage.hidden = YES;
    }
    if (fansModal.isAttended == YES) {
        cell.rightButton.selected = YES;
        [self.fansArray addObject:fansModal];
    }else if(fansModal.isAttended == NO) {
        cell.rightButton.selected = NO;
    }
    //滚动时也让按钮显示对应的状态
    if (self.fansArray.count > 0) {
        if ([self.fansArray containsObject:fansModal]) {
            cell.rightButton.selected = YES;
        }else{
            cell.rightButton.selected = NO;
        }
    }
    //点击cell上的关注按钮的回调
    __weak typeof(cell) weakCell = cell;
    cell.didClickAttentionBtn = ^(NSInteger index){
        UIView * v = [weakCell.rightButton superview];
        AW_MyattentionCell * cell = (AW_MyattentionCell*)[v superview];
        NSIndexPath * path = [tableView indexPathForCell:cell];
        AW_FansModal * modal = self.dataArr[path.row];
        NSLog(@"关注的人的名字=====%@====",modal.userModal.nickname);
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]) {//如果是登陆状态
            if (cell.rightButton.selected == YES) {
                //在这进行添加关注请求
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                NSString * user_id = [user objectForKey:@"user_id"];
                NSLog(@"%@",modal.userModal.user_id);
                NSDictionary * dict = @{@"personId":modal.userModal.user_id,@"userId":user_id};
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
                NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary * attendict = @{@"param":@"addAttention",@"jsonParam":str};
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:ARTSCOME_INT parameters:attendict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSLog(@"%@",responseObject);
                    if ([responseObject[@"code"]intValue] == 0) {
                        //请求成功后改变modal值
                        if (![self.fansArray containsObject:modal]) {
                            [self.fansArray addObject:modal];
                            modal.isAttended = YES;
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    NSLog(@"%@",[error localizedDescription]);
                }];
            }else if (cell.rightButton.selected == NO){
                
                //在这进行取消关注请求
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                NSString * user_id = [user objectForKey:@"user_id"];
                NSLog(@"%@",modal.userModal.user_id);
                NSDictionary * dict = @{@"personId":modal.userModal.user_id,@"userId":user_id};
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
                NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary * cancleDict = @{@"param":@"cancelAttention",@"jsonParam":str};
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:ARTSCOME_INT parameters:cancleDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSLog(@"%@",responseObject);
                    if ([responseObject[@"code"]intValue] == 0) {
                        //请求成功后改变modal值
                        if ([self.fansArray containsObject:modal]) {
                            [self.fansArray removeObject:modal];
                            modal.isAttended = NO;
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    NSLog(@"%@",[error localizedDescription]);
                }];   
            }
        }else{
            //如果是没有登录状态就跳转到登陆界面
            DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
            AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:self options:nil][1];
            contentView.bounds = Rect(0, 0, 272, 130);
            alertView.contentView = contentView;
            [alertView showWithoutAnimation];
            //点击确定或取消按钮的回调(弹出视图)
            contentView.didClickedBtn = ^(NSInteger index){
                if (index == 1) {
                    if (_didClickedFansConfirmBrn) {
                        _didClickedFansConfirmBrn();
                    }
                }else if(index == 2){
                    NSLog(@"点击了取消按钮。。。");
                }
            };
        }
        
    };
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return cell;
}

#pragma mark - UITableViewDelegate Menthod

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0f;
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



@end
