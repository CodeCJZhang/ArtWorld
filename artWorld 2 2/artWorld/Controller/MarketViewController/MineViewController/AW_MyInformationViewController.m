//
//  AW_MyInformationViewController.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyInformationViewController.h"
#import "IMB_Macro.h"
#import "UIImage+IMB.h"
#import "AW_DeliveryAdressController.h"
#import "AW_MyinfoTopCell.h"
#import "AW_DeliveryAdressController.h"
#import "AW_SelectPreferenceController.h"//选择偏好控制器
#import "SVProgressHUD.h"
#import "AW_ChangeWordController.h"
#import "DeliveryAlertView.h"
#import "AW_SetDateView.h"
#import "AW_LiveAdressController.h"//所在地控制器
#import "AW_SelectPhotoView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TOCropViewController.h" //裁剪图片控制器
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "MarketViewController.h"//市集控制器
#import "AW_MyPreferenceModal.h"
#import "AW_ProvinceController.h"//省份控制器
#import "AW_CityController.h"//城市控制器
#import "AW_LiveProvinceController.h"//所在地城市控制器
#import "AW_LiveCityController.h"//所在地城市控制器
#import "AW_PersonalInformationModal.h" //个人信息模型
#import "AFNetworking.h"
#import "NSFileManager+Utils.h"
#import "FMDatabase.h"
#import "AW_EMUserModal.h"
#import "UserDataBaseHelper.h"
#import "ApplyViewController.h"
#import "IQKeyboardManager.h"

static NSString * SQL_FOR_DELETE_USERINFO = @"delete from t_userIM where user_id = ?";

@interface AW_MyInformationViewController ()<AW_SelectPreferenceControllerDelegate,LiveAdressDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate,AW_DeliveryAdressDelegete,AW_MyAdressDelegate,AW_MyLiveAdressDelegate>

/**
 *  @author cao, 15-08-21 15:08:43
 *
 *  我的个人信息列表
 */
@property(nonatomic,strong)UITableView * myInfoTableView;
/**
 *  @author cao, 15-09-28 15:09:19
 *
 *  顶部cell
 */
@property(nonatomic,strong)AW_MyinfoTopCell * topCell;
/**
 *  @author cao, 15-11-11 11:11:41
 *
 *  图片data
 */
@property(nonatomic,strong)UIImage * headImage;
@end

@implementation AW_MyInformationViewController

#pragma mark - Property  Mentood

-(NSMutableString*)hobbyIdString{
    if (!_hobbyIdString) {
        _hobbyIdString = [[NSMutableString alloc]init];
    }
    return _hobbyIdString;
}

-(NSMutableString*)preferenceString{
    if (!_preferenceString) {
        _preferenceString = [[NSMutableString alloc]init];
    }
    return _preferenceString;
}

-(AW_MyinfoTopCell*)topCell{
    if (!_topCell) {
        _topCell = BundleToObj(@"AW_MyinfoTopCell");
    }
    return _topCell;
}

-(AW_MyInfoDataSource*)infoDataSource{
    if (!_infoDataSource) {
        _infoDataSource = [[AW_MyInfoDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
        }];
        _infoDataSource.hasLoadMoreFooter = NO;
        _infoDataSource.hasRefreshHeader = NO;
    }
    return _infoDataSource;
}

