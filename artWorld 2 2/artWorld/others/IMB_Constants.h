//
//  IMB_Constants.h
//  parent365
//
//  Created by 闫建刚 on 14-12-30.
//  Copyright (c) 2014年 闫建刚. All rights reserved.
//

#ifndef parent365_IMB_Constants_h
#define parent365_IMB_Constants_h

// 空字符串
#define STR_FOR_EMPTY @""

// 空格
#define STR_FOR_SPACE @" "

// 回车/换行
#define STR_FOR_RETURN_NEWLINE @"\n"

/**
 *  响应码 - 无错误
 */
static const NSInteger RES_CODE_FOR_NO_ERROR = 0;

/**
 *  deviceToken(iOS推送专用)
 */
static NSString *const kDeviceToken     = @"deviceToken";

/**
 *  channelId（百度推送渠道号）
 */
static NSString *const kChannelId       = @"channel_id";

/**
 *  im_uid
 */
static NSString *const kImUId           = @"im_uid";

/**
 *  im_password
 */
static NSString *const kImPassword      = @"im_password";

/**
 *  is_im_user_auth_success
 */
static NSString *const kIsImUserAuthSuccess = @"is_im_user_auth_success";

/**
 *  mobile
 */
static NSString *const kPhone          = @"phone";

/**
 *  hasChildInfo
 */
static NSString *const kHasChildInfo    = @"hasChildInfo";

/**
 *  @Author jason  yan, 15-01-22 22:01:26
 *
 *  im_token
 */
static NSString *const kImToken         = @"im_token";

/**
 *  userId（第三方推送用)
 */
static NSString *const kUserId          = @"userId";

/**
 *  uid
 */
static NSString *const kUId             = @"uId";

/**
 *  password
 */
static NSString *const kPassword        = @"password";


/**
 *  @Author jason  yan, 15-01-27 15:01:38
 *
 *  kBaiDu_Id
 */
static NSString *const kBaiDu_Id        = @"kBaiDu_Id";

/**
 *  @Author jason  yan, 15-01-27 15:01:01
 *
 *  kBaiDu_ChannelId
 */
static NSString *const kBaiDu_ChannelId = @"kBaiDu_ChannelId";


/**
 *  rows
 */
static NSString *const kRows            = @"rows";


/**
 *  pages
 */
static NSString *const kPages           =  @"pages";

/**
 *  代表记录总数
 */
static NSString *const kCount           =   @"count";


/**
 *  data
 */
static NSString *const kData            = @"data";


/**
 *  errorCode
 */
static NSString *const kErrorCode       =   @"errorCode";

/**
 *  errorMessage
 */
static NSString *const kErrorMessage    =   @"errorMsg";

/**
 *  页容量
 */
static const NSString  *SIZE_OF_PAGE = @"10";

/**
 *  操作系统类型_iPhone
 */
static const NSString  *OS_TYPE_FOR_IPHONE = @"ios";

// 沙箱缓存路径
#define DIR_PATH_FOR_CACHE NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

// 配置信息保存目录
#define DIR_PATH_FOR_CONFIG [DIR_PATH_FOR_CACHE stringByAppendingPathComponent:@"config"]

// 配置信息保存目录
#define DIR_PATH_FOR_DOWNLOADFILE [DIR_PATH_FOR_CACHE stringByAppendingPathComponent:@"downloads"]

// 数据库保存目录
#define DIR_PATH_FOR_DB [DIR_PATH_FOR_CACHE stringByAppendingPathComponent:@"db"]
/**
 *  应用程序数据库
 */
#define FILE_PATH_FOR_APP_DB [DIR_PATH_FOR_DB stringByAppendingPathComponent:@"appdb"]

// 用户信息归档Key
#define kUserInfoArchiver @"UserInfoArchiver"

// 用户信息归档文件路径
#define FILE_PATH_FOR_USER_ARCHIVER [DIR_PATH_FOR_CONFIG stringByAppendingPathComponent:kUserInfoArchiver]

// 应用程序版本号
#define BUNDLE_VERSION_SHORT_STR [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]



// 网络请求超时时间（s）
#define NET_REQUEST_TIME_OUT 5

// 网络请求方法
static NSString *NET_REQUEST_GET   = @"GET";
static NSString *NET_REQUEST_POST  = @"POST";

