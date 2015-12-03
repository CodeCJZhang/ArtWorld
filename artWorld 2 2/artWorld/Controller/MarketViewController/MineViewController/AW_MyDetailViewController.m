//
//  AW_MyDetailViewController.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/20.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyDetailViewController.h"
#import "AW_MyDetailViewController.h"
#import "AW_CollectionViewHeadView.h"//我的作品collectionView头视图
#import "IMB_Macro.h"
#import "WaterFLayout.h"
#import "AW_MyDetailHeadView.h"//头像，简介视图
#import "UIImage+IMB.h"
#import "AW_TarBarView.h"//按钮转换界面的视图（盛放4个button的视图）
#import "AW_AddNewAttentionController.h" //添加新关注控制器
#import "AW_ActiveController.h" //活动控制器
#import "MWPhotoBrowser.h"
#import "SDImageCache.h"
#import "MWCommon.h"
#import "ScaleAnimation.h"//缩放动画效果
#import "AW_HomePageModal.h"//个人主页接口modal
#import "AW_LoginInViewController.h"//登陆界面
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AW_ArtDetailController.h"//艺术品详情控制器
#import "ChatViewController.h"//聊天界面
#import "AW_OtherInfoController.h"
#import "AW_MyInformationViewController.h"
#import "AW_LoginInViewController.h"//登陆界面
#import "AW_DeleteAlertMessage.h"
#import "DeliveryAlertView.h"
#import "SVProgressHUD.h"

@interface AW_MyDetailViewController ()<MWPhotoBrowserDelegate>
/**
 *  @author cao, 15-10-12 14:10:21
 *
 *  缩放动画控制器
 */
@property(nonatomic,strong)ScaleAnimation *scaleAnimationController;
/**
 *  @author cao, 15-09-24 16:09:43
 *
 *  tarBar视图
 */
@property(nonatomic,strong)AW_TarBarView *btnView;
/**
 *  @author cao, 15-08-19 14:08:21
 *
 *  我的详情头部视图
 */
@property(nonatomic,strong)AW_MyDetailHeadView * myDetailHeadleView;
/**
 *  @author cao, 15-08-13 17:08:11
 *
 *  我的作品collectionView
 */
@property(nonatomic,strong)UICollectionView * myProductionView;
/**
 *  @author cao, 15-08-13 17:08:55
 *
 *  我关注的人列表
 */
@property(nonatomic,strong)UITableView * myAttentionTableView;
/**
 *  @author cao, 15-08-13 17:08:11
 *
 *  我的粉丝列表
 */
@property(nonatomic,strong)UITableView * myFansTableView;
/**
 *  @author cao, 15-08-13 17:08:22
 *
 *  我的动态列表
 */
@property(nonatomic,strong)UITableView * myDynamicTableView;

/**
 *  @author cao, 15-08-20 09:08:37
 *
 *  我的关注tableViewController
 */
@property(nonatomic,strong)UITableViewController * attentionTable;
/**
 *  @author cao, 15-08-20 09:08:16
 *
 *  我的粉丝tableViewController
 */
@property(nonatomic,strong)UITableViewController * fansTable;
/**
 *  @author cao, 15-08-20 09:08:34
 *
 *  我的动态tableViewController
 */
@property(nonatomic,strong)UITableViewController * dynamicTable;
/**
 *  @author cao, 15-08-20 09:08:56
 *
 *  我的作品collectionViewController
 */
@property(nonatomic,strong)UICollectionViewController * produceCollection;
/**
 *  @author cao, 15-08-20 09:08:46
 *
 *  返回按钮
 */
@property (nonatomic, weak) UIButton *backBtn;

/**
 *  @author cao, 15-08-20 09:08:05
 *
 *  对话按钮
 */
@property (nonatomic, weak) UIButton *talkBtn;
/**
 *  @author cao, 15-08-23 12:08:29
 *
 *  我的详情顶部视图
 */
@property(nonatomic,strong)AW_MyDetailHeadView * headView;
/**
 *  @author cao, 15-10-02 19:10:29
 *
 *  图片数组
 */
@property(nonatomic,strong)NSMutableArray * photosArray;
/**
 *  @author cao, 15-10-20 10:10:28
 *
 *  个人主页modal
 */
@property(nonatomic,strong)AW_HomePageModal *homePageModal;
@end

@implementation AW_MyDetailViewController

-(AW_HomePageModal*)homePageModal{
    if (!_homePageModal) {
        _homePageModal = [[AW_HomePageModal alloc]init];
    }
    return _homePageModal;
}

