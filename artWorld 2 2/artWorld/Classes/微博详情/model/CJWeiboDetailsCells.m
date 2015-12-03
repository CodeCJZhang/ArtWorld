//
//  CJWeiboDetailsCells.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/23.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJWeiboDetailsCells.h"
#import "CJParameter.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AW_Constants.h"

#define padding 8
//#define viewW self.contentView.frame.size.width

@interface CJWeiboDetailsCells ()

//屏宽
@property (nonatomic,assign) CGFloat W;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *name;

//VIP
@property (weak, nonatomic) IBOutlet UIImageView *vip;

//时间
@property (weak, nonatomic) IBOutlet UILabel *time;

//昵称简介
@property (weak, nonatomic) IBOutlet UILabel *nameDesc;

//微博正文
@property (weak, nonatomic) IBOutlet UILabel *photoDesc;

//图片集合
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *photoArr;

//图片数据集合
@property (nonatomic,strong) NSMutableArray *imageArr;

//地址
@property (weak, nonatomic) IBOutlet UIButton *address;

//底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//cell
@property (nonatomic,strong) CJWeiboDetailsCells *cell;


//图片到微博
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoToDesc;

//图片到头像
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoToIcon;

//地址到微博
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addToDesc;

//地址到第一行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addToFirst;

//地址到第二行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addToSecond;

//地址到第三行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addToThird;

//底视图到微博
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToDesc;

//底视图到第一行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToFirst;

//底视图到第二行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToSecond;

//底视图到第三行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToThird;

//底视图到地址
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToAdd;

@end


@implementation CJWeiboDetailsCells

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSMutableArray *)imageArr
{
    if (!_imageArr)
    {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

-(CJWeiboDetailsCells *)createCellWithParameter:(CJParameter *)cellParameter
{
    CJWeiboDetailsCells *cell = [[[NSBundle mainBundle]loadNibNamed:@"CJWeiboDetailsCells" owner:nil options:nil] firstObject];
    
    //头像
    NSURL *url = [NSURL URLWithString:cellParameter.icon];
    [cell.icon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
    
    //昵称
    cell.name.text = cellParameter.name;
    
    //VIP
    if (cellParameter.isVIP == 3)
    {
        cell.vip.hidden = NO;
    }
    else
    {
        cell.vip.hidden = YES;
    }
    
    //正文
    cell.photoDesc.text = cellParameter.weiBo;
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    double timestamp = [cellParameter.time doubleValue] / 1000;
    NSTimeInterval interval = timestamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *time = [formatter stringFromDate:date];
    cell.time.text = time;
    
    //图片集
    if (cellParameter.photoes.length != 0)
    {
        NSArray *temp = [cellParameter.photoes componentsSeparatedByString:@","];
        cell.imageArr = [NSMutableArray arrayWithArray:temp];
        NSLog(@"cell.imageArr = %@",cell.imageArr);
        NSInteger i = 1;
        while (i)
        {
            if ([cell.imageArr containsObject:@""])
            {
                [cell.imageArr removeObject:@""];
            }
            else{
                i = 0;
            }
        }
        NSLog(@"cell.imageArr = %@",cell.imageArr);
    }
    
    //地址显示
    BOOL isShow = cellParameter.address.length != 0;
    if (isShow)
    {
        cell.address.hidden = NO;
        [cell.address setTitle:cellParameter.address forState:UIControlStateNormal];
    }
    else
    {
        cell.address.hidden = YES;
    }
    _cell = cell;
    
    [self hasText:cell.photoDesc.text ImageArray:cell.imageArr showAddress:isShow];
    
    return _cell;
}

-(void)hasText:(NSString*)text ImageArray:(NSArray *)imageArray showAddress:(BOOL)isShow
{
    NSInteger photoCount = imageArray.count;
    if (text)
    {
        _cell.photoDesc.hidden = NO;
        _cell.photoToIcon.priority = 998;
        if (_cell.photoToDesc.priority != 999)
        {
            _cell.photoToDesc.priority = 999;
        }
    }
    else
    {
        _cell.photoDesc.hidden = YES;
        _cell.photoToDesc.priority = 998;
        if (_cell.photoToIcon.priority != 999) {
            _cell.photoToIcon.priority = 999;
        }
    }
    
    if (isShow == YES)
    {
        if (photoCount > 0 && photoCount < 4)
        {
            _cell.addToFirst.priority = 999;
            _cell.addToSecond.priority = 998;
            _cell.addToThird.priority = 997;
            _cell.addToDesc.priority = 996;
        }
        else if (photoCount > 3 && photoCount < 7)
        {
            _cell.addToSecond.priority = 999;
            _cell.addToThird.priority = 998;
            _cell.addToFirst.priority = 997;
            _cell.addToDesc.priority = 996;
        }
        else if (photoCount > 6 && photoCount < 10)
        {
            _cell.addToThird.priority = 999;
            _cell.addToSecond.priority = 998;
            _cell.addToFirst.priority = 997;
            _cell.addToDesc.priority = 996;
        }
        else
        {
            _cell.addToDesc.priority = 999;
            _cell.addToFirst.priority = 998;
            _cell.addToSecond.priority = 997;
            _cell.addToThird.priority =996;
        }
    }
    else
    {
        if (photoCount > 0 && photoCount < 4)
        {
            _cell.bottomToFirst.priority = 999;
            _cell.bottomToSecond.priority = 998;
            _cell.bottomToThird.priority = 997;
            _cell.bottomToDesc.priority = 996;
            _cell.bottomToAdd.priority = 995;
        }
        else if (photoCount > 3 && photoCount < 7)
        {
            _cell.bottomToFirst.priority = 997;
            _cell.bottomToSecond.priority = 999;
            _cell.bottomToThird.priority = 998;
            _cell.bottomToDesc.priority = 996;
            _cell.bottomToAdd.priority = 995;
        }
        else if (photoCount > 6 && photoCount < 10)
        {
            _cell.bottomToFirst.priority = 997;
            _cell.bottomToSecond.priority = 998;
            _cell.bottomToThird.priority = 999;
            _cell.bottomToDesc.priority = 996;
            _cell.bottomToAdd.priority = 995;
        }
        else
        {
            _cell.bottomToFirst.priority = 998;
            _cell.bottomToSecond.priority = 997;
            _cell.bottomToThird.priority = 996;
            _cell.bottomToDesc.priority = 999;
            _cell.bottomToAdd.priority = 995;
        }
    }
    
    //隐藏无图片的button
    [_cell.photoArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = obj;
        if (idx < photoCount) {
            button.hidden = NO;
        }else{
            button.hidden = YES;
        }
    }];
    
    //为button附加图片
    if (photoCount > 0 && photoCount < 10) {
        for (NSInteger i = 0; i < photoCount; i++) {
            UIButton *btn = _cell.photoArr[i];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageArray[i]] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE];
        }
    }
}

@end
