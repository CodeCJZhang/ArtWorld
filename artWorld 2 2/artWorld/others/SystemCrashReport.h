//
//  SystemCrashReport.h
//  addBug
//
//  Created by 陈雁丰 on 15/11/18.
//  Copyright (c) 2015年 陈雁丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SystemCrashReport : NSObject

/**
 *                              设备型号
 */
@property (nonatomic, copy)     NSString *deviceModels;

/**
 *                              品牌
 */
@property (nonatomic, copy)     NSString *brand;
/**
 *                              系统版本
 */
@property (nonatomic, copy)     NSString *systemVersion;
/**
 *                              应用版本
 */
@property (nonatomic, copy)     NSString *appVersion;
/**
 *                              应用名称
 */
@property (nonatomic, copy)     NSString *appName;
/**
 *                              应用build号
 */
@property (nonatomic, copy)     NSString *appBuild;
/**
 *                              错误文件.TXT
 */
@property (nonatomic, copy)     NSData *errFile;
/**
 *                              是否存在txt文件
 */
@property (nonatomic) BOOL isExsitFile;

/**
 *  后台增加一个接口，用来记录客户端的崩溃信息
 *  @param errFile       错误文件
 */
- (id)initSaveSystemCrashInfoWithErrFile:(NSString *)errFile;

/**
 *  创建crash文件夹
 *
 *  @return 布尔值
 */
- (BOOL)createCrashFolderIfNotExist;
/**
 *  移除crash文件夹
 *
 *  @return 布尔值
 */
- (BOOL)removeCrashFolderIfNotExist;

@end