-(void)getJsonData{
    //在这进行请求
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSLog(@"%@",self.person_id);
    if (!user_id) {
        user_id = @"";
    }
    NSDictionary * dict = @{@"userId":user_id,@"personId":self.person_id};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * infoDict = @{@"param":@"othersInfo",@"jsonParam":str};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:ARTSCOME_INT parameters:infoDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary * info = responseObject[@"info"];
        NSLog(@"%@",responseObject[@"message"]);
        if ([responseObject[@"code"]intValue] == 0) {
            self.homePageModal.nickName = info[@"nickname"];
            self.homePageModal.shopName = info[@"shop_name"];
            self.homePageModal.user_hxid = info[@"phone"];
            self.homePageModal.head_img = info[@"head_img"];
            self.homePageModal.authentication_state = info[@"authentication_state"];
            self.homePageModal.shop_state = info[@"shop_state"];
            self.homePageModal.isAttended = [info[@"isAttended"] boolValue];
            self.homePageModal.isCollected = [info[@"isCollected"]boolValue];
            self.homePageModal.synopsis = info[@"synopsis"];
            self.homePageModal.works_num = info[@"works_num"];
            self.homePageModal.concern_num = info[@"concern_num"];
            self.homePageModal.fan_num = info[@"fan_num"];
            self.homePageModal.dynamic_num = info[@"dynamic_num"];
            
            //请求成功后获取界面
           [SVProgressHUD dismissAfterDelay:0.4];
           [self performSelector:@selector(configUI) withObject:nil afterDelay:0];
        }
    }failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

#pragma mark - Private Menthod
-(AW_MyDetailHeadView*)headView{
    if (!_headView) {
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * user_id = [user objectForKey:@"user_id"];
        NSLog(@"%@",self.homePageModal.shop_state);
        if (!([self.person_id intValue] == [user_id intValue])) {
            if ([self.homePageModal.shop_state intValue] == 3) {
                _headView = [[NSBundle mainBundle]loadNibNamed:@"AW_MyDetailHeadView" owner:self options:nil][0];
            }else{
            _headView = [[NSBundle mainBundle]loadNibNamed:@"AW_MyDetailHeadView" owner:self options:nil][2];
            }
        }else{
           _headView = _headView = [[NSBundle mainBundle]loadNibNamed:@"AW_MyDetailHeadView" owner:self options:nil][1];
        }
    }
    return _headView;
}

-(AW_TarBarView*)btnView{
    if (!_btnView) {
        NSLog(@"%@",self.shop_state);
        _btnView.shop_State = self.shop_state;
        if ([self.shop_state intValue] == 3) {
            _btnView = BundleToObj(@"AW_TarBarView");
        }else{
         _btnView = [[NSBundle mainBundle]loadNibNamed:@"AW_TarBarView" owner:self options:nil][1];
        }    
    }
    return _btnView;
}

