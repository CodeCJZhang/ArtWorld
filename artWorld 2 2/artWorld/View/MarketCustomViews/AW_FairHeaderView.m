//
//  AW_FairHeaderView.m
//  artWorld
//
//  Created by 张亚哲 on 15/7/10.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import "AW_FairHeaderView.h"
#import "AW_Constants.h"
#import "iCarousel.h"
#import "UIImageView+WebCache.h"
#import "MarketViewController.h"
#import "AW_FairKindCell.h"//类别
#import "AW_MarketModal.h"//市集modal

@interface AW_FairHeaderView()<iCarouselDataSource,iCarouselDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/**
 *  @author zhe, 15-07-10 11:07:59
 *
 *  广告切换页 
 */
@property (weak, nonatomic) IBOutlet iCarousel *adView;
/**
 *  @author zhe, 15-07-10 11:07:12
 *
 *  显示原点
 */
@property (weak, nonatomic) IBOutlet UIPageControl *adPageControl;
/**
 *  @author zhe, 15-07-10 11:07:19
 *
 *  分类展示视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *kindCollectionView;

@property (nonatomic,strong)NSTimer *startAnimation;


//@property (nonatomic,strong)MarketViewController *mvc;

@end

@implementation AW_FairHeaderView

//- (MarketViewController *)mvc {
//    if (!_mvc) {
//        _mvc = [[MarketViewController alloc]init];
//    }
//    return _mvc;
//}

-(NSTimer *)startAnimation{
    if (!_startAnimation) {
        _startAnimation = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startLoop) userInfo:nil repeats:YES];
    }
    return _startAnimation;
}

-(void)awakeFromNib{
    [self config];
}

-(void)config{
    _adView.dataSource = self;
    _adView.delegate = self;
    _kindCollectionView.dataSource = self;
    _kindCollectionView.delegate = self;
    _adView.pagingEnabled = YES;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(80, 80);
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _kindCollectionView.collectionViewLayout = layout;
    UINib *cellNib = [UINib nibWithNibName:@"AW_FairKindCell" bundle:nil];
    [_kindCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"kindCell"];
    
    _kindCollectionView.showsHorizontalScrollIndicator = NO;
    
    _adPageControl.currentPage = 0;
    _adPageControl.pageIndicatorTintColor = [UIColor orangeColor];
    _adPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
}

/**
 *  @author zhe, 15-07-10 11:07:24
 *
 *  刷新广告页
 *
 *  @param adImageArr 广告页数组
 */
-(void)setAdImageArr:(NSArray *)adImageArr{
    if (_adImageArr != adImageArr) {
        _adImageArr = adImageArr;
    }
    _adPageControl.numberOfPages = adImageArr.count;
    [_adView reloadData];
    [self.startAnimation fire];
}
/**
 *  @author zhe, 15-07-10 16:07:59
 *
 *  设置3s自动轮播下一个广告
 */
-(void)startLoop{
    NSInteger i = _adView.currentItemIndex;
    i++;
    [_adView scrollToItemAtIndex:i animated:YES];
}

/**
 *  @author zhe, 15-07-10 11:07:45
 *
 *  刷新分类
 *
 *  @param kindArr
 */
-(void)setKindArr:(NSArray *)kindArr{
    if (_kindArr != kindArr) {
        _kindArr = kindArr;
    }
    [_kindCollectionView reloadData];
}

#pragma mark icarousel Datasource Delegate Method

// 点击轮播头视图
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击了%ld",(long)index);
    // 点击轮播头视图回调
    if (_didSelectFair) {
        _didSelectFair(index);
    }
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _adImageArr.count;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    _adPageControl.currentPage = carousel.currentItemIndex;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, 150)];
        UIImageView *adImageView = [[UIImageView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, 150)];
        adImageView.tag = 100;
        [view addSubview:adImageView];
        [_adView bringSubviewToFront:_adPageControl];
    }
    UIImageView *adImage = (UIImageView *)[view viewWithTag:100];
    //NSLog(@"%ld",self.adImageArr.count);
    if (_adImageArr.count > 0) {
        AW_MarketModal * modal = _adImageArr[index];
        //判断网络状态和是否开启了省流量模式
        NSString *ImageURL;
        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
        if ([[user objectForKey:@"patternState"]isEqualToString:@"yes"]&&[[user objectForKey:@"NetState"]isEqualToString:@"切换到WWAN网络"]) {
           ImageURL = modal.carouselModal.artwork_fuzzyImage;
        }else{
           ImageURL = modal.carouselModal.artwork_clearImage;
        }
        
        [adImage sd_setImageWithURL:[NSURL URLWithString:ImageURL] placeholderImage:TMP_IMAGE completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        adImage.contentMode = UIViewContentModeScaleToFill;
    }
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
            break;
            
        default:
            break;
    }
    return value;
}

#pragma mark UICollectionView Datasource Delegate Method

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _kindArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"kindCell";
    AW_FairKindCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    //为热门分类视图进行赋值
    AW_MarketModal * modal = self.kindArr[indexPath.item];
    if (modal) {
        [cell.kingImageView sd_setImageWithURL:[NSURL URLWithString:modal.hotClassModal.class_image] placeholderImage:PLACE_HOLDERIMAGE];
        cell.kingImageView.contentMode = UIViewContentModeScaleToFill;
        cell.kingTitle.text = modal.hotClassModal.class_name;
        cell.index = indexPath.item;
        // 点击热门分类视图回调
        cell.selectKindBtn = ^(NSInteger idx){
            if (_didSelect) {
                _didSelect(idx);
            }
          };
        }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80,80);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
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

-(void)releaseResource{
    [_startAnimation invalidate];
    _startAnimation = nil;
}

-(void)dealloc{
    [_startAnimation invalidate];
    _startAnimation = nil;
}

@end
