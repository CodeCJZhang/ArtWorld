//
//  IMB_Macro.h
//  parent365
//
//  Created by 闫建刚 on 14-12-30.
//  Copyright (c) 2014年 闫建刚. All rights reserved.
//
#import <UIKit/UIKit.h>

// 获取Info.plist文件中的值
#define InfoPlistForKey(key)  [[[NSBundle mainBundle] infoDictionary]objectForKey:key]

// 获取客户端版本号信息
#define ClientVersion InfoPlistForKey(@"CFBundleVersion")

// 当前设备
#define Device  [UIDevice currentDevice]

// 系统名称
#define SystemType Device.systemName

// 系统版本
#define SystemVersion Device.systemVersion

// 设备厂商
#define DeviceFactory  @"Apple"

// 设备类型
#define DeviceType     Device.model


// 已选中某个列表对象后的回调
typedef void (^ DidSelectObjectBlock)(NSInteger index, id obj);

/**
 *  中文编码字符集
 */
#define ENCODING_FOR_GB CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

//适配IPhone5、IOS7

// 是否3.5寸屏幕
#define IS_35_SCREEN CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)

//适配6 6+
#define IS_47_SCREEN (kSCREEN_WIDTH > 320 ? YES:NO)

#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IOS_7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7)

#define IS_IOS_8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8)

//定义屏幕尺寸及中心坐标 定义高清屏
#define kSCREEN_WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].applicationFrame.size.height

#define kScreen_CenterX  kSCREEN_WIDTH/2
#define kScreen_CenterY  kSCREEN_HEIGHT/2
#define isRetina ([[UIScreen mainScreen] scale]==2)

// 普通单元格高度
#define kCommonCellHeight 44.0

// 标准边界间隙
#define kMarginToContainerSide 20.0

// 标准组件间隙
#define kMarginBetweenCompontents 8.0

// 状态栏高度
#define kSTATUS_BAR_HEIGHT [[UIApplication sharedApplication]statusBarFrame].size.height

// 导航栏高度
#define kNAV_BAR_HEIGHT 44

// tabbar高度
#define KTAB_BAR_HEIGHT 49

// 系统色值
#define COLOR_RANDOM RGB(arc4random() % 255 + 1,arc4random() % 255 + 1,arc4random() % 255 + 1)

// 主色调色值
#define HEX_COLOR_FOR_GLOBAL_TONE 0x36a1d5

// 主色调
#define COLOR_FOR_GLOBAL_TONE HexRGB(HEX_COLOR_FOR_GLOBAL_TONE)

//可拉伸的图片

#define IMAGE(name) [UIImage imageNamed:name]
#define PNGIMAGE(name)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(name) ofType:@"png"]]
#define ResizableImage(name,top,left,bottom,right) [IMAGE(name) resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]
#define ResizableImageDataForMode(image,top,left,bottom,right,mode) [image resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]
#define ResizableImageForMode(name,top,left,bottom,right,mode) [IMAGE(name) resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]


#define ResizableScaleImage(name,zoom,top,left,bottom,right) [[UIImage imageWithCGImage:IMAGE(name).CGImage scale:zoom orientation:UIImageOrientationUp] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]

//获取view的frame某值
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y

//根据tag值获取子视图
#define ViewTag(v,t)                        [v viewWithTag:t]

// 创建rect
#define Rect(x,y,width,height)              CGRectMake(x, y, width,height)

//获取rect中某值
#define RectX(rect)                            rect.origin.x
#define RectY(rect)                            rect.origin.y
#define RectWidth(rect)                        rect.size.width
#define RectHeight(rect)                       rect.size.height
//设置rect中某值
#define RectSetWidth(rect, w)                  CGRectMake(RectX(rect), RectY(rect), w, RectHeight(rect))
#define RectSetHeight(rect, h)                 CGRectMake(RectX(rect), RectY(rect), RectWidth(rect), h)
#define RectSetX(rect, x)                      CGRectMake(x, RectY(rect), RectWidth(rect), RectHeight(rect))
#define RectSetY(rect, y)                      CGRectMake(RectX(rect), y, RectWidth(rect), RectHeight(rect))

