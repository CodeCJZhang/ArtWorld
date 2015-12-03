//
//  AW_SelectPreferenceController.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/2.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SelectPreferenceController.h"
#import "WaterFLayout.h"
#import "AW_Constants.h"
#import "AW_PreferenceDataSource.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

@interface AW_SelectPreferenceController ()
/**
 *  @author cao, 15-09-02 17:09:24
 *
 *  选择偏好collectionView
 */
@property(nonatomic,strong)UICollectionView * preferenceCollectionView;
/**
 *  @author cao, 15-09-02 17:09:31
 *
 *  选择偏好数据源
 */
@property(nonatomic,strong)AW_PreferenceDataSource * dataSource;

@end
@implementation AW_SelectPreferenceController

#pragma mark - Private Menthod
-(AW_PreferenceDataSource*)dataSource{
    if (!_dataSource) {
        _dataSource = [[AW_PreferenceDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _dataSource;
}

-(UICollectionView*)preferenceCollectionView{
    if (!_preferenceCollectionView) {
        WaterFLayout * layout = [[WaterFLayout alloc]init];
        layout.columnCount = 3;
        _preferenceCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT) collectionViewLayout:layout];
        _preferenceCollectionView.backgroundColor = [UIColor clearColor];
        _preferenceCollectionView.userInteractionEnabled = YES;
        _preferenceCollectionView.alwaysBounceVertical = YES;
        
        UINib * cellNib = [UINib nibWithNibName:@"AW_MyPreferenceCell" bundle:nil];
        [_preferenceCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"preferenceCell"];
        _preferenceCollectionView.delegate = self.dataSource;
        _preferenceCollectionView.dataSource = self.dataSource;
        self.dataSource.collectionView = _preferenceCollectionView;
        //self.dataSource.hasLoadMoreFooter = NO;
       // self.dataSource.hasRefreshHeader = NO;
    }
    return _preferenceCollectionView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.preferenceCollectionView];
    self.navigationItem.title = @"选择偏好";
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置背景颜色
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    self.preferenceCollectionView.backgroundColor = [UIColor clearColor];
    //添加右侧完成按钮
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:0 target:self action:@selector(completeBtnClicked)];
    rightBtn.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //加载数据提示信息
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissAfterDelay:1];
    [self performSelector:@selector(relodData) withObject:nil afterDelay:1];
}

-(void)relodData{
    //获取测试数据
    [self.dataSource getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ButtonClick Menthod
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)completeBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
    //如果数组个数大于0说明至少选择了一个
    if (self.dataSource.selectModalArray.count == 0) {
        [self showHUDWithMessage:@"您还没有选择偏好"];
    }else if (self.dataSource.selectModalArray.count > 0){
        [_delegate didClickCompleteBtnWithSelectArray:self.dataSource.selectModalArray];
    }
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
