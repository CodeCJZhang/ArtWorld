//
//  SystemCrashReport.m
//  addBug
//
//  Created by 陈雁丰 on 15/11/18.
//  Copyright (c) 2015年 陈雁丰. All rights reserved.
//

#import "SystemCrashReport.h"
#define crash_report @"crash_report"
#define exception_txt @"exception.txt"

@implementation SystemCrashReport

#pragma mark
#pragma mark 初始化后创建文件夹 发送崩溃信息
- (id)initSaveSystemCrashInfoWithErrFile:(NSString *)errInfo {
    if (self = [super init]) {
        [self createCrashFolderIfNotExist];
        if ([self isFileExist]) {
            _isExsitFile = YES;
        }else {
            _isExsitFile = NO;
        }
        
        // 设备型号
        _deviceModels = [[UIDevice currentDevice] model];
        // 设备名称
        _brand = @"APPLE";
        // 设备系统版本
        _systemVersion = [[UIDevice currentDevice] systemVersion];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app名称
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        _appName = app_Name;
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _appVersion = app_Version;
        // app build版本
        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
        _appBuild = app_build;
        
        NSString *path = [self crashFilePath];
        if (errInfo.length > 0) {
            [errInfo writeToFile:[path stringByAppendingPathComponent:exception_txt] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        _errFile = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:exception_txt]];
        
    }
    return self;
}

#pragma mark 文件处理
- (NSString *)crashFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:crash_report];
}

- (BOOL)isFileExist {
    NSString *path = [self crashFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[path stringByAppendingPathComponent:exception_txt]]) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)isDirExist {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    return [fileManager fileExistsAtPath:[self crashFilePath] isDirectory:&isDir];
}

- (BOOL)createCrashFolderIfNotExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [self isDirExist];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:[self crashFilePath] withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建 system crash 文件夹失败");
            return NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)removeCrashFolderIfNotExist {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [self isDirExist];
    if (isDirExist) {
        [fileManager removeItemAtPath:[self crashFilePath] error:nil];
    }
    return YES;
}


@end
