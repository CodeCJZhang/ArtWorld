//
//  AW_ActiveController.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/18.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ActiveController.h"
#import "AW_ActiveHeadView.h"
#import "WaterFLayout.h"
#import "AW_LoginInViewController.h"
#import "AW_ArtDetailController.h"//艺术品详情控制器

@interface AW_ActiveController ()

/**
 *  @author cao, 15-09-18 16:09:06
 *
 *  活动collectionView
 */
@property(nonatomic,strong)UICollectionView * activeCollectionView;
@end

@implementation AW_ActiveController

#pragma mark - Private Menthod
-(AW_ActiveDataSource*)activeDataSource{
    if (!_activeDataSource) {
        _activeDataSource = [[AW_ActiveDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _activeDataSource;
}

-(UICollectionView*)activeCollectionView{
    if (!_activeCollectionView) {
        WaterFLayout * layout = [[WaterFLayout alloc]init];
        layout.headerHeight = 110;
        _activeCollectionView = [[UICollectionView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT)collectionViewLayout:layout];
        _activeCollectionView.userInteractionEnabled = YES;
        _activeCollectionView.alwaysBounceVertical = YES;
        _activeCollectionView.dataSource = self.activeDataSource;
        _activeCollectionView.delegate = self.activeDataSource;
        _activeCollectionView.backgroundColor = HexRGB(0xf6f7f8);
        
        UINib * cellNib = [UINib nibWithNibName:@"AW_ProduceCollectionCell" bundle:nil];
        [_activeCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"ActiveCell"];
        [_activeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"ActiveHeadView"];
        self.activeDataSource.collectionView = _activeCollectionView;
        self.activeDataSource.hasLoadMoreFooter = YES;
        self.activeDataSource.hasRefreshHeader = YES;
    }
    return _activeCollectionView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.activeCollectionView];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"活动";
    //点击弹出视图确定按钮的回调(是否跳到登陆界面)
    __weak typeof(self)weakSelf = self;
    self.activeDataSource.didclickedBtn = ^(NSInteger index){
        if (index == 1) {
            AW_LoginInViewController * controller = [[AW_LoginInViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }else if (index == 2){
            NSLog(@"点击了取消按钮");
        }
    };
    //点击艺术品cell的回调
    self.activeDataSource.didClickedIterm = ^(AW_SimilaryCommodityModal  *modal){
        AW_ArtDetailController * controller = [[AW_ArtDetailController alloc]init];
        controller.detailDataSource.commidity_id = modal.commidityModal.commodity_Id;
        controller.detailDataSource.isCollection = modal.commidityModal.isCollected;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
}

-(void)getAciveTitle{
    
    NSLog(@"%@",self.activeDataSource.activeName);
    self.navigationItem.title = self.activeDataSource.activeName;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(getAciveTitle) withObject:nil afterDelay:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
