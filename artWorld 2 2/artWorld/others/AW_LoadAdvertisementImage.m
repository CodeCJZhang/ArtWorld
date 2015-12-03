//
//  AW_LoadAdvertisementImage.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/27.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_LoadAdvertisementImage.h"
#import "AFNetworking.h"
#import "AW_Constants.h"

#define kCachedCurrentImage ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingString:@"/adcurrent.png"])

/**
 *  @author cao, 15-11-27 11:11:52
 *
 *  请求启动图片
 */
@implementation AW_LoadAdvertisementImage

+ (BOOL)isShouldDisplayAd{
    
    return [[NSFileManager defaultManager]fileExistsAtPath:kCachedCurrentImage isDirectory:NULL];
}

+ (UIImage *)getAdImage{
    
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:kCachedCurrentImage]];
}

+ (void)downloadImage:(NSString *)imageUrl{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:imageUrl]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            [data writeToFile:kCachedCurrentImage atomically:YES];
        }
    }];
    [task resume];
}

+(void)requestAdvertisementImage{
    NSDictionary * dict = @{};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * imgDict = @{@"jsonParam":str,@"token":@"",@"param":@"getStartPage"};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
   [manager POST:ARTSCOME_INT parameters:imgDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       NSLog(@"%@",responseObject);
       NSDictionary * infoDict = responseObject[@"info"];
       NSLog(@"%@",infoDict[@"content"]);
       if ([responseObject[@"code"]intValue] == 0){
           [self downloadImage:infoDict[@"advertis_img"]];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"type"]) {
               [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"type"];
           }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
               [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"id"];
           }
           if ([[NSUserDefaults standardUserDefaults]objectForKey:@"adContent"]) {
               [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"adContent"];
           }
           [[NSUserDefaults standardUserDefaults]setValue:infoDict[@"content"] forKey:@"adContent"];
           [[NSUserDefaults standardUserDefaults]setValue:infoDict[@"type"] forKey:@"type"];
           [[NSUserDefaults standardUserDefaults]setValue:infoDict[@"id"] forKey:@"id"];
           NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"adContent"]);
       }
   } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       NSLog(@"%@",[error localizedDescription]);
   }];
}

@end
