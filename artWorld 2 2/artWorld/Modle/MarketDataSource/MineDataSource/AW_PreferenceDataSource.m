//
//  AW_PreferenceDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/2.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_PreferenceDataSource.h"
#import "WaterFLayout.h"
#import "IMB_AlertView.h"
#import "AW_MyPreferenceCell.h"//偏好设置cell
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface AW_PreferenceDataSource()<UICollectionViewDelegateFlowLayout>
/**
 *  @author cao, 15-09-02 18:09:58
 *
 *  选择偏好cell
 */
@property(nonatomic,strong)AW_MyPreferenceCell * preferenceCell;
/**
 *  @author cao, 15-10-26 09:10:32
 *
 *  偏好数组
 */
@property(nonatomic,strong)NSArray * hobbyArray;

@end

@implementation AW_PreferenceDataSource

#pragma mark - Private Menthod
-(AW_MyPreferenceCell*)preferenceCell{
    if (!_preferenceCell) {
        _preferenceCell = BundleToObj(@"AW_MyPreferenceCell");
    }
    return _preferenceCell;
}

-(NSMutableArray*)selectModalArray{
    if (!_selectModalArray) {
        _selectModalArray = [[NSMutableArray alloc]init];
    }
    return _selectModalArray;
}

-(NSMutableArray*)indexArray{
    if (!_indexArray) {
        _indexArray = [[NSMutableArray alloc]init];
    }
    return _indexArray;
}

#pragma mark - Release method

- (void)dealloc{
    [self releaseResources];
    NSLog(@"%@ dealloc ...",NSStringFromClass([self class]));
}

//释放资源
-(void)releaseResources{
    self.collectionView = nil;
    _didSelectObjectBlock = nil;
    [_dataArray removeAllObjects];
    _dataArray = nil;
}

#pragma mark - Init Menthod

-(id)initWithDidSelectObjectBlock:(DidSelectObjectBlock)didSelectObjectBlock{
    self = [super init];
    if (self) {
        self.didSelectObjectBlock = didSelectObjectBlock;
    }
    return self;
}
-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSArray*)hobbyArray{
    if (!_hobbyArray) {
        _hobbyArray = [[NSArray alloc]init];
    }
    return _hobbyArray;
}

#pragma mark - GetData Menthod

-(void)getData{
    __weak typeof(self) weakSelf = self;
    //进行请求获取偏好数据
    NSDictionary * dict = @{};
    NSError * error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * preferenceDict = @{@"param":@"getType",@"jsonparam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:preferenceDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"响应信息：%@",responseObject);
        if ([responseObject[@"code"]intValue] == 0) {
          weakSelf.hobbyArray = [responseObject[@"info"] copy];
            NSLog(@"%@",weakSelf.hobbyArray);
            NSLog(@"%@",self.hobbyArray);
            //进行赋值
            [responseObject[@"info"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                AW_MyPreferenceModal * modal = [[AW_MyPreferenceModal alloc]init];
                NSDictionary * dict = obj;
                modal.preferenceDes = dict[@"name"];
                modal.hobby_id = dict[@"id"];
                [weakSelf.dataArray addObject:modal];
            }];
            [_collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",[error localizedDescription]);
    }];
}

#pragma mark - UICollectionViewDataSource  Menthod
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyPreferenceCell * cell;
    static NSString * cellId = @"preferenceCell";
    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        AW_MyPreferenceModal * modal = self.dataArray[indexPath.item];
        NSString * str = [modal.preferenceDes substringToIndex:1];
        cell.preferenceLabel.text = modal.preferenceDes;
        cell.bigLabel.text = [NSString stringWithFormat:@"%@",str];
        cell.id = modal.hobby_id;
    }
    /**
     *  @author cao, 15-09-06 19:09:55
     *
     *  选中cell后改变button的状态
     */
    NSNumber * objNumber = [NSNumber numberWithInteger:indexPath.item];
    if ([self.indexArray containsObject:objNumber]) {
        cell.selectBtn.hidden = NO;
    }else{
        cell.selectBtn.hidden = YES;
    }
    
    cell.layer.cornerRadius = 5.0f;
    cell.clipsToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 120);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

//左右cell间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 15.0f;
}
//上下cell间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 15.0f;
}

#pragma mark - UICollectionViewDelegate Menthod

//cell是否可以被选中
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//选中cell对象后调用
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        if (self.dataArray.count > 0) {
            NSLog(@"选中了第%ld个",indexPath.item);
            /**
             *  @author cao, 15-09-06 11:09:31
             *
             *  将选中的cell的数据保存到selectModalArray数组中
             *  如果不存在才插入，存在就删除(连续选择了2次)
             */
            AW_MyPreferenceModal * modal = self.dataArray[indexPath.item];
            if (![self.selectModalArray containsObject:modal]) {
                [self.selectModalArray addObject:modal];
            }else if([self.selectModalArray containsObject:modal]){
                [self.selectModalArray removeObject:modal];
            }
        }
    //当cell被选中时，选中按钮显示，当再次点击时选中按钮隐藏(将选中的cell索引存入数组)
    NSInteger index = indexPath.item;
    NSNumber* indexObject = [NSNumber numberWithInteger:index];
    if (![self.indexArray containsObject:indexObject]) {
        [self.indexArray addObject:indexObject];
    }else if([self.indexArray containsObject:indexObject]){
        [self.indexArray removeObject:indexObject];
    }
    /**
     *  @author cao, 15-09-06 19:09:55
     *
     *  选中cell后改变button的状态(只写这个方法不行，cell重用会混乱，还有上面一个方法)
     */
    NSNumber *objNumber = [NSNumber numberWithInteger:indexPath.item];
    AW_MyPreferenceCell * cell = (AW_MyPreferenceCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if ([self.indexArray containsObject:objNumber]) {
        cell.selectBtn.hidden = NO;
    }else{
        cell.selectBtn.hidden = YES;
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
