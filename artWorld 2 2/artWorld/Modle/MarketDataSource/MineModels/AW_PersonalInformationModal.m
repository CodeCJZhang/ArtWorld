//
//  AW_PersonalInformationModal.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_PersonalInformationModal.h"

@implementation AW_PersonalInformationModal

-(NSArray*)hobbyArray{
    if (!_hobbyArray) {
        _hobbyArray = [[NSArray alloc]init];
    }
    return _hobbyArray;
}

@end
