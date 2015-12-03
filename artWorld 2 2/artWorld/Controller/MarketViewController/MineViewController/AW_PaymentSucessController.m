//
//  AW_PaymentSucessController.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_PaymentSucessController.h"
#import "AW_PaymentSucessHeadView.h"
#import "AW_Constants.h"
#import "WaterFLayout.h"
#import "AW_MyShopCarViewController.h"
#import "SVProgressHUD.h"
#import "AW_ArtDetailController.h"//艺术品详情控制器
#import "ChatViewController.h"
#import "MBProgressHUD.h"

@interface AW_PaymentSucessController ()

/**
 *  @author cao, 15-09-12 17:09:27
 *
 *  支付成功头视图
 */
@property(nonatomic,strong)AW_PaymentSucessHeadView * paymentHeadView;
/**
 *  @author cao, 15-09-12 17:09:39
 *
 *  付款成功collectionView
 */
@property(nonatomic,strong)UICollectionView * paySucessCollectionView;

@end

@implementation AW_PaymentSucessController

#pragma mark - Private Menthod
-(AW_PaymentSucessHeadView*)paymentHeadView{
    if (!_paymentHeadView) {
        _paymentHeadView = BundleToObj(@"AW_PaymentSucessHeadView");
    }
    return _paymentHeadView;
}

-(AW_PaymentSucessDataSource*)paySucessDataSource{
    if (!_paySucessDataSource) {
        _paySucessDataSource = [[AW_PaymentSucessDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _paySucessDataSource;
}

-(UICollectionView*)paySucessCollectionView{
    if (!_paySucessCollectionView) {
        WaterFLayout * layout = [[WaterFLayout alloc]init];
        layout.headerHeight = 280.0;
        _paySucessCollectionView = [[UICollectionView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT)collectionViewLayout:layout];
        _paySucessCollectionView.dataSource = self.paySucessDataSource;
        _paySucessCollectionView.delegate = self.paySucessDataSource;
        _paySucessCollectionView.backgroundColor = [UIColor clearColor];
        _paySucessCollectionView.userInteractionEnabled = YES;
        _paySucessCollectionView.alwaysBounceVertical = YES;
        
        //注册collectionView的cell和头部视图
        UINib * cellNib = [UINib nibWithNibName:@"AW_ProduceCollectionCell" bundle:nil];
        [_paySucessCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"paymentSucessCell"];
        [_paySucessCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"paymentSucessHeadView"];
        self.paySucessDataSource.collectionView = _paySucessCollectionView;
        self.paySucessDataSource.hasLoadMoreFooter = YES;
        self.paySucessDataSource.hasRefreshHeader = NO;
    }
    return _paySucessCollectionView;
}
#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.paySucessDataSource.currentPage = @"1";
    [self.view addSubview:self.paySucessCollectionView];
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"支付成功";
    //点击联系卖家以后点击店铺名称cell的回调
    __weak typeof(self) weakSelf = self;
    self.paySucessDataSource.didClickedStoreCell = ^(AW_MyShopCartModal * storeModal){
        NSLog(@"传到controller中的商铺名称====%@===",storeModal.storeModal.shoper_id);
        //跳转到聊天界面
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * user_phone = [user objectForKey:@"name"];
        if (![storeModal.storeModal.shoper_IM_Id isEqualToString:user_phone]) {
            ChatViewController *chatView = [[ChatViewController alloc]initWithChatter:storeModal.storeModal.shoper_IM_Id conversationType:eConversationTypeChat];
            chatView.navigationItem.title = storeModal.storeModal.shoper_IM_Id;
            chatView.shopIM_phone = storeModal.storeModal.shoper_IM_Id;
            chatView.shoper_id = storeModal.storeModal.shoper_id;
            chatView.shop_id = storeModal.storeModal.shop_Id;
            [weakSelf.navigationController pushViewController:chatView animated:YES];
        }else{
            [weakSelf showHUDWithMessage:@"不能和自己聊天"];
        }
    };
    //添加提示信息
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissAfterDelay:1];
    [self performSelector:@selector(configData) withObject:nil afterDelay:1];
    //点击艺术品cell的回调
    self.paySucessDataSource.didClickedCell = ^(AW_MarketModal * modal){
        AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
        controller.detailDataSource.commidity_id = modal.commidityModal.commodity_Id;
        controller.detailDataSource.isCollection = modal.commidityModal.isCollected;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
}

-(void)configData{
    //获取数据
    [self.paySucessDataSource getTestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    AW_MyShopCarViewController * shopController = [[AW_MyShopCarViewController alloc]init];
  [self.navigationController pushViewController:shopController animated:YES];
    
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

@end
