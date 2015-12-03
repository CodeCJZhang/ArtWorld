//
//  AW_SimilaryProduceController.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/9.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_SimilaryProduceController.h"
#import "WaterFLayout.h"
#import "AW_LoginInViewController.h"
#import "AW_ArtDetailController.h"//艺术品详情控制器

@interface AW_SimilaryProduceController ()

/**
 *  @author cao, 15-10-09 18:10:04
 *
 *  相似产品collectionView
 */
@property(nonatomic,strong)UICollectionView *similaryCollectionView;

@end

@implementation AW_SimilaryProduceController

#pragma mark - Private Menthod
-(AW_SimilaryProduceDataSource*)similaryDataSource{
    if (!_similaryDataSource) {
        _similaryDataSource = [[AW_SimilaryProduceDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _similaryDataSource;
}

-(UICollectionView*)similaryCollectionView{
    if (!_similaryCollectionView) {
        WaterFLayout * flayout = [[WaterFLayout alloc]init];
        _similaryCollectionView = [[UICollectionView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT) collectionViewLayout:flayout];
        _similaryCollectionView.backgroundColor = [UIColor clearColor];
        _similaryCollectionView.userInteractionEnabled = YES;
        _similaryCollectionView.alwaysBounceVertical = YES;
        
        UINib *cellNib = [UINib nibWithNibName:@"AW_ProduceCollectionCell" bundle:nil];
        [_similaryCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"MyProduceCell"];
        _similaryCollectionView.dataSource = self.similaryDataSource;
        _similaryCollectionView.delegate = self.similaryDataSource;
        self.similaryDataSource.collectionView = _similaryCollectionView;
        self.similaryDataSource.hasRefreshHeader = YES;
        self.similaryDataSource.hasLoadMoreFooter = YES;

    }
    return _similaryCollectionView;
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"相似产品";
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //添加collectionView
    [self.view addSubview:self.similaryCollectionView];
    
    //点击弹出视图确定或取消按钮的回调(是否进入注册界面)
    __weak typeof(self) weakSelf = self;
    self.similaryDataSource.didClickedBtn = ^(NSInteger index){
        if (index == 1) {
            AW_LoginInViewController * controller = [[AW_LoginInViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }else if (index == 2){
            NSLog(@"点击了取消按钮");
       }
    };
    //点击商品cell的回调
    self.similaryDataSource.didClickCell = ^(NSString * commidity_id){
        AW_ArtDetailController * detailController = [[AW_ArtDetailController alloc]init];
        detailController.hidesBottomBarWhenPushed = YES;
        detailController.detailDataSource.commidity_id = commidity_id;
        [weakSelf.navigationController pushViewController:detailController animated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
