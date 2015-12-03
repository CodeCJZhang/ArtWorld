//
//  Node.m
//  myJob
//
//  Created by 张亚哲 on 15-3-19.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import "Node.h"

@interface Node()
{
    NSMutableArray *childsArr_;
}

@end

@implementation Node


- (id)init{
    if (self = [self initWithName:nil value:nil]) {
        
    }
    return self;
}

- (id)initWithName:(NSString *)name
             value:(id)value{
    self = [super init];
    if (self) {
        _name = name;
        _value = value;
        childsArr_ = [NSMutableArray array];
    }
    return self;
}

- (void)addChild:(Node *)child{
    child.level = _level + 1;
    [childsArr_ addObject:child];
}

- (void)removeChildsInRange:(NSRange)range{
    [childsArr_ removeObjectsInRange:range];
} // 移除指定范围内的子节点

- (void)removeAllChilds{
    [childsArr_ removeAllObjects];
} // 移除所有子节点

- (BOOL)hasChild{
    return childsArr_.count == 0 ? NO : YES;
} // 判断是否有子节点

- (NSMutableArray*)childsArr{
   return childsArr_;
} // 返回子节点

- (NSString*)description{
    return _name;
}

@end
