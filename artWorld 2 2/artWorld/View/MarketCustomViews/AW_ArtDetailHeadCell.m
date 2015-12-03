//
//  AW_ArtDetailHeadCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ArtDetailHeadCell.h"
#import "AW_Constants.h"
#import "UIImageView+WebCache.h"

@interface AW_ArtDetailHeadCell()<iCarouselDataSource,iCarouselDelegate>
/**
 *  @author cao, 15-10-23 15:10:35
 *
 *  轮播动画
 */
@property (nonatomic,strong)NSTimer *startAnimation;
/**
 *  @author cao, 15-10-23 20:10:38
 *
 *  右分割线
 */
@property(nonatomic,strong)CAShapeLayer * rightLayer;
/**
 *  @author cao, 15-10-24 16:10:12
 *
 *  下分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;
/**
 *  @author cao, 15-10-24 16:10:48
 *
 *  用于设置分割线的视图
 */
@property (weak, nonatomic) IBOutlet UIView *middleView;


@end

@implementation AW_ArtDetailHeadCell

-(CWStarRateView*)starRateView{
    if (!_starRateView) {
        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(8, 11, 100, 18) numberOfStars:5];
        _starRateView.allowIncompleteStar = YES;
        _starRateView.hasAnimation = NO;
        _starRateView.scorePercent = 0;
    }
    return _starRateView;
}

-(CAShapeLayer*)rightLayer{
    if (!_rightLayer) {
        _rightLayer = [[CAShapeLayer alloc]init];
        CGFloat lineWidth = 1.0f/([UIScreen mainScreen].scale);
        _rightLayer.frame = Rect(kSCREEN_WIDTH - 40 , 180+40, lineWidth,35);
        _rightLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _rightLayer;
}

-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineheight = 1.0f/([UIScreen mainScreen].scale);
        _bottomLayer.frame = Rect(0, 225+40, kSCREEN_WIDTH, lineheight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}

-(NSTimer *)startAnimation{
    if (!_startAnimation) {
        _startAnimation = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startLoop) userInfo:nil repeats:YES];
    }
    return _startAnimation;
}
//每3秒自动播放下一个广告
-(void)startLoop{
    NSInteger i = _icarouselView.currentItemIndex;
    i++;
    [_icarouselView scrollToItemAtIndex:i animated:YES];
}

/**
 *  @author cao, 15-10-10 11:07:24
 *
 *  刷新详情轮播页
 *
 *  @param adImageArr 商品详情图片数组
 */
-(void)setAdImageArr:(NSArray *)adImageArr{
    if (_adImageArr != adImageArr) {
        _adImageArr = adImageArr;
    }
    _pageControl.numberOfPages = adImageArr.count;
    [_icarouselView reloadData];
    [self.startAnimation fire];
}

#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.layer addSublayer:self.rightLayer];
    [self.layer addSublayer:self.bottomLayer];
    [self.starView addSubview:self.starRateView];
    _icarouselView.delegate = self;
    _icarouselView.dataSource = self;
    _icarouselView.pagingEnabled = YES;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor orangeColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//显示星星的个数(显示星级)
#pragma mark - ConfigStar Menthod
-(void)floatForStarViewWith:(NSString *)str{
    CGFloat starFloat = [str floatValue]/5.0;
    self.starRateView.scorePercent = starFloat;
}

#pragma mark - ButtonClicked Menthod
- (IBAction)buttonClicked:(id)sender {
    UIButton * btn = sender;
    _index = btn.tag;
    if (_didClickedBtn) {
        _didClickedBtn(_index);
    }
}

#pragma mark - IcarouselDataSource Menthod
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _adImageArr.count;
}

-(UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, 210)];
        UIImageView *adImageView = [[UIImageView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, 210)];
        adImageView.tag = 100;
        [view addSubview:adImageView];
        [_icarouselView bringSubviewToFront:_pageControl];
    }
    UIImageView *adImage = (UIImageView *)[view viewWithTag:100];
    NSString * imageURL = self.adImageArr[index];
    [adImage sd_setImageWithURL:[NSURL URLWithString:imageURL]placeholderImage:[UIImage imageNamed:@"default_art(1)"]];
    adImage.contentMode = UIViewContentModeScaleToFill;
    return view;
}

#pragma mark - IcarouselDeleGate Menthod

- (void)carouselDidScroll:(iCarousel *)carousel{
    _pageControl.currentPage = carousel.currentItemIndex;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    _index = index;
    //点击轮播图片的回调
    if (_didClickedICrouselView) {
        _didClickedICrouselView(_index,self.adImageArr);
    }
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

@end