// 网络请求出错信息
// 网络无法访问
// #define NET_ERROR_MSG_FOR_NET_NOT_ACCESS              @"请检查您的网络设置"

// 不能满足查询条件的枚举
typedef enum{
    // 可以执行网络请求
    ENUM_CAN_NET_REQUEST,
    // 无法执行网络请求_没有必要属性
    ENUM_CANNOT_NET_REQUEST_FOR_MISSING_PROP_NEEDED,
    // 无法执行网络请求_没有数据处理器
    ENUM_CANNOT_NET_REQUEST_FOR_DATA_HANDLER_NOT_EXIST,
    // 无法执行网络请求_之前的请求还未结束
    ENUM_CANNOT_NET_REQUEST_FOR_PREV_REQUEST_NOT_FINISHED,
    // 无法执行网络请求_网络不通
    ENUM_CANNOT_NET_REQUEST_FOR_WIFI_OR_3G_NOT_ACCESS,
    // 无法执行网络请求_服务器无法访问
    ENUM_CANNOT_NET_REQUEST_FOR_SERVER_NOT_ACCESS
    
} ENUM_CAN_NET_REQUEST_OR_NOT;

// HTTP STATUS CODE
typedef enum {
    ENUM_HTTP_STATUS_OK = 200,
    ENUM_HTTP_STATUS_NET_IF_NOT_IMP = 405,
    ENUM_HTTP_STATUS_NET_IF_NOT_EXIST = 404,
    ENUM_HTTP_STATUS_NET_IF_REQUEST_METHOD_ERROR = 403,
    ENUM_HTTP_STATUS_NET_IF_SERVER_EXCEPTION = 500
}ENUM_HTTP_STATUS;

// CONNECTION ERROR MSG
#define CONNECTION_ERROR_MSG_FOR_NET_SET                    @"请检查您的网络设置"
/*
#define CONNECTION_ERROR_MSG_FOR_UNKNOW                     @"未知的网络请求错误"*/
#define CONNECTION_ERROR_MSG_FOR_UNKNOW                     @"网络访问异常"
#define CONNECTION_ERROR_MSG_FOR_BAD_URL                    @"请求地址异常或请求方法有误"
#define CONNECTION_ERROR_MSG_FOR_UNSUPPORT_URL              @"请求地址不支持"
#define CONNECTION_ERROR_MSG_FOR_NOT_FIND_HOST              @"无法找到服务器"
#define CONNECTION_ERROR_MSG_FOR_NOT_REACH_HOST             @"无法访问服务器"
#define CONNECTION_ERROR_MSG_FOR_TIME_OUT                   @"网络不给力或请求超时"

// HTTP STATUS ERROR MSG
#define NET_ERROR_MSG_FOR_HTTP_STATUS_UNKNOW                @"未知错误"
#define NET_ERROR_MSG_FOR_NET_IF_EXCEPTION                  @"服务器接口异常"     // HTTP status code:505
#define NET_ERROR_MSG_FOR_NET_IF_NOT_IMP                    @"请求接口暂未实现"   //  HTTP status code:405
#define NET_ERROR_MSG_FOR_NET_IF_NOT_EXIST                  @"请求的接口不存在"   //  HTTP status code:404
#define NET_ERROR_MSG_FOR_NET_IF_REQUEST_METHOD_ERROR       @"客户端请求方法错误"  //  HTTP status code 403

// DATA ERROR MSG
#define NET_ERROR_MSG_FOR_DOMAIN_OR_IP_WRONG                @"访问地址不存在"
#define NET_ERROR_MSG_FOR_RESPONSE_JSON_DATA                @"数据解析出错"
#define NET_ERROR_MSG_FOR_NO_MORE_DATA                      @"暂无更多数据"
#define NET_ERROR_MSG_FOR_NO_DATA                           @"暂无数据"
#define NET_ERROR_MSG_FOR_NO_UPDATE_DATA                    @"暂时没有更新，休息一会儿~"
#define NET_ERROR_MSG_FOR_REACH_FIRST_PAGE                  @"已经到达第一页"
#define NET_ERROR_MSG_FOR_DATA_HAS_REMOVED                  @"信息已被删除"
#define NET_ERROR_MSG_FOR_DATA_FORMAT_NOT_CORRECT           @"数据格式不正确"

