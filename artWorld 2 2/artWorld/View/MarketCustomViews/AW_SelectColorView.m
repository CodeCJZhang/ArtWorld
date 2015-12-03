//
//  AW_SelectColorView.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/25.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_SelectColorView.h"
#import "AW_Constants.h"
#import "UIImage+IMB.h"
#import "WaterFLayout.h"
#import "AW_collectionViewColorCell.h"
#import "AW_ColorModal.h"

@interface AW_SelectColorView()<UICollectionViewDataSource,UICollectionViewDelegate>

/**
 *  @author cao, 15-10-25 11:10:42
 *
 *  确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
/**
 *  @author cao, 15-11-26 15:11:05
 *
 *  颜色collectionView
 */
@property(nonatomic,strong)UICollectionView * colorCollectionView;
/**
 *  @author cao, 15-11-26 16:11:49
 *
 *  颜色数组
 */
@property(nonatomic,strong)NSArray * colorArray;
/**
 *  @author cao, 15-11-26 16:11:13
 *
 *  记录颜色
 */
@property(nonatomic,strong)NSString * colorString;

@end

@implementation AW_SelectColorView

#pragma mark - Private Menthod

-(void)setColorArray:(NSArray *)colorArray{
    if (!_colorArray) {
        NSMutableArray * array = [[NSMutableArray alloc]init];
        [colorArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * str = obj;
            AW_ColorModal * modal = [[AW_ColorModal alloc]init];
            modal.coloredString = str;
            modal.isSelect = NO;
            [array addObject:modal];
        }];
        [array removeLastObject];
        _colorArray = [NSArray arrayWithArray:array];
        
    }
    [_colorCollectionView reloadData];
}

-(UICollectionView*)colorCollectionView{
    if (!_colorCollectionView) {
        WaterFLayout * layout = [[WaterFLayout alloc]init];
        layout.columnCount = 3;
        _colorCollectionView = [[UICollectionView alloc]initWithFrame:Rect(0, 96, kSCREEN_WIDTH, 132) collectionViewLayout:layout];
        _colorCollectionView.userInteractionEnabled = YES;
        _colorCollectionView.alwaysBounceVertical = YES;
        
        UINib * cellNib = [UINib nibWithNibName:@"AW_collectionViewColorCell" bundle:nil];
        [_colorCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"colorCell"];
        _colorCollectionView.dataSource = self;
        _colorCollectionView.delegate = self;
        _colorCollectionView.backgroundColor = [UIColor clearColor];

    }
    return _colorCollectionView;
}

#pragma mark - LifeCycle Menthod

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.colorCollectionView];
    // 颜色变背景图片
    UIImage *normalBgImage = [UIImage imageWithColor:HexRGB(0xD4D4D4)];
    normalBgImage = ResizableImageDataForMode(normalBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    //选中时的颜色
    UIImage *selectBgImage = [UIImage imageWithColor:HexRGB(0x88c244)];
    selectBgImage = ResizableImageDataForMode(selectBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    
    [self.confirmBtn setBackgroundImage:selectBgImage forState:UIControlStateNormal];
}

- (IBAction)buttonClicked:(id)sender {
    UIButton * btn  = sender;
    _index = btn.tag;
    btn.selected = !btn.selected;
    
    if (_didClickedBtns) {
        _didClickedBtns(_index);
    }
}

#pragma mark - UICollectionViewDataSource  Menthod
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.colorArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AW_collectionViewColorCell * cell;
    static NSString * cellId = @"colorCell";
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    AW_ColorModal * modal = self.colorArray[indexPath.item];
    cell.iterm = indexPath.item;
    [cell.colorButton setTitle:modal.coloredString forState:UIControlStateNormal];
    cell.colorButton.selected = modal.isSelect;
      
    //点击cell的回调
    cell.didClickedBtn = ^(NSInteger index){
        //改变界面的值
        __block NSString* colorString;
        [self.colorArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AW_ColorModal * tmp = self.colorArray[idx];
            NSIndexPath * path = [NSIndexPath indexPathForItem:idx inSection:0];
            AW_collectionViewColorCell * tmpCell  = (AW_collectionViewColorCell*)[collectionView cellForItemAtIndexPath:path];
            if (index == idx) {
                if (tmp.isSelect == YES) {
                  tmpCell.colorButton.selected = NO;
                  tmp.isSelect = NO;
                }else{
                  tmpCell.colorButton.selected = YES;
                  tmp.isSelect = YES;
                  colorString = tmp.coloredString;
                }
                
            }else{
                tmpCell.colorButton.selected = NO;
                tmp.isSelect = NO;
            }
        }];
            if (_clickedColorBtnCell){
                _clickedColorBtnCell(colorString);
            }
        
    };

    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 33);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//左右cell间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 8.0f;
}
//上下cell间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 8.0f;
}

#pragma mark - UICollectionViewDelegate Menthod

//cell是否可以被选中
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//选中cell对象后调用
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
