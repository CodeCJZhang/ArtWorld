//
//  AW_ConnectStoreView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ConnectStoreView.h"
#import "DeliveryAlertView.h"
#import "AW_Constants.h"
#import "UIImage+IMB.h"
#import "AW_StoreNameCell.h"//店家名称cell
#import "AW_MyShopCartModal.h"

@interface AW_ConnectStoreView()<UITableViewDataSource,UITableViewDelegate>
/**
 *  @author cao, 15-09-21 15:09:07
 *
 *  上分割线
 */
@property(nonatomic,strong)CAShapeLayer * topLayer;
/**
 *  @author cao, 15-09-21 15:09:16
 *
 *  下分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;
/**
 *  @author cao, 15-09-21 15:09:41
 *
 *  上部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-09-21 16:09:36
 *
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/**
 *  @author cao, 15-09-21 15:09:34
 *
 *  店铺名称列表
 */
@property(nonatomic,strong)UITableView * storeNameTableView;

@end

@implementation AW_ConnectStoreView

-(UITableView*)storeNameTableView{
    if (!_storeNameTableView) {
        _storeNameTableView = [[UITableView alloc]init];
        _storeNameTableView.dataSource = self;
        _storeNameTableView.delegate = self;
        _storeNameTableView.separatorColor = HexRGB(0xe6e6e6);
        _storeNameTableView.tableFooterView = [[UIView alloc]init];
        _storeNameTableView.backgroundColor = [UIColor clearColor];
    }
    return _storeNameTableView;
}

-(NSArray*)storeNameArray{
    if (!_storeNameArray) {
        _storeNameArray = [[NSArray alloc]init];
    }
    return _storeNameArray;
}

-(CAShapeLayer*)topLayer{
    if (!_topLayer) {
        _topLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 3.0/([UIScreen mainScreen].scale);
        _topLayer.frame = Rect(0, 55, 280, lineHeight);
        _topLayer.backgroundColor = HexRGB(0x87CEFA).CGColor;
    }
    return _topLayer;
}

-(CAShapeLayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeight = 1.0f/([UIScreen mainScreen].scale);
        _bottomLayer.frame = Rect(0, 1, 280, lineHeight);
        _bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    }
    return _bottomLayer;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = HexRGB(0xf6f7f8);
    [self.layer addSublayer:self.topLayer];
    [self.cancleBtn.layer addSublayer:self.bottomLayer];
    //颜色转背景图片
    UIImage * selectImage = [UIImage imageWithColor:HexRGB(0x87CEFA)];
    selectImage = ResizableImageDataForMode(selectImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.cancleBtn setBackgroundImage:selectImage forState:UIControlStateHighlighted];
    //添加tableView
    [self addSubview:self.storeNameTableView];
    self.storeNameTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.storeNameTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.storeNameTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
     [self addConstraint:[NSLayoutConstraint constraintWithItem:self.storeNameTableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
     [self addConstraint:[NSLayoutConstraint constraintWithItem:self.storeNameTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cancleBtn attribute:NSLayoutAttributeTop multiplier:1.0 constant:1]];
}

#pragma mark - ButtonClicked Menthod
- (IBAction)cancleBtnClicked:(id)sender {
    
    DeliveryAlertView * alertView = (DeliveryAlertView*)self.superview;
    [alertView hide];
}

#pragma mark - UITableViewDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storeNameArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MyShopCartModal * modal = self.storeNameArray[indexPath.row];
    static NSString * cellId = @"storeNameCell";
    AW_StoreNameCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = BundleToObj(@"AW_StoreNameCell");
    }
    UIView * backGroundView = [[UIView alloc]initWithFrame:cell.bounds];
    backGroundView.backgroundColor = HexRGB(0x87CEFA);
    cell.selectedBackgroundView = backGroundView;
    cell.sstoreNameLabel.text = modal.storeModal.shop_Name;
    return cell;
}

#pragma mark - UITableViewDelegate Menthod
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AW_MyShopCartModal * modal = self.storeNameArray[indexPath.row];
    //点击cell某一行的回调
    self.storeModal = modal;
    if (_didClickedCell) {
        _didClickedCell(_storeModal);
    }
    DeliveryAlertView * alertView = (DeliveryAlertView*)self.superview;
    [alertView hide];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
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