#define RectSetSize(rect, w, h)                CGRectMake(RectX(rect), RectY(rect), w, h)
#define RectSetOrigin(rect, x, y)              CGRectMake(x, y, RectWidth(rect), RectHeight(rect))

#define AddHeightTo(v, h) { CGRect f = v.frame; f.size.height += h; v.frame = f;}

#define MoveViewTo(v, deltaX, deltaY) { CGRect f = v.frame; f.origin.x += deltaX ;f.origin.y += deltaY; v.frame = f; }

#define MakeHeightTo(v, h) { CGRect f = v.frame; f.size.height = h; v.frame = f; }

//视图位置底部加h高度
#define addHeightFrom(v, h) v.frame.origin.y + v.frame.size.height + h

//  主要单例
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NotificationCenter                  [NSNotificationCenter defaultCenter]
#define SharedApplication                   [UIApplication sharedApplication]

#define Bundle                              [NSBundle mainBundle]
#define BundleToObj(nibName)                [Bundle loadNibNamed:nibName owner:nil options:nil][0]

#define MainScreen                          [UIScreen mainScreen]

#define SDManager                           [SDWebImageManager sharedManager]

// storyboard实例化
#define STORYBOARD(storyboardName)          [UIStoryboard storyboardWithName:storyboardName bundle:nil]

#define INSTANT_VC_WITH_ID(storyboardName,vcIdentifier)  [STORYBOARD(storyboardName) instantiateViewControllerWithIdentifier:vcIdentifier]

// 应用程序代理
#define APP_DELEGATE [UIApplication sharedApplication].delegate

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]

// 主题管理器单例
#define RNTHEME_MANAGER [RNThemeManager sharedManager]

#define RN_COLOR_FOR_KEY(colorKey) [RNTHEME_MANAGER colorForKey:colorKey]

//  主要控件
#define NavBar                              self.navigationController.navigationBar
#define NavItem                             self.navigationItem
#define TabBar                              self.tabBarController.tabBar

//输出frame(frame是结构体，没法%@) BOOL NSInteger
#define LOGFRAME(f) NSLog(@"\nx:%f\ny:%f\nwidth:%f\nheight:%f\n",f.origin.x,f.origin.y,f.size.width,f.size.height)
#define LOGBOOL(b)  NSLog(@"%@",b?@"YES":@"NO");
#define NSStringFromInt(intValue) [NSString stringWithFormat:@"%d",intValue]
#define LOGINT(i) NSLog(@"%@",NSStringFromInt(i))
//弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]

//color
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//颜色转1px图片
#define PatternImageByColor(color) [ColorToImage imageWithColor:color]

//转换
#define I2S(number) [NSString stringWithFormat:@"%d",number]
#define F2S(number) [NSString stringWithFormat:@"%.0f",number]
#define B2S(bool) [NSString stringWithFormat:@"%@",bool ? @"true" : @"false"]
#define DATE(stamp) [NSDate dateWithTimeIntervalSince1970:[stamp intValue]];


//GCD （子线程、主线程定义）
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//打开URL
#define canOpenURL(appScheme) ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]])

#define openURL(appScheme) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:appScheme]])

// Width约束
#define CONSTRAINT_WIDTH(view_,related_,multiplier_,constant_) [NSLayoutConstraint constraintWithItem:view_ attribute:NSLayoutAttributeWidth relatedBy:related_ toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:multiplier_ constant:constant_]

// Top约束
#define CONSTRAINT_TOP(firstItem_,related_,secondItem_,multiplier_,constant_) [NSLayoutConstraint constraintWithItem:firstItem_ attribute:NSLayoutAttributeTop relatedBy:related_ toItem:secondItem_ attribute:NSLayoutAttributeTop multiplier:multiplier_ constant:constant_]

//接口地址
#define ARTSCOME_INT @"http://www.artscome.com:8080/yitianxia/mobile/api.json"



#pragma mark Property Method

#pragma mark Override Method

#pragma mark Custom Method

#pragma mark Life Circle Method

#define YTX_URL   @"http://www.artscome.com:8080/yitianxia/mobile/api.json"
