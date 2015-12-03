//
//  AppDelegate.h
//  artWorld
//
//  Created by 张晓旭 on 15/8/6.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MainViewController.h"
//#import "ApplyViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate>
{
    EMConnectionState _connectionState;
    
    //    UIWindow *window;
    //    UINavigationController *navigationController;
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) MainViewController *mainController;
@end

