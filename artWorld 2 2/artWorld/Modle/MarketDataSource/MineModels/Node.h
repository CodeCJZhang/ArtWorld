//
//  Node.h
//  myJob
//
//  Created by 张亚哲 on 15-3-19.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Node : NSObject
/**
 *  @author zhe, 15-07-16 17:07:57
 *
 *  是否有分割线
 */
@property (nonatomic) BOOL hasSeparate;
/**
 *  父节点
 */
@property (nonatomic,weak) Node *parentNode;

/**
 *  名称
 */
@property (nonatomic,copy) NSString *name;

/**
 *  @author zhe, 15-06-18 09:06:20
 *
 *  id
 */
@property (nonatomic,copy) NSString *idstr;

/**
 *  值
 */
@property (nonatomic,copy) NSString *value;

/**
 *  @author zhe, 15-06-18 14:06:52
 *
 *  列表cell高度
 */
@property (nonatomic,assign) float rowHeight;

/**
 *  图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  选中图片
 */
@property (nonatomic, strong) UIImage *selectImage;

/**
 *  是否有孩子
 */
@property (nonatomic) BOOL hasChild;

/**
 *  是否已展开
 */
@property (nonatomic) BOOL expand;

/**
 *  是否可以展开
 */
@property (nonatomic) BOOL canExpand;

/**
 *  @Author jason  yan, 15-01-25 20:01:20
 *
 *  是否可以编辑
 */
@property (nonatomic) BOOL canEdit;

/**
 *  @Author jason  yan, 15-01-25 20:01:04
 *
 *  是否需要缩进
 */
@property (nonatomic) BOOL needIndent;

/**
 *  @Author jason  yan, 15-01-25 20:01:29
 *
 *  是否可以被选中
 */
@property (nonatomic) BOOL canSelected;

/**
 *  展开图片
 */
@property (nonatomic, strong) UIImage *expandImg;

/**
 *  折叠图片
 */
@property (nonatomic, strong) UIImage *foldImg;

/**
 *  当前级别
 */
@property (nonatomic) NSInteger level;

/**
 *  孩子数组
 */
@property (nonatomic,strong) NSMutableArray *childsArr;

/**
 *  在孩子数组中的索引位置
 */
@property (nonatomic) NSInteger childIndex;


/**
 *  初始化对象
 *
 *  @param name     名称
 *  @param value    值
 *
 *  @return 结点对象
 */
- (id)initWithName:(NSString*)name
             value:(id)value;

/**
 *  添加子节点
 *
 *  @param child 子节点
 */
- (void)addChild:(Node*)child;


/**
 *  @Author jason  yan, 15-01-27 10:01:20
 *
 *  移除指定范围内的子节点
 *
 *  @param range 范围
 */
- (void)removeChildsInRange:(NSRange)range;

/**
 *  @Author jason  yan, 15-01-27 10:01:07
 *
 *  移除所有子节点
 */
- (void)removeAllChilds;

@end