-(NSMutableArray*)photosArray{
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc]init];
    }
    return _photosArray;
}
#pragma mark - ConfigViewController Menthod
-(UITableViewController*)attentionTable{
    if (!_attentionTable) {
        _attentionTable = [[UITableViewController alloc]init];
        _attentionTable.tableView = self.myAttentionTableView;
        _attentionTable.tableView.backgroundColor = HexRGB(0xf6f7f8);
    }
    return _attentionTable;
}
-(UITableViewController*)fansTable{
    if (!_fansTable) {
        _fansTable = [[UITableViewController alloc]init];
        _fansTable.tableView = self.myFansTableView;
        _fansTable.tableView.backgroundColor = HexRGB(0xf6f7f8);
    }
    return _fansTable;
}
-(UITableViewController*)dynamicTable{
    if (!_dynamicTable) {
        _dynamicTable = [[UITableViewController alloc]init];
        _dynamicTable.tableView = self.myDynamicTableView;
        _dynamicTable.tableView.backgroundColor = HexRGB(0xf6f7f8);
    }
    return _dynamicTable;
}
-(UICollectionViewController*)produceCollection{
    if (!_produceCollection) {
        _produceCollection = [[UICollectionViewController alloc]init];
        _produceCollection.collectionView = self.myProductionView;
        _produceCollection.collectionView.backgroundColor = HexRGB(0xf6f7f8);
    }
    return _produceCollection;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    //获得头视图数据
    [self getJsonData];
  
    //只有是开店状态才显示我的作品
    if ([self.shop_state intValue] == 3) {
        self.viewControllers = @[self.produceCollection,self.attentionTable,self.fansTable,self.dynamicTable];
    }else{
        
        self.viewControllers = @[self.attentionTable,self.fansTable,self.dynamicTable];
    }
    //设置程序的整体背景颜色
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //点击添加关注按钮后的回调
    __weak typeof(self) weakSelf = self;
    self.attentionDataSource.didClickBtn = ^(NSInteger index){
        AW_AddNewAttentionController * addAttentionController = [[AW_AddNewAttentionController alloc]init];
        addAttentionController.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:addAttentionController animated:YES];
    };
    //点击headView图片按钮的回调
    self.productionDataSource.didClickTopImageBtn = ^(NSInteger index){
        AW_ActiveController * activeController = [[AW_ActiveController alloc]init];
        activeController.hidesBottomBarWhenPushed = YES;
        activeController.activeDataSource.activeImageURL = weakSelf.productionDataSource.activeImageURL;
        activeController.activeDataSource.active_id = weakSelf.productionDataSource.active_id;
        activeController.activeDataSource.activeName = weakSelf.productionDataSource.active_name;
        [weakSelf.navigationController pushViewController:activeController animated:YES];
    };
    //点击我的动态转发,评论,赞,按钮后的回调
    self.dynamicDataSource.didClickedBottomBtns = ^(NSInteger index,AW_MicroBlogListModal *modal){
        if (index == 1) {
            NSLog(@"点击转发按钮===%@==",modal.userModal.nickname);
        }else if (index == 2){
             NSLog(@"点击评论按钮===%@==",modal.userModal.nickname);
        }else if (index == 3){
             NSLog(@"点击赞按钮===%@==",modal.userModal.nickname);
        }
    };
    
    //点击图片按钮的回调
    self.dynamicDataSource.didClickedImageBtn = ^(NSArray * photoArray,NSInteger index){
        [weakSelf.photosArray removeAllObjects];
        weakSelf.photosArray = nil;
        [photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MWPhoto * photo = [[MWPhoto alloc]initWithURL:[NSURL URLWithString:obj]];
                [weakSelf.photosArray addObject:photo];
            
        }];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:weakSelf];
        browser.displayActionButton = NO;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = YES;
        [browser setCurrentPhotoIndex:index];
        
        [weakSelf.navigationController pushViewController:browser animated:YES];
        [browser reloadData];
    };
    //点击弹出视图确定或取消按钮的回调
    self.productionDataSource.didClickedConfirmBtn = ^(NSInteger index){
        if (index == 1) {
            AW_LoginInViewController * controller = [[AW_LoginInViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }else if (index == 2){
            NSLog(@"点击了取消按钮");
        }
    };
    //点击艺术品cell的回调
    self.productionDataSource.didClickedCell = ^(AW_ArtWorkModal *modal){
        AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
        controller.detailDataSource.commidity_id = modal.commidityModal.commodity_Id;
        controller.detailDataSource.isCollection = modal.commidityModal.isCollected;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
    //点击我的关注时没有登录状态（点击确定登陆按钮的回调）
    self.attentionDataSource.didClickedConfirmBtn = ^(){
        AW_LoginInViewController * controller = [[AW_LoginInViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
    //点击我的粉丝时没有登录状态（点击确定登陆按钮的回调）
    self.fansDataSource.didClickedFansConfirmBrn = ^(){
        AW_LoginInViewController * controller = [[AW_LoginInViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
}

-(void)configUI{
    
    [self addBackNavButton];
    [self addHeaderView];
    
    //为tarBar赋值
    self.btnView.produceNumber.text = [NSString stringWithFormat:@"%@",self.homePageModal.works_num];
    self.btnView.fansNumber.text = [NSString stringWithFormat:@"%@",self.homePageModal.fan_num];
    self.btnView.attentionNumber.text = [NSString stringWithFormat:@"%@",self.homePageModal.concern_num];
    self.btnView.dynamicNumber.text = [NSString stringWithFormat:@"%@",self.homePageModal.dynamic_num];
   
     self.slidePageScrollView.pageTabBar = self.btnView;
    self.slidePageScrollView.pageTabBarStopOnTopHeight = _isNoHeaderView? 0 : 20;
   
     [self.slidePageScrollView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =YES;
    
}


-(void)viewWillLayoutSubviews{
    [self performSelector:@selector(selectScrollerViewIndex) withObject:nil afterDelay:0];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self.markNumber isEqualToString:@"1"]) {
        [self.btnView clickedPageTabBarAtIndex:1];
        [self.btnView clickedPageTabBarAtIndex:0];
        self.markNumber = nil;
    }
    if (self.collectionStoreBtnTag == 2){
        [self.btnView clickedPageTabBarAtIndex:3];
    }else if(self.collectionStoreBtnTag == 1){
        [self.btnView clickedPageTabBarAtIndex:1];
        [self.btnView clickedPageTabBarAtIndex:0];
    }else if (self.collectionStoreBtnTag == 3){
        [self.btnView clickedPageTabBarAtIndex:1];
    }else if (self.collectionStoreBtnTag == 4){
        [self.btnView clickedPageTabBarAtIndex:2];
    }
    
    if (self.buttonWithoutProduceTag == 2){
        [self.btnView clickedPageTabBarAtIndex:2];
    }else if(self.buttonWithoutProduceTag == 3){
        [self.btnView clickedPageTabBarAtIndex:1];
        [self.btnView clickedPageTabBarAtIndex:0];
    }else if (self.buttonWithoutProduceTag == 4){
        [self.btnView clickedPageTabBarAtIndex:1];
    }
    
    if(self.PreviousButtonTag == 2){
        [self.btnView clickedPageTabBarAtIndex:3];
        [self.slidePageScrollView scrollToPageIndex:3 animated:0];
    }else if (self.PreviousButtonTag == 1 || self.PreviousButtonTag == 6){
        [self.btnView clickedPageTabBarAtIndex:1];
        [self.btnView clickedPageTabBarAtIndex:0];
    }else if(self.PreviousButtonTag == 3){
        [self.btnView clickedPageTabBarAtIndex:1];
    }else if(self.PreviousButtonTag == 4){
        [self.btnView clickedPageTabBarAtIndex:2];
    }
    
    if (self.myCollectionStoreBtnTag == 2){
        [self.btnView clickedPageTabBarAtIndex:3];
    }else if (self.myCollectionStoreBtnTag == 3){
        [self.btnView clickedPageTabBarAtIndex:1];
    }else if (self.myCollectionStoreBtnTag == 4){
        [self.btnView clickedPageTabBarAtIndex:2];
    }
    
    if (self.artStoreBtnTag == 2){
        [self.btnView clickedPageTabBarAtIndex:2];
    }else if (self.artStoreBtnTag == 3){
        [self.btnView clickedPageTabBarAtIndex:3];
    }else if (self.artStoreBtnTag == 5 || self.artStoreBtnTag == 1){
        [self.btnView clickedPageTabBarAtIndex:1];
        [self.btnView clickedPageTabBarAtIndex:0];
    }
    
    
    [self performSelector:@selector(btnTagMenthod) withObject:nil afterDelay:1];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)selectScrollerViewIndex{
    
   
}

-(void)btnTagMenthod{
    //跳转到指定的列表中后将传过来的按钮标签设置为0(防止点击其他按钮时出现混乱)
    _PreviousButtonTag = 0;
    _myCollectionStoreBtnTag = 0;
    _collectionStoreBtnTag = 0;
    _buttonWithoutProduceTag = 0;
    _artStoreBtnTag = 0;
}

#pragma mark - MWPhotoBrowserDelegate Menthod
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photosArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photosArray.count)
        return [self.photosArray objectAtIndex:index];
    return nil;
}

#pragma mark - DisplayDescribetionBtn Menthod

/**
 *  @author cao, 15-08-23 10:08:33
 *
 *  计算个人简介文本的高度
 *
 *  @param MyInfo 我的信息
 *
 *  @return 文本高度
 */
-(CGFloat)describeLabelHeightWithWithMyInfo:(AW_HomePageModal*)MyInfo{
    
    if (![MyInfo.synopsis isKindOfClass:[NSNull class]]) {
        self.headView.myDescribe.preferredMaxLayoutWidth = kSCREEN_WIDTH - 16;
        self.headView.myDescribe.text  = [NSString stringWithFormat:@"%@",MyInfo.synopsis];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGSize labelSize = [MyInfo.synopsis boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 16, 999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        return labelSize.height;
    }else{
        return 0;
    }
}

/**
 *  @author cao, 15-08-24 17:08:41
 *
 *  我的简介全部显示出来的方法
 */
-(void)displayDescribe{
    CGFloat labelHeight = [self describeLabelHeightWithWithMyInfo:self.homePageModal];
    if (self.headView.myDescribe.frame.size.height == 21) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.headView.frame;
            frame.size.height = self.headView.frame.size.height + labelHeight;
            self.headView.frame = frame;
            
            self.headView.containViewHeightContant.constant = self.headView.containViewHeightContant.constant + labelHeight;
            
            self.headView.topViewHeightConstant.constant = self.headView.topViewHeightConstant.constant + labelHeight;
            //设置展示详情的按钮的背景
            [self.headView.displayDescribeBtn setBackgroundImage:[UIImage imageNamed:@"市集-分类-收起图标"] forState:UIControlStateNormal];
        }];
    }else if(self.headView.myDescribe.frame.size.height > 21){
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.headView.frame;
            frame.size.height = self.headView.frame.size.height - labelHeight;
            self.headView.frame = frame;
            self.headView.containViewHeightContant.constant = 259;
            self.headView.topViewHeightConstant.constant = 217.0;
            //设置展示详情的按钮的背景
           [self.headView.displayDescribeBtn setBackgroundImage:[UIImage imageNamed:@"我的--详情--close arrow"] forState:UIControlStateNormal];
        }];
    }
    [self configUI];
}

#pragma mark - AddView Menthod
- (void)addBackNavButton
{  
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[[UIImage imageNamed:@"我的-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backBtn.adjustsImageWhenHighlighted = NO;
    //backBtn.frame = CGRectMake(10, 25, 30, 30);
    [backBtn addTarget:self action:@selector(navGoBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.slidePageScrollView addSubview:backBtn];
    _backBtn = backBtn;
    
    backBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.slidePageScrollView addConstraint:[NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.slidePageScrollView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.slidePageScrollView addConstraint:[NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.slidePageScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:25]];
    [backBtn addConstraint:[NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:30]];
    [backBtn addConstraint:[NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:30]];
    
    //只有是查看别人详情时才才显示右侧的对话按钮
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    if (!([user_id integerValue] == [self.person_id integerValue])) {
        UIButton *talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [talkBtn setImage:[[UIImage imageNamed:@"我的详情--对话"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        talkBtn.adjustsImageWhenHighlighted = NO;
        [talkBtn addTarget:self action:@selector(talkClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.slidePageScrollView addSubview:talkBtn];
        _talkBtn = talkBtn;
        
        talkBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.slidePageScrollView addConstraint:[NSLayoutConstraint constraintWithItem:talkBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.slidePageScrollView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
        [self.slidePageScrollView addConstraint:[NSLayoutConstraint constraintWithItem:talkBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.slidePageScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:25]];
        [talkBtn addConstraint:[NSLayoutConstraint constraintWithItem:talkBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:30]];
        [talkBtn addConstraint:[NSLayoutConstraint constraintWithItem:talkBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:30]];
    }
    _backBtn.hidden = _isNoHeaderView;
    _talkBtn.hidden = _isNoHeaderView;
}

- (void)addHeaderView{
    UIView * headView = self.headView;
    [self.headView.displayDescribeCoverBtn addTarget:self action:@selector(displayDescribe) forControlEvents:UIControlEventTouchUpInside];
    //点击按钮的头视图按钮的回调
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    __weak typeof(self) weakSelf = self;
    self.headView.didClickedBtn = ^(NSInteger index){
        if (index == 100) {
            NSLog(@"%@",weakSelf.person_id);
            if ([weakSelf.person_id intValue] == [user_id intValue]) {
                AW_MyInformationViewController * infoController = [[AW_MyInformationViewController alloc]init];
                [weakSelf.navigationController pushViewController:infoController animated:YES];
            }else{
                AW_OtherInfoController * controller = [[AW_OtherInfoController alloc]init];
                controller.infoDataSource.user_id = weakSelf.person_id;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
        }else if(index == 200) {
            if (user_id) {
                //在这进行添加关注请求
                if (weakSelf.headView.AttentionCover.selected == NO){
                    NSLog(@"被关注的人的id：%@",weakSelf.person_id);
                    NSDictionary * dict = @{@"personId":weakSelf.person_id,@"userId":user_id};
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
                    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSDictionary * attendict = @{@"param":@"addAttention",@"jsonParam":str};
                    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                    [manager POST:ARTSCOME_INT parameters:attendict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSLog(@"%@",responseObject);
                        if ([responseObject[@"code"]intValue] == 0) {
                            //请求成功后改变modal值
                            weakSelf.headView.AttentionCover.selected = YES;
                            [weakSelf showHUDWithMessage:@"添加关注成功"];
                        }
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }];
                }else if (weakSelf.headView.AttentionCover.selected == YES){
                    //在这进行取消关注请求
                    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                    NSString * user_id = [user objectForKey:@"user_id"];
                    NSDictionary * dict = @{@"personId":weakSelf.person_id,@"userId":user_id};
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
                    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSDictionary * cancleDict = @{@"param":@"cancelAttention",@"jsonParam":str};
                    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                    [manager POST:ARTSCOME_INT parameters:cancleDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSLog(@"%@",responseObject);
                        if ([responseObject[@"code"]intValue] == 0) {
                            //请求成功后改变modal值
                            weakSelf.headView.AttentionCover.selected = NO;
                            [weakSelf showHUDWithMessage:@"取消关注成功"];
                        }
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }];
                }
                    
            }else{
                //如果是没有登录状态就跳转到登陆界面
                DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
                AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:weakSelf options:nil][1];
                contentView.bounds = Rect(0, 0, 272, 130);
                alertView.contentView = contentView;
                [alertView showWithoutAnimation];
                //点击确定或取消按钮的回调(弹出视图)
                contentView.didClickedBtn = ^(NSInteger index){
                    if (index == 1) {
                        AW_LoginInViewController * controller = [[AW_LoginInViewController alloc]init];
                        controller.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:controller animated:YES];
                    }else if(index == 2){
                        NSLog(@"点击了取消按钮。。。");
                    }
                };
            
            }
        }else if (index == 300){
            if (user_id) {
                if (weakSelf.headView.storeButton.selected == NO) {
                    //在这进行收藏店铺的请求
                    NSLog(@"%@",weakSelf.shop_id);
                    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                    NSString * user_id = [user objectForKey:@"user_id"];
                    NSDictionary * dict = @{@"userId":user_id,@"personId":weakSelf.shop_id};
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
                    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSDictionary * storeDict = @{@"jsonParam":str,@"token":@"android",@"param":@"collShop"};
                    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                    [manager POST:ARTSCOME_INT parameters:storeDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSLog(@"%@",responseObject);
                        if ([responseObject[@"code"]intValue] == 0) {
                            weakSelf.headView.storeButton.selected = YES;
                            [weakSelf showHUDWithMessage:@"收藏店铺成功"];
                        }
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }];
                    
                }else if (weakSelf.headView.storeButton.selected == YES) {
                    //在这进行取消收藏店铺的请求
                    NSLog(@"%@",weakSelf.shop_id);
                    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                    NSString * user_id = [user objectForKey:@"user_id"];
                    NSDictionary * dict = @{@"userId":user_id,@"personId":weakSelf.shop_id};
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
                    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSDictionary * storeDict = @{@"jsonParam":str,@"token":@"android",@"param":@"collShop"};
                    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                    [manager POST:ARTSCOME_INT parameters:storeDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSLog(@"%@",responseObject);
                        if ([responseObject[@"code"]intValue] == 0) {
                            weakSelf.headView.storeButton.selected = NO;
                            [weakSelf showHUDWithMessage:@"取消收藏店铺成功"];
                        }
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }];
                }
            }else{
                //如果是没有登录状态就跳转到登陆界面
                DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
                AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:weakSelf options:nil][1];
                contentView.bounds = Rect(0, 0, 272, 130);
                alertView.contentView = contentView;
                [alertView showWithoutAnimation];
                //点击确定或取消按钮的回调(弹出视图)
                contentView.didClickedBtn = ^(NSInteger index){
                    if (index == 1) {
                        AW_LoginInViewController * controller = [[AW_LoginInViewController alloc]init];
                        controller.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:controller animated:YES];
                    }else if(index == 2){
                        NSLog(@"点击了取消按钮。。。");
                    }
                };
            
            }
            
        }
    
    };
    //为headView赋值
    [self.headView.myImage sd_setImageWithURL:[NSURL URLWithString:self.homePageModal.head_img]placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.headView.myName.text = [NSString stringWithFormat:@"%@",self.homePageModal.nickName];
    if (![self.homePageModal.synopsis isKindOfClass:[NSNull class]]) {
        self.headView.myDescribe.text = [NSString stringWithFormat:@"%@",self.homePageModal.synopsis];
    }
    if ([self.homePageModal.authentication_state intValue] == 3) {
        self.headView.vipImage.hidden = NO;
    }else{
        self.headView.vipImage.hidden = YES;
    }
    if (self.homePageModal.isAttended == YES) {
        self.headView.AttentionCover.selected = YES;
    }else{
        self.headView.AttentionCover.selected = NO;
    }
    if (self.homePageModal.isCollected == YES) {
        self.headView.storeButton.selected = YES;
    }else{
        self.headView.storeButton.selected = NO;
    }
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), CGRectGetHeight(self.headView.frame))];
    view.userInteractionEnabled = YES;
    [view addSubview:headView];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:headView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:headView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:headView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:headView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    self.slidePageScrollView.headerView = _isNoHeaderView ? nil : view;
}

- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView pageTabBarScrollOffset:(CGFloat)offset state:(TYPageTabBarState)state{
    switch (state) {
        case TYPageTabBarStateStopOnTop:
            _backBtn.hidden = YES;
            _talkBtn.hidden = YES;
            break;
        case TYPageTabBarStateStopOnButtom:
            break;
        default:
            if (_backBtn.isHidden) {
                _backBtn.hidden = NO;
            }
            if (_talkBtn.isHidden) {
                _talkBtn.hidden = NO;
            }
            break;
    }
}

- (void)clickedPageTabBarStopOnTop:(UIButton *)button
{
    button.selected = !button.isSelected;
    self.slidePageScrollView.pageTabBarIsStopOnTop = !button.isSelected;
}

#pragma mark - ButtonClicked Menthod
- (void)talkClicked:(UIButton *)button{
    NSString * user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    if(user_id){
        if ([self.homePageModal.shop_state intValue] == 3) {
            ChatViewController *chatView = [[ChatViewController alloc]initWithChatter:self.homePageModal.user_hxid conversationType:eConversationTypeChat];
            chatView.navigationItem.title = self.homePageModal.user_hxid;
            chatView.shopIM_phone = self.homePageModal.user_hxid;
            NSLog(@"店主id%@",self.homePageModal.user_hxid);
            chatView.shoper_id = self.person_id;
            chatView.shop_id = self.shop_id;
            [self.navigationController pushViewController:chatView animated:YES];
        }
    }else{
        //如果是没有登录状态就跳转到登陆界面
        DeliveryAlertView * alertView = [[DeliveryAlertView alloc]init];
        AW_DeleteAlertMessage * contentView = [[NSBundle mainBundle]loadNibNamed:@"AW_DeleteAlertMessage" owner:self options:nil][1];
        contentView.bounds = Rect(0, 0, 272, 130);
        alertView.contentView = contentView;
        [alertView showWithoutAnimation];
        //点击确定或取消按钮的回调(弹出视图)
        contentView.didClickedBtn = ^(NSInteger index){
            if (index == 1) {
                AW_LoginInViewController * controller = [[AW_LoginInViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }else if(index == 2){
                NSLog(@"点击了取消按钮。。。");
            }
        };
    }
}

- (void)navGoBack:(UIButton *)button
{    self.slidePageScrollView.pageTabBar.horIndicatorView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Private Method

-(UICollectionView*)myProductionView{
    if (!_myProductionView) {
        WaterFLayout *layout = [[WaterFLayout alloc]init];
            //在这判断什么时候显示头视图
            NSLog(@"%@",self.productionDataSource.activeDictionary);
            if ([self.productionDataSource.activeDictionary isKindOfClass:[NSNull class]]) {
                layout.headerHeight = 0;
            }else{
                layout.headerHeight = 140;
            }
    _myProductionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0) collectionViewLayout:layout];
        _myProductionView.backgroundColor = [UIColor clearColor];
        _myProductionView.userInteractionEnabled = YES;
        _myProductionView.alwaysBounceVertical = YES;
        
        /**
         *  @author cao, 15-08-17 11:08:40
         *
         *  我的作品CollectionView
         */
        UINib *cellNib = [UINib nibWithNibName:@"AW_ProduceCollectionCell" bundle:nil];
        [_myProductionView registerNib:cellNib forCellWithReuseIdentifier:@"MyProduceCell"];
        NSLog(@"%@",self.productionDataSource.activeDictionary);
        //在这判断什么时候显示头视图
            NSLog(@"%@",self.productionDataSource.activeDictionary);
            if (![self.productionDataSource.activeDictionary isKindOfClass:[NSNull class]]) {
                [_myProductionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"MyProduceHeadView"];
            }
        _myProductionView.dataSource = self.productionDataSource;
        _myProductionView.delegate = self.productionDataSource;
        self.productionDataSource.collectionView = _myProductionView;
        self.productionDataSource.hasRefreshHeader = YES;
        self.productionDataSource.hasLoadMoreFooter = YES;
    }
    return _myProductionView;
}

-(UITableView*)myAttentionTableView{
    if (!_myAttentionTableView) {
        _myAttentionTableView = [[UITableView alloc]init];
        _myAttentionTableView.delegate = self.attentionDataSource;
        _myAttentionTableView.dataSource = self.attentionDataSource;
        self.attentionDataSource.tableView = _myAttentionTableView;
        self.attentionDataSource.hasRefreshHeader = YES;
        self.attentionDataSource.hasLoadMoreFooter = YES;
        _myAttentionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myAttentionTableView.backgroundColor = [UIColor clearColor];
    }
    return _myAttentionTableView;
}

-(UITableView*)myFansTableView{
    if (!_myFansTableView) {
        _myFansTableView = [[UITableView alloc]init];
        _myFansTableView.delegate = self.fansDataSource;
        _myFansTableView.dataSource = self.fansDataSource;
        self.fansDataSource.tableView = _myFansTableView;
        self.fansDataSource.hasLoadMoreFooter = YES;
        self.fansDataSource.hasRefreshHeader = YES;
        _myFansTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myFansTableView.backgroundColor = [UIColor clearColor];
    }
    return _myFansTableView;
}

-(UITableView*)myDynamicTableView{
    if (!_myDynamicTableView) {
        _myDynamicTableView = [[UITableView alloc]init];
        _myDynamicTableView.delegate = self.dynamicDataSource;
        _myDynamicTableView.dataSource = self.dynamicDataSource;
        self.dynamicDataSource.tableView = _myDynamicTableView;
        self.dynamicDataSource.hasRefreshHeader  = YES;
        self.dynamicDataSource.hasLoadMoreFooter = YES;
        _myDynamicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myDynamicTableView.backgroundColor = [UIColor clearColor];
    }
    return _myDynamicTableView;
}

#pragma mark - dataSource Menthod
-(AW_MineProductionDataSource*)productionDataSource{
    if (!_productionDataSource) {
        _productionDataSource = [[AW_MineProductionDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
        }];
    }
    return _productionDataSource;
}

-(AW_MyAttentionDataSource*)attentionDataSource{
    if (!_attentionDataSource) {
        _attentionDataSource = [[AW_MyAttentionDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
        }];
    }
    return _attentionDataSource;
}
-(AW_MyFansDataSource*)fansDataSource{
    if (!_fansDataSource) {
        _fansDataSource = [[AW_MyFansDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
        }];
    }
    return _fansDataSource;
}
-(AW_MyDynamicDataSource*)dynamicDataSource{
    if (!_dynamicDataSource) {
        _dynamicDataSource = [[AW_MyDynamicDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
        }];
    }
    return _dynamicDataSource;
}

#pragma mark - ShowMessage Menthod
- (void)showHUDWithMessage:(NSString*)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = msg;
    hud.labelFont = [UIFont boldSystemFontOfSize:13];
    hud.margin = 10.f;
    hud.cornerRadius = 4.0;
    hud.yOffset = 150.f;
    hud.alpha = 0.9;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma mark - ScrollerViewDelegate Menthod
- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView horizenScrollToPageIndex:(NSInteger)index{
    //NSLog(@"%ld",index);
    if ([self.shop_state intValue] == 3) {
        //开店的情况下
        self.btnView.currentIndex = index;
       // NSLog(@"current ScrollView index :%ld",index);
        UIButton * button = self.btnView.buttonArray[index];
        self.btnView.selectBtn = button;
        //改变水平指示器的位置
        if (self.btnView.selectBtn) {
            CGRect frame = self.btnView.horIndicatorView.frame;
            frame.origin.x = (kSCREEN_WIDTH/4)*(self.btnView.selectBtn.tag - 1);
            [UIView animateWithDuration:0.2 animations:^{
                self.btnView.horIndicatorView.frame = frame;}];
        }else{
            CGRect frame = self.btnView.horIndicatorView.frame;
            frame.origin.x = 0;
            [UIView animateWithDuration:0.2 animations:^{
                self.btnView.horIndicatorView.frame = frame;
            }];
        }
        //改变字体颜色
        [self changeLabelColor];
        //改变水平指示器的位置
        self.btnView.horIndicatorView.frame = CGRectMake((index*kSCREEN_WIDTH/4), 40, kSCREEN_WIDTH/4, 2);
    }else{
        //没有开店的情况下
        //改变水平指示器的位置
        self.btnView.selectBtn = self.btnView.buttonsWithoutProduce[index];
        self.btnView.horIndicatorView.bounds = Rect(0, 0, kSCREEN_WIDTH/3, 2);
        if (self.btnView.selectBtn) {
            CGRect frame = self.btnView.horIndicatorView.frame;
            frame.origin.x = (kSCREEN_WIDTH/3)*(self.btnView.selectBtn.tag - 101);
            [UIView animateWithDuration:0.2 animations:^{
                self.btnView.horIndicatorView.frame = frame;}];
        }else{
            CGRect frame = self.self.btnView.horIndicatorView.frame;
            frame.origin.x = 0;
            [UIView animateWithDuration:0.2 animations:^{
                self.btnView.horIndicatorView.frame = frame;
            }];
        }
        
        //改变字体颜色
        if (index == 0) {
            self.btnView.attentionLabel.textColor = [UIColor orangeColor];
            self.btnView.attentionNumber.textColor = [UIColor orangeColor];
            self.btnView.fansLabel.textColor =[UIColor blackColor] ;
            self.btnView.fansNumber.textColor = [UIColor blackColor];
            self.btnView.dynamicLabel.textColor =[UIColor blackColor];
            self.btnView.dynamicNumber.textColor = [UIColor blackColor];
        }else if (index == 1){
            self.btnView.attentionLabel.textColor = [UIColor blackColor];
            self.btnView.attentionNumber.textColor = [UIColor blackColor];
            self.btnView.fansLabel.textColor =[UIColor orangeColor] ;
            self.btnView.fansNumber.textColor = [UIColor orangeColor];
            self.btnView.dynamicLabel.textColor =[UIColor blackColor];
            self.btnView.dynamicNumber.textColor = [UIColor blackColor];
        }else if (index == 2){
            self.btnView.attentionLabel.textColor = [UIColor blackColor];
            self.btnView.attentionNumber.textColor = [UIColor blackColor];
            self.btnView.fansLabel.textColor =[UIColor blackColor] ;
            self.btnView.fansNumber.textColor = [UIColor blackColor];
            self.btnView.dynamicLabel.textColor =[UIColor orangeColor];
            self.btnView.dynamicNumber.textColor = [UIColor orangeColor];
        }
        //改变水平指示器的位置
        self.btnView.horIndicatorView.frame = CGRectMake((index*kSCREEN_WIDTH/3), 40, kSCREEN_WIDTH/3, 2);
    }
}

-(void)changeLabelColor{
    switch (self.btnView.selectBtn.tag) {
        case 1:
            self.btnView.produceLabel.textColor = [UIColor orangeColor];
            self.btnView.produceNumber.textColor = [UIColor orangeColor];
            self.btnView.attentionLabel.textColor = [UIColor blackColor];
            self.btnView.attentionNumber.textColor = [UIColor blackColor];
            self.btnView.fansLabel.textColor =[UIColor blackColor] ;
            self.btnView.fansNumber.textColor = [UIColor blackColor];
            self.btnView.dynamicLabel.textColor =[UIColor blackColor];
            self.btnView.dynamicNumber.textColor = [UIColor blackColor];
            break;
        case 2:
            self.btnView.produceLabel.textColor = [UIColor blackColor];
            self.btnView.produceNumber.textColor = [UIColor blackColor];
            self.btnView.attentionLabel.textColor = [UIColor orangeColor];
            self.btnView.attentionNumber.textColor = [UIColor orangeColor];
            self.btnView.fansLabel.textColor =[UIColor blackColor];
            self.btnView.fansNumber.textColor = [UIColor blackColor];
            self.btnView.dynamicLabel.textColor =[UIColor blackColor];
            self.btnView.dynamicNumber.textColor = [UIColor blackColor];
            break;
        case 3:
            self.btnView.produceLabel.textColor = [UIColor blackColor];
            self.btnView.produceNumber.textColor = [UIColor blackColor];
            self.btnView.fansLabel.textColor = [UIColor orangeColor];
            self.btnView.fansNumber.textColor = [UIColor orangeColor];
            self.btnView.attentionLabel.textColor = [UIColor blackColor];
            self.btnView.attentionNumber.textColor = [UIColor blackColor];
            self.btnView.dynamicLabel.textColor =[UIColor blackColor];
            self.btnView.dynamicNumber.textColor = [UIColor blackColor];
            break;
        case 4:
            self.btnView.produceLabel.textColor = [UIColor blackColor];
            self.btnView.produceNumber.textColor = [UIColor blackColor];
            self.btnView.dynamicLabel.textColor =[UIColor orangeColor];
            self.btnView.dynamicNumber.textColor = [UIColor orangeColor];
            self.btnView.attentionLabel.textColor =[UIColor blackColor];
            self.btnView.attentionNumber.textColor = [UIColor blackColor];
            self.btnView.fansLabel.textColor =[UIColor blackColor];
            self.btnView.fansNumber.textColor = [UIColor blackColor];            break;
        default:
            break;
    }
}

@end
