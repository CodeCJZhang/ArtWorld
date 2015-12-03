//
//  AW_ProduceFilterView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//
#import "AW_ProduceFilterView.h"
#import "AW_Constants.h"
#import "DeliveryAlertView.h"
#import "AW_FiterCellCell.h"
#import "UIImage+IMB.h"

@interface AW_ProduceFilterView()<UITableViewDataSource,UITableViewDelegate>
/**
 *  @author cao, 15-09-14 21:09:23
 *
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleVutton;
/**
 *  @author cao, 15-09-14 19:09:33
 *
 *  顶部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-09-14 19:09:42
 *
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIButton *bottomView;
/**
 *  @author cao, 15-09-14 19:09:41
 *
 *  上部分割线
 */
@property(nonatomic,strong)CAShapeLayer * topSeparator;
/**
 *  @author cao, 15-09-14 19:09:54
 *
 *  下部分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomSeparator;

/**
 *  @author cao, 15-09-14 20:09:45
 *
 *  筛选列表
 */
@property(nonatomic,strong)UITableView * filterTableView;
/**
 *  @author cao, 15-09-20 14:09:52
 *
 *  用来设置字体颜色
 */
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
@end

@implementation AW_ProduceFilterView
-(NSArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc]init];
    }
    return _dataArray;
}

-(UITableView*)filterTableView{
    if (!_filterTableView) {
        _filterTableView = [[UITableView alloc]initWithFrame:Rect(0, CGRectGetHeight(self.topView.frame), CGRectGetWidth(self.topView.frame), self.bounds.size.height - self.topView.frame.size.height - self.bottomView.frame.size.height)];
        _filterTableView.backgroundColor = [UIColor whiteColor];
        _filterTableView.delegate = self;
        _filterTableView.dataSource = self;
        _filterTableView.tableFooterView = [[UIView alloc]init];
    }
    return _filterTableView;
}
#pragma mark -Separator Menthod
-(CAShapeLayer *)topSeparator{
    if (!_topSeparator) {
        _topSeparator = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 3.0f/([UIScreen mainScreen].scale);
        _topSeparator.frame = Rect(0, 48, 280, lineHeight);
        _topSeparator.backgroundColor = HexRGB(0x87CEFA).CGColor;
    }
    return _topSeparator;
}

-(CAShapeLayer*)bottomSeparator{
    if (!_bottomSeparator) {
        _bottomSeparator = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _bottomSeparator.frame = Rect(0, 1, 280, lineHeight);
        _bottomSeparator.backgroundColor = HexRGB(0xcccccc).CGColor;
    }
    return _bottomSeparator;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    //self.filterLabel.textColor = HexRGB(0x87CEFA);
    [self.topView.layer addSublayer:self.topSeparator];
    [self.bottomView.layer addSublayer:self.bottomSeparator];
    [self addSubview:self.filterTableView];
    
    // 颜色变背景图片
    UIImage *selectBgImage = [UIImage imageWithColor:HexRGB(0x87CEFA)];
    selectBgImage = ResizableImageDataForMode(selectBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    self.cancleVutton.adjustsImageWhenHighlighted = YES;
    [self.cancleVutton setBackgroundImage:selectBgImage forState:UIControlStateHighlighted];
    [self.cancleVutton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

    // 颜色变背景图片
    UIImage *normalBgImage = [UIImage imageWithColor:HexRGB(0xFFFFFF)];
    normalBgImage = ResizableImageDataForMode(normalBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.cancleVutton setBackgroundImage:normalBgImage forState:UIControlStateNormal];
}

#pragma mark - ButtonClick Menthod

- (IBAction)cancleBtnClicked:(id)sender {

    DeliveryAlertView * alertView = (DeliveryAlertView*)self.superview;
    [alertView hideWithoutAnimation];
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count + 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString * cellId = @"filterCell";
    AW_FiterCellCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_FiterCellCell");
    }
    UIView * backgroungView = [[UIView alloc]initWithFrame:cell.bounds];
    backgroungView.layer.backgroundColor = HexRGB(0x87CEFA).CGColor;
    cell.selectedBackgroundView = backgroungView;
    if (indexPath.row == 0){
        cell.filterType.text = [NSString stringWithFormat:@"全部分类(%ld)",self.classArtNum];
    }else{
        AW_ArtWorkModal * modal = self.dataArray[indexPath.row -1];
        NSLog(@"===%@===",modal.class_name);
        cell.filterType.text = [NSString stringWithFormat:@"%@(%ld)",modal.class_name,[modal.class_num integerValue]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate Menthod
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        AW_ArtWorkModal * modal = [[AW_ArtWorkModal alloc]init];
        modal.class_name = @"全部分类";
        modal.class_num = [NSString stringWithFormat:@"%ld",self.classArtNum];
        self.queryModal = modal;
    }else{
        AW_ArtWorkModal * modal = self.dataArray[indexPath.row - 1];
        self.queryModal = modal;
    }
    if (_didClickCell) {
        _didClickCell(self.queryModal);
    }
    DeliveryAlertView * alertView = (DeliveryAlertView*)self.superview;
    [alertView hideWithoutAnimation];
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
