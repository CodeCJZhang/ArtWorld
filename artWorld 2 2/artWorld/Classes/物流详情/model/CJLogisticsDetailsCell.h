//
//  CJLogisticsDetailsCell.h
//  artWorld
//
//  Created by 张晓旭 on 15/9/1.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJLogisticsDetailsCell : UITableViewCell

/**################⬇️ details1 ⬇️###################*/
//物流图标
@property (weak, nonatomic) IBOutlet UIImageView *icon;

//物流名称
@property (weak, nonatomic) IBOutlet UILabel *logisticsName;

//运单编号
@property (weak, nonatomic) IBOutlet UILabel *waybillNumber;

//物流状态
@property (weak, nonatomic) IBOutlet UILabel *logisticsState;


/**################⬇️ details2 ⬇️###################*/
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsName;

//商品描述
@property (weak, nonatomic) IBOutlet UILabel *goodsDesign;

//商品价格
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;

//商品数量
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;


/**################⬇️ details3 ⬇️###################*/

//物流状态
@property (weak, nonatomic) IBOutlet UILabel *state1;

//物流当前时间
@property (weak, nonatomic) IBOutlet UILabel *time1;

//物流圆标示图
@property (weak, nonatomic) IBOutlet UIButton *roundMarked1;

//物流线标示图
@property (weak, nonatomic) IBOutlet UIView *lineMarked1;


/**################⬇️ details4 ⬇️###################*/

//物流状态
@property (weak, nonatomic) IBOutlet UILabel *state2;

//物流当前时间
@property (weak, nonatomic) IBOutlet UILabel *time2;

//物流圆标示图
@property (weak, nonatomic) IBOutlet UIButton *roundMarked2;

//物流线标示图
@property (weak, nonatomic) IBOutlet UIView *lineMarked2;

/**################⬇️ details5 ⬇️###################*/

//物流状态
@property (weak, nonatomic) IBOutlet UILabel *state3;

//物流当前时间
@property (weak, nonatomic) IBOutlet UILabel *time3;

//物流圆标示图
@property (weak, nonatomic) IBOutlet UIButton *roundMarked3;

//物流线标示图
@property (weak, nonatomic) IBOutlet UIView *lineMarked3;

@end
