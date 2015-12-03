//
//  AW_SearchModal.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SearchModal.h"

@implementation AW_SearchModal

-(NSString*)description{
    return [NSString stringWithFormat:@"name :%@,pinyin:%@",_nameString,_nameStringPinYin];
}
@end
