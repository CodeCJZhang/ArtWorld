//
//  AW_SimalaryProduceCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_SimalaryProduceCell.h"
#import "AW_SimilaryCollectionViewCell.h"//相似艺术品cell
#import "AW_ArtDetailModal.h"//艺术品详情modal
#import "UIButton+WebCache.h"
#import "AW_Constants.h"

@interface AW_SimalaryProduceCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation AW_SimalaryProduceCell

/**
 *  @author cao, 15-10-23 11:07:45
 *
 *  刷新相似数组
 *
 *  @param similary
 */
-(void)setKindArr:(NSArray *)similaryArr{
    if (_similaryArray != similaryArr) {
        _similaryArray = similaryArr;
    }
    [_similaryCollectionView reloadData];
}

#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    self.similaryCollectionView.delegate = self;
    self.similaryCollectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(80, 80);
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.similaryCollectionView.collectionViewLayout = layout;
    UINib *cellNib = [UINib nibWithNibName:@"AW_SimilaryCollectionViewCell" bundle:nil];
    [self.similaryCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"SimilaryCell"];
    self.similaryCollectionView.showsHorizontalScrollIndicator = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark UICollectionView Datasource Delegate Method

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _similaryArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"SimilaryCell";
    AW_SimilaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    //进行赋值
    AW_DetailSimilaryModal * modal = self.similaryArray[indexPath.row];
    if (modal) {
        NSLog(@"%@",modal.clear_img);
        if ([modal.clear_img isEqualToString:@""]) {
            [cell.btnImage setBackgroundImage:PLACE_HOLDERIMAGE forState:UIControlStateNormal];
        }else{
           
            [cell.btnImage sd_setBackgroundImageWithURL:[NSURL URLWithString:modal.clear_img] forState:UIControlStateNormal];
        }
        cell.index = indexPath.item;
    }
        // 点击相似艺术品视图回调
      cell.didClickedBtn = ^(NSInteger index){
          NSLog(@"%ld",index);
          if (_didClickSimilaryCell) {
              _didClickSimilaryCell(index);
          }
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(65,65);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(0, 10, 0,10);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

@end