/**
 *  中文编码字符集
 */
#define ENCODING_FOR_GB CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

///**
// *  日期星期类型
// */
//typedef NS_ENUM(NSInteger, ENUM_WEEK_DATE_TYPE) {
//    ENUM_WEEK_DATE_TYPE_UNKNOW = -1,
//    ENUM_WEEK_DATE_TYPE_SUNDAY,
//    ENUM_WEEK_DATE_TYPE_MONDAY,
//    ENUM_WEEK_DATE_TYPE_TUESDAY,
//    ENUM_WEEK_DATE_TYPE_WEDNESDAY,
//    ENUM_WEEK_DATE_TYPE_THURSDAY,
//    ENUM_WEEK_DATE_TYPE_FRIDAY,
//    ENUM_WEEK_DATE_TYPE_SATURDAY,
//};

// 单元格分割线tag
#define kTagForCellSeperatorView 999

// 单元格分割线高度
#define kCellSeperatorHeight 1

//
/**
 *  @Author jason  yan, 15-01-28 14:01:43
 *
 *  上次版本号
 */
static NSString *const kLastVersion     = @"kLastVersion";

/**
 *  @Author jason  yan, 15-01-28 14:01:38
 *
 *  是否已经显示过引导页
 */
static NSString *const kHasShowGuide    = @"kHasShowGuide";


/**
 *  @Author jason  yan, 15-02-03 17:02:28
 *
 *  当前所在城市
 */
static NSString *const kCurrentCity     = @"kCurrentCity";

/**
 *  @Author jason  yan, 15-02-03 17:02:53
 *
 *  当前位置-（纬度）
 */
static NSString *const kCurrentLocLati     = @"kCurrentLocLati";

/**
 *  @Author jason  yan, 15-02-03 17:02:32
 *
 *  当前未知-（精度）
 */
static NSString *const kCurrentLocLong     = @"kCurrentLocLong";

#pragma mark - LBS 相关 ↓



/**
 *  @Author jason  yan, 15-02-10 01:02:59
 *
 *  当前选中的城市
 */
static NSString *const kSelectCity     = @"kSelectCity";

/**
 *  @Author jason  yan, 15-02-09 18:02:14
 *
 *  kCurrentDistrict
 */
static NSString *const kCurrentDistrict = @"kCurrentDistrict";

/**
 *  @Author jason  yan, 15-02-09 18:02:49
 *
 *  kCurrentStreetName
 */
static NSString *const kCurrentStreetName = @"kCurrentStreetName";

/**
 *  @Author jason  yan, 15-02-09 18:02:17
 *
 *  kCurrentStreetNumber
 */
static NSString *const kCurrentStreetNumber = @"kCurrentStreetNumber";


/**
 *  @Author jason  yan, 15-02-09 15:02:55
 *
 *  kCurrentAddress（当前的地址信息）
 */
static NSString *const kCurrentAddress     = @"kCurrentAddress";


/**
 *  @Author jason  yan, 15-02-09 15:02:18
 *
 *  kPoi_id
 */
static NSString *const kPoi_id            = @"kPoi_id";


/**
 *  @Author jason  yan, 15-02-09 15:02:03
 *
 *  kPoi_name
 */
static NSString *const kPoi_name           = @"kPoi_name";

/**
 *  @Author jason  yan, 15-02-09 15:02:45
 *
 *  kPoi_lat
 */
static NSString *const kPoi_lat            = @"kPoi_lat";

/**
 *  @Author jason  yan, 15-02-09 15:02:23
 *
 *  kPoi_lon
 */
static NSString *const kPoi_lon            = @"kPoi_lon";

/**
 *  @Author jason  yan, 15-02-20 19:02:34
 *
 *  kPoi_city: 增加城市
 */
static NSString *const kPoi_city            = @"kPoi_city";

#pragma mark - LBS 相关 ↑

/**
 *  @Author jason  yan, 15-02-09 21:02:27
 *
 *  有上阴影
 */
static NSString *const kHasUpShadow        = @"kHasUpShadow";

/**
 *  @Author jason  yan, 15-02-09 21:02:51
 *
 *  有下阴影
 */
static NSString *const kHasDownShadow      = @"kHasDownShadow";

#endif