-(UITableView*)myInfoTableView{
    if (!_myInfoTableView) {
        _myInfoTableView = [[UITableView alloc]initWithFrame:Rect(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT - kNAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _myInfoTableView.backgroundColor = [UIColor clearColor];
        _myInfoTableView.dataSource = self.infoDataSource;
        _myInfoTableView.delegate = self.infoDataSource;
        _myInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myInfoTableView];
    }
    return _myInfoTableView;
}

#pragma mark - ButtonClick Menthod

-(void)kindBtnClick:(NSInteger)index{
    //将键盘取消第一响应者
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    if (index == 1) {
        AW_ChangeWordController * changeController = [[AW_ChangeWordController alloc]init];
        changeController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changeController animated:YES];
    }else if(index == 2){
        AW_DeliveryAdressController * controller = [[AW_DeliveryAdressController alloc]init];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (index == 3){
        DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
        AW_SelectPhotoView * contentView = BundleToObj(@"AW_SelectPhotoView");
        contentView.bounds = Rect(0, 0, 280, 160);
        alertView.contentView = contentView;
        [alertView showWithoutAnimation];
        //点击图库或照相机按钮的回调
        contentView.didClickedCamera = ^(NSInteger index){
            if (index == 1) {
                [self openCamera];
            }else if (index == 2){
                [self openLocalPhoto];
            }
        };
    }
}

-(void)buttonClicked:(NSInteger)index{
    //将键盘取消第一响应者
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    if (index == 1) {
        DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
        AW_SetDateView * contentView = BundleToObj(@"AW_SetDateView");
        contentView.bounds = Rect(0, 0, 280, 300 );
        alertView.contentView = contentView;
        [alertView showWithoutAnimation];
        //点击确定或取消按钮的回调
        __weak typeof(self) weakSelf = self;
        contentView.didClickedBtn = ^(NSInteger index,NSDate * dateString){
            if (index == 1) {
                NSDate * nowDate = [NSDate date];
                NSLog(@"%@",[nowDate description]);
                NSLog(@"%@",dateString);
                if (!dateString) {
                    [self showHUDWithMessage:@"你设置的生日不符合要求"];
                }else{
                    if ([dateString compare:nowDate] == NSOrderedDescending) {
                        [self showHUDWithMessage:@"你设置的生日不符合要求"];
                    }else{
                        NSDateFormatter * formattor = [[NSDateFormatter alloc]init];
                        formattor.dateFormat = @"yyyy-MM-dd";
                        AW_PersonalInformationModal * modal = self.infoDataSource.dataArr[2];
                        modal.birthday = [formattor stringFromDate:dateString];
                        [self.myInfoTableView reloadData];
                    }
                }
            }
        };
    }else if (index == 2){
        AW_LiveProvinceController * controller = [[AW_LiveProvinceController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (index == 3){
        AW_SelectPreferenceController * preferenceController = [[AW_SelectPreferenceController alloc]init];
        preferenceController.delegate = self;
        preferenceController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:preferenceController animated:YES];
    }else if (index == 4){
        AW_ProvinceController * controller = [[AW_ProvinceController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//在这进行请求，保存个人信息
-(void)saveMyInfomation{
    //显示提示信息
    [SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeBlack];
    //在这进行请求
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id  = [user objectForKey:@"user_id"];
    AW_PersonalInformationModal * middleModal = self.infoDataSource.dataArr[2];
    AW_PersonalInformationModal * topModal = self.infoDataSource.dataArr[0];
    AW_PersonalInformationModal * bottomodal = self.infoDataSource.dataArr[4];
    NSLog(@"%@",middleModal.hobbyString);
    NSLog(@"%@",middleModal.hobbyId);
    if (self.headImgPath) {
         NSLog(@"%@",self.headImgPath);
    }
    NSData *imageData = UIImageJPEGRepresentation(self.headImage,0.5);
    NSLog(@"%@",middleModal.hobbyId);
    NSDictionary * tmpDict = @{
                         @"id":user_id,
                         //@"file":imageData,
                         @"nickname":topModal.nickname,
                         @"birthday":middleModal.birthday,
                         @"delivery_id":topModal.adressModal.adress_Id,
                         @"hometown_province":middleModal.hometown_province_id,
                         @"hometown_city":middleModal.hometown_city_id,
                         @"province":middleModal.province_id,
                         @"city":middleModal.city_id,
                         @"hobby":middleModal.hobbyId,
                         @"personal_label":middleModal.personal_label,
                         @"synopsis":bottomodal.synopsis,
                         @"signature":bottomodal.signature,
                     };
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:tmpDict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str  = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * infoDict = @{@"param":@"updateOwnData",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager POST:ARTSCOME_INT parameters:infoDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       //上传头像
        if (imageData) {
            NSString *fileName = [NSString stringWithFormat:@"img.jpg"];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        __weak typeof(self)weakSelf = self;
        if ([responseObject[@"code"]intValue] == 0) {
            [self showHUDWithMessage:@"保存成功"];
            //修改数据库中的数据
            if (imageData) {
                UserDataBaseHelper * helper = [[UserDataBaseHelper alloc]init];
                NSDictionary * dict = [helper queryAllUserInfo];
                if ([[dict allKeys] containsObject:topModal.phone]) {
                   static NSString * SQL_FOR_DELETE_USERINFO = @"delete from t_userIM where user_id = ?";
                    NSString * documentPath = [NSFileManager documentsDirectory];
                    NSString * parh = [documentPath stringByAppendingPathComponent:@"Data.db"];
                    FMDatabase * fmdb = [FMDatabase databaseWithPath:parh];
                    NSLog(@"%@",parh);
                    @try {
                        if ([fmdb open]) {
                            if ([fmdb executeUpdate:SQL_FOR_DELETE_USERINFO,user_id]) {
                                NSLog(@"删除成功");
                            }else{
                                NSLog(@"删除失败:%@",[fmdb lastErrorMessage]);
                            }
                        }
                    }
                    @finally {
                        [fmdb close];
                    }
                }
            }
        }else{
           [self showHUDWithMessage:responseObject[@"message"]];
        }
        [SVProgressHUD dismissAfterDelay:0];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"错误信息:%@",[error localizedDescription]);
    }];

}
-(void)saveSucess{
    [self showHUDWithMessage:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - OpenCamera Menthod
//打开本地相册
-(void)openLocalPhoto{
    //检查是否支持相册或相机胶卷
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO){
        return;
    }
    UIImagePickerController * pickController = [[UIImagePickerController alloc]init];
    pickController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];

    pickController.delegate = self;
    pickController.allowsEditing = NO;
    
    [self presentViewController:pickController animated:YES completion:NULL];
}

//打开照相机
-(void)openCamera{
    //检查照相机是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
        return;
    }
    UIImagePickerController * cameraController = [[UIImagePickerController alloc]init];
    cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    cameraController.delegate = self;
    cameraController.allowsEditing = NO;
    [self presentViewController:cameraController animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate Menthod
//选择一个静止的图片或视频获得调用
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * originalImage;
    originalImage = (UIImage *)[info objectForKey:
                                     UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        self.infoDataSource.headImage = originalImage;
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:originalImage];
        cropController.delegate = self;
        [self.navigationController pushViewController:cropController animated:YES];
    }];
}

//取消pick操作
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UINavigationController Delegate Menthod
//改变相册选择界面按钮的颜色
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

#pragma mark - TOCropViewControllerDelegate Menthod
//完成图片裁剪以后的调用
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    //将裁剪后的图片保存到相册
    UIImageWriteToSavedPhotosAlbum (image, nil, nil,nil);
    self.infoDataSource.headImage = image;
    
    //将图片存到沙箱
    NSString * documentPath = [NSFileManager documentsDirectory];
    NSString * imagePath = [documentPath stringByAppendingPathComponent:@"imagePath"];
    if ([NSFileManager directoryExistAtPath:imagePath] == NO) {
        [NSFileManager createDirectory:imagePath];
    }
    NSString * firePath = [imagePath stringByAppendingPathComponent:@"img.jpg"];
    if ([NSFileManager fileExistAt:firePath] == NO) {
        [NSFileManager createFile:firePath withContent:nil];
    }
    NSLog(@"%@",documentPath);
//     NSData* data = UIImagePNGRepresentation(image);
    NSData *data = UIImageJPEGRepresentation(image,0.5);
    self.headImage = [image copy];
    [data writeToFile:firePath atomically:YES];
    self.headImgPath = [NSString stringWithFormat:@"%@",firePath];
    
    [self.myInfoTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - LifeCycle Menthod

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myInfoTableView.dataSource = self.infoDataSource;
    self.myInfoTableView.delegate = self.infoDataSource;
    self.infoDataSource.tableView = self.myInfoTableView;
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //取消回弹效果
    self.myInfoTableView.bounces = NO;
    self.navigationItem.title = @"个人资料";
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    // 设置设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x71c930);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    [self.navigationController.navigationBar setShadowImage:shadowImage];
    //添加右侧保存按钮
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:0 target:self action:@selector(saveMyInfomation)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    rightBtn.tintColor = [UIColor blackColor];
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //点击按钮的回调
    __weak typeof(self) weakSelf = self;
    self.infoDataSource.didSelect = ^(NSInteger idx){
        [weakSelf kindBtnClick:idx];
    };
    self.infoDataSource.didSelectCellBtn = ^(NSInteger index){
        [weakSelf buttonClicked:index];
    };
    //点击退出登陆按钮的回调
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    self.infoDataSource.didClickCancleBtn = ^(){
        [weakSelf showHUDWithMessage:@"退出成功"];
       [weakSelf.navigationController popViewControllerAnimated:YES];
        //退出环信登录
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            [weakSelf hideHud];
            if (error && error.errorCode != EMErrorServerNotLogin) {
                [weakSelf showHint:error.description];
            }
            else{
                [[ApplyViewController shareController] clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            }
        } onQueue:nil];
    };
    //加载我的信息
    [self.infoDataSource getData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // 设置导航栏背景颜色
    UIColor *bgCorlor = [UIColor whiteColor];
    // 颜色变背景图片
    UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
    barBgImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
    [self.navigationController.navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];
    UIColor *shadowCorlor = HexRGB(0x88c244);
    UIImage *shadowImage = [UIImage imageWithColor:shadowCorlor];
    //隐藏NavBar下边线
    [self.navigationController.navigationBar setShadowImage:shadowImage];
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - AW_SelectPreferenceControllerDelegate Menthod
-(void)didClickCompleteBtnWithSelectArray:(NSMutableArray *)selectArray{
    /**
     *  @author cao, 15-09-06 15:09:43
     *
     *  如果self.preferenceString存在，先将其设置为nil
     *  如果不设置为nil，个人偏好的string会一直累加
     */
    if (self.preferenceString.length > 0) {
        self.preferenceString = nil;
    }
    if (self.hobbyIdString.length > 0) {
        self.hobbyIdString = nil;
    }
    if (selectArray.count > 0) {
        [selectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AW_MyPreferenceModal * modal = obj;
            [self.preferenceString appendString:modal.preferenceDes];
            [self.hobbyIdString appendString:[NSString stringWithFormat:@"%@",modal.hobby_id]];
           // if (idx < selectArray.count - 1) {
                [self.preferenceString appendString:@","];
                [self.hobbyIdString appendString:@","];
            //}
        }];
    }
    AW_PersonalInformationModal * modal = self.infoDataSource.dataArr[2];
    modal.hobbyString = self.preferenceString;
    modal.hobbyId = self.hobbyIdString;
    modal.hobbyArray = [selectArray copy];
    [self.myInfoTableView reloadData];    
}

#pragma mark - HomeAdressDelegate Menthod
-(void)didClickedCityCell:(AW_ProvinceModal *)provinceModal city:(AW_CityModal *)cityModal{
    NSLog(@"%@",provinceModal.Province_name);
    NSLog(@"%@",cityModal.city_name);
    //改变modal的值
    AW_PersonalInformationModal * modal  = self.infoDataSource.dataArr[2];
    NSLog(@"%@",modal.province_name);
    modal.hometown_province_name = provinceModal.Province_name;
    modal.hometown_province_id = provinceModal.Province_id;
    modal.hometown_city_name = cityModal.city_name;
    modal.hometown_city_id = cityModal.city_id;
    [self.myInfoTableView reloadData];
}

#pragma mark - LiveAdressDelegate Menthod
-(void)didClickedLiveAdressCityCell:(AW_ProvinceModal *)provinceModal city:(AW_CityModal *)cityModal{
    NSLog(@"%@",provinceModal.Province_name);
    NSLog(@"%@",cityModal.city_name);
    //改变modal的值
    AW_PersonalInformationModal * modal  = self.infoDataSource.dataArr[2];
    NSLog(@"%@",modal.province_name);
    modal.province_name = provinceModal.Province_name;
    modal.province_id = provinceModal.Province_id;
    modal.city_name = cityModal.city_name;
    modal.city_id = cityModal.city_id;
    [self.myInfoTableView reloadData];
}

#pragma mark - AW_DeliveryAdressDelegete Menthod
-(void)didClickedDeliveryCell:(AW_DeliveryAdressModal *)adressModal{
    NSLog(@"===%@===",adressModal.deliveryAdress);
    //将收货地址id记录下来
    self.adress_id = adressModal.adress_Id;
    AW_PersonalInformationModal * modal = self.infoDataSource.dataArr[0];
    modal.adressModal.adress_Id = adressModal.adress_Id;
    modal.adressModal.deliveryAdress = adressModal.deliveryAdress;
    modal.adressModal.deliveryName = adressModal.deliveryName;
    modal.adressModal.deliveryPhoneNumber = adressModal.deliveryPhoneNumber;
    [self.myInfoTableView reloadData];
}

#pragma mark - ShowMessage Menthod
- (void)showHUDWithMessage:(NSString*)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.labelFont = [UIFont boldSystemFontOfSize:13];
    hud.margin = 10.f;
    hud.alpha = 0.9;
    hud.cornerRadius = 4.0;
    hud.yOffset = 150.f;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

@end
