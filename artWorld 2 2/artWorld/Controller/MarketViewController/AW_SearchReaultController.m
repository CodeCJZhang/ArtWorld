//
//  AW_SearchReaultController.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_SearchReaultController.h"
#import "AW_SearchView.h"
#import "AW_Constants.h"
#import "AFNetworking.h"
#import "AW_BigClassModal.h"
#import "AW_SmallClassModal.h"
#import "AW_BigClassCell.h"
#import "AW_SmallClassCell.h"
#import "AW_IntelligenceCell.h"//智能分类cell
#import "AW_IntelligenceModal.h"
#import "AW_ProvinceModal.h"//省份modal
#import "AW_CityModal.h"//城市modl
#import "AW_ProvinceCell.h"
#import "AW_CityCell.h"
#import "AW_SearchResultDataSource.h"//搜索结果数据源
#import "WaterFLayout.h"
#import "AW_ArtDetailController.h"//艺术品详情界面

@interface AW_SearchReaultController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  @author cao, 15-12-03 11:12:34
 *
 *  记录省份string
 */
@property(nonatomic,copy)NSString * provinceString;
/**
 *  @author cao, 15-12-03 11:12:36
 *
 *  记录省份id
 */
@property(nonatomic,copy)NSString * province_id;
/**
 *  @author cao, 15-10-26 22:10:46
 *
 *  搜索视图
 */
@property(nonatomic,strong)AW_SearchView * searchView;
/**
 *  @author cao, 15-10-26 22:10:56
 *
 *  背景视图
 */
@property(nonatomic,strong)UIControl * backgroungView;
/**
 *  @author cao, 15-10-26 22:10:13
 *
 *  大分类数组
 */
@property(nonatomic,strong)NSMutableArray * bigClassArray;
/**
 *  @author cao, 15-10-26 22:10:16
 *
 *  小分类数组
 */
@property(nonatomic,strong)NSMutableArray * smallClassArray;
/**
 *  @author cao, 15-10-27 09:10:49
 *
 *  智能分类array
 */
@property(nonatomic,strong)NSMutableArray * intelligenceArray;
/**
 *  @author cao, 15-10-26 22:10:19
 *
 *  第一级列表
 */
@property(nonatomic,strong)UITableView * firstLevelTable;
/**
 *  @author cao, 15-10-26 22:10:22
 *
 *  第二级列表
 */
@property(nonatomic,strong)UITableView * secondLevelTable;
/**
 *  @author cao, 15-10-27 09:10:13
 *
 *  智能分类列表
 */
@property(nonatomic,strong)UITableView * intelligenceTable;
/**
 *  @author cao, 15-10-26 22:10:34
 *
 *  容器视图
 */
@property(nonatomic,strong)UIView * containerView;
/**
 *  @author cao, 15-10-26 23:10:22
 *
 *  图标数组
 */
@property(nonatomic,strong)NSArray * iconArray;
/**
 *  @author cao, 15-10-27 10:10:58
 *
 *  省份数组
 */
@property(nonatomic,strong)NSMutableArray * ProvinceArray;
/**
 *  @author cao, 15-10-27 10:10:01
 *
 *  城市数组
 */
@property(nonatomic,strong)NSMutableArray * cityArray;
/**
 *  @author cao, 15-10-27 10:10:04
 *
 *  省份列表
 */
@property(nonatomic,strong)UITableView * ProvinceTable;
/**
 *  @author cao, 15-10-27 10:10:06
 *
 *  城市列表
 */
@property(nonatomic,strong)UITableView * cityTable;
/**
 *  @author cao, 15-10-27 10:10:10
 *
 *  地区容器
 */
@property(nonatomic,strong)UIView * locationContainer;
/**
 *  @author cao, 15-10-28 17:10:56
 *
 *  搜索结果collectionView
 */
@property(nonatomic,strong)UICollectionView * searchCollectionView;
/**
 *  @author cao, 15-11-13 15:11:02
 *
 *  收礼人数据
 */
@property(nonatomic,strong)NSArray * tmpArray;

@end

@implementation AW_SearchReaultController


#pragma mark - Private Menthod

-(NSArray*)tmpArray{
    if (!_tmpArray) {
        _tmpArray = @[
                      @{@"收礼人":@[@"民间特色",@"送师长",@"送爱人",@"送朋友",@"商务礼物",@"小礼品",@"送小孩",@"纯手工",]},
                      ];
    }
    return _tmpArray;
}

-(AW_SearchResultDataSource*)searchDataSource{
    if (!_searchDataSource) {
        _searchDataSource = [[AW_SearchResultDataSource alloc]initWithDidSelectObjectBlock:^(NSInteger index, id obj) {
            
        }];
    }
    return _searchDataSource;
}

-(UICollectionView*)searchCollectionView{
    if (!_searchCollectionView) {
        WaterFLayout * flayout = [[WaterFLayout alloc]init];
        _searchCollectionView = [[UICollectionView alloc]initWithFrame:Rect(0, 40, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAV_BAR_HEIGHT - 40) collectionViewLayout:flayout];
        _searchCollectionView.backgroundColor = [UIColor clearColor];
        _searchCollectionView.userInteractionEnabled = YES;
        _searchCollectionView.alwaysBounceVertical = YES;
        
        UINib *cellNib = [UINib nibWithNibName:@"AW_ProduceCollectionCell" bundle:nil];
        [_searchCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"keySearchCell"];
        _searchCollectionView.dataSource = self.searchDataSource;
        _searchCollectionView.delegate = self.searchDataSource;
        self.searchDataSource.collectionView = _searchCollectionView;
        self.searchDataSource.hasRefreshHeader = YES;
        self.searchDataSource.hasLoadMoreFooter = YES;
        
    }
    return _searchCollectionView;
}


#pragma mark - LifeCycleMenthod
- (void)viewDidLoad {
    [super viewDidLoad];
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"艺术品列表";
    [self.view addSubview:self.searchCollectionView];
    [self addBackgroundView];
    [self addContainView];
    [self addLocationContainView];
    [self.view addSubview:self.intelligenceTable];
    [self addSearchTopView];
    //点击cell的回调
    __weak typeof(self) weakSelf = self;
    self.searchDataSource.didClickCell = ^(AW_MarketModal * modal){
        AW_ArtDetailController * detailController = [[AW_ArtDetailController alloc]init];
        detailController.hidesBottomBarWhenPushed = YES;
        weakSelf.navigationController.navigationBar.hidden = YES;
        //将艺术品id传到艺术品详情界面
        detailController.detailDataSource.commidity_id = modal.commidityModal.commodity_Id;
        detailController.detailDataSource.isCollection = modal.commidityModal.isCollected;
        [weakSelf.navigationController pushViewController: detailController animated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - InitArray Menthod

-(NSMutableArray*)ProvinceArray{
    if (!_ProvinceArray) {
        _ProvinceArray = [[NSMutableArray alloc]init];
    }
    return _ProvinceArray;
}

-(NSMutableArray*)cityArray{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc]init];
    }
    return _cityArray;
}

-(NSArray*)iconArray{
    if (!_iconArray) {
        _iconArray = @[@"市集-分类-分类图标",@"市集-分类-材料图标",@"市集-分类-用途图标",@"市集-分类-品牌图标",@"市集-分类-特色图标",@"市集-分类-节日图标",@"市集-分类-材料图标",@"市集-分类-用途图标",@"市集-分类-品牌图标",@"市集-分类-特色图标",@"市集-分类-节日图标",@"市集-分类-材料图标",@"市集-分类-用途图标",@"市集-分类-品牌图标",@"市集-分类-特色图标",@"市集-分类-节日图标"];
    }
    return _iconArray;
}
-(NSMutableArray*)bigClassArray{
    if (!_bigClassArray) {
        _bigClassArray = [[NSMutableArray alloc]init];
    }
    return _bigClassArray;
}

-(NSMutableArray*)smallClassArray{
    if (!_smallClassArray) {
        _smallClassArray = [[NSMutableArray alloc]init];
    }
    return _smallClassArray;
}

-(NSMutableArray*)intelligenceArray{
    if (!_intelligenceArray) {
        _intelligenceArray = [[NSMutableArray alloc]init];
        NSArray * array = @[@"按价格由低到高",@"按价格由高到低",@"按销量排序",@"按人气排序"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * string = obj;
            AW_IntelligenceModal * modal = [[AW_IntelligenceModal alloc]init];
            modal.Intelligence_Id = [NSString stringWithFormat:@"%ld",idx];
            modal.Intelligence_name = string;
            [_intelligenceArray addObject:modal];
        }];
    }
    return _intelligenceArray;
}

#pragma mark - ConfigView Menthod

-(AW_SearchView*)searchView{
    if (!_searchView) {
        _searchView = BundleToObj(@"AW_SearchView");
    }
    return _searchView;
}

-(UIView*)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
    }
    return _containerView;
}

-(UIView*)locationContainer{
    if (!_locationContainer) {
        _locationContainer = [[UIView alloc]init];
    }
    return _locationContainer;
}

-(UIControl*)backgroungView{
    if (!_backgroungView) {
        _backgroungView = [[UIControl alloc]init];
        _backgroungView.backgroundColor = [UIColor blackColor];
        _backgroungView.alpha = 0.4;
        _backgroungView.hidden = YES;
    }
    return _backgroungView;
}

-(UITableView*)firstLevelTable{
    if (!_firstLevelTable) {
        _firstLevelTable = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH/2 - 20, 350)];
        _firstLevelTable.delegate = self;
        _firstLevelTable.dataSource = self;
        _firstLevelTable.tableFooterView = [[UIView alloc]init];
    }
    return _firstLevelTable;
}

-(UITableView*)secondLevelTable{
    if (!_secondLevelTable) {
        _secondLevelTable = [[UITableView alloc]initWithFrame:Rect(kSCREEN_WIDTH/2 - 20, 0, kSCREEN_WIDTH/2 + 20, 350)];
        _secondLevelTable.delegate = self;
        _secondLevelTable.dataSource = self;
        _secondLevelTable.tableFooterView = [[UIView alloc]init];
    }
    return _secondLevelTable;
}

-(UITableView*)ProvinceTable{
    if (!_ProvinceTable) {
        _ProvinceTable = [[UITableView alloc]initWithFrame:Rect(0, 0, kSCREEN_WIDTH/2 - 20, 350)];
        _ProvinceTable.delegate = self;
        _ProvinceTable.dataSource = self;
        _ProvinceTable.tableFooterView = [[UIView alloc]init];
    }
    return _ProvinceTable;
}

-(UITableView*)cityTable{
    if (!_cityTable) {
        _cityTable = [[UITableView alloc]initWithFrame:Rect(kSCREEN_WIDTH/2 - 20, 0, kSCREEN_WIDTH/2 + 20 , 350)];
        _cityTable.delegate = self;
        _cityTable.dataSource = self;
        _cityTable.tableFooterView = [[UIView alloc]init];
    }
    return _cityTable;
}

-(UITableView*)intelligenceTable{
    if (!_intelligenceTable) {
        _intelligenceTable = [[UITableView alloc]initWithFrame:Rect(0, 40 - 140, kSCREEN_WIDTH, 140)];
        _intelligenceTable.delegate = self;
        _intelligenceTable.dataSource = self;
        _intelligenceTable.tableFooterView = [[UIView alloc]init];
    }
    return _intelligenceTable;
}

#pragma mark - AddView Menthod

-(void)addBackgroundView{
    [self.view addSubview:self.backgroungView];
    [self.backgroungView addTarget:self action:@selector(touchBackgroundView) forControlEvents:UIControlEventTouchUpInside];
    self.backgroungView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroungView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
      [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroungView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
      [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroungView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
      [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroungView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
}

-(void)addSearchTopView{
    [self.view addSubview:self.searchView];
    self.searchView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
     [self.searchView addConstraint:[NSLayoutConstraint constraintWithItem:self.searchView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    //点击头部搜索按钮的回调
    __weak typeof(self) weakSelf = self;
    self.searchView.didClickedBtn = ^(NSInteger index){
        if (index == 1) {
            if (weakSelf.containerView.frame.origin.y < 0) {
                //隐藏其他两个视图
                if (weakSelf.locationContainer.frame.origin.y > 0){
                    weakSelf.searchView.locationBtn.selected = NO;
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.locationContainer.frame = Rect(0, 40-350, kSCREEN_WIDTH, 350);
                    } completion:^(BOOL finished) {
                       
                    }];
                }
                if (weakSelf.intelligenceTable.frame.origin.y > 0){
                    weakSelf.searchView.IntelligenceBtn.selected = NO;
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.intelligenceTable.frame = Rect(0, 40 - 140, kSCREEN_WIDTH, 140);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
                //执行动画
                weakSelf.backgroungView.hidden = NO;
                weakSelf.backgroungView.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.backgroungView.alpha = 0.4;
                    weakSelf.containerView.frame = Rect(0, 40
, kSCREEN_WIDTH, 350);
                }];
                //在这进行请求(大分类)
                NSDictionary * dict = @{};
                NSError * error = nil;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary * bigClass = @{@"param":@"getBigType",@"jsonParam":string};
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:ARTSCOME_INT parameters:bigClass success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSLog(@"响应信息:===%@",responseObject);
                    if ([responseObject[@"code"]intValue] == 0) {
                        //先将大分类数组的数据清空
                        if (weakSelf.bigClassArray.count > 0) {
                            [weakSelf.bigClassArray removeAllObjects];
                        }
                        //为大分类modal赋值
                        AW_BigClassModal * modal = [[AW_BigClassModal alloc]init];
                        modal.big_name = @"全部分类";
                        modal.tmpImage = weakSelf.iconArray[0];
                        [weakSelf.bigClassArray addObject:modal];
                        
                        NSArray * arr = responseObject[@"info"];
                        [responseObject[@"info"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict = obj;
                            AW_BigClassModal * bigModal = [[AW_BigClassModal alloc]init];
                            bigModal.bid_id = dict[@"id"];
                            bigModal.big_name = dict[@"name"];
                            bigModal.bid_image = dict[@"img"];
                            bigModal.tmpImage = weakSelf.iconArray[idx + 1];
                            [weakSelf.bigClassArray addObject:bigModal];
                        }];
                        
                        //插入默认收礼人modal
                        [weakSelf.tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * tmpDict = obj;
                            AW_BigClassModal * receiveModal = [[AW_BigClassModal alloc]init];
                            receiveModal.big_name = [tmpDict allKeys][0];
                            receiveModal.tmpImage = weakSelf.iconArray[arr.count + 1];
                            [weakSelf.bigClassArray addObject:receiveModal];
                        }];
                        //插入原创modal
                        AW_BigClassModal * originalityModal = [[AW_BigClassModal alloc]init];
                        originalityModal.big_name = @"原创";
                        originalityModal.tmpImage = weakSelf.iconArray[arr.count + 2];
                        [weakSelf.bigClassArray addObject:originalityModal];
                        //刷新大分类数据
                        [weakSelf.firstLevelTable reloadData];
                    }
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    NSLog(@"错误信息:%@",[error localizedDescription]);
                }];
            }else if (weakSelf.containerView.frame.origin.y > 0){
                weakSelf.searchView.locationBtn.enabled = YES;
                weakSelf.searchView.IntelligenceBtn.enabled = YES;
                 [UIView animateWithDuration:0.3 animations:^{
                     weakSelf.backgroungView.alpha = 0;
                     weakSelf.containerView.frame = Rect(0, 40 - 350, kSCREEN_WIDTH, 350);
                 } completion:^(BOOL finished) {
                     weakSelf.backgroungView.hidden = YES;
                 }];
            }
        }else if (index == 2){
            if (weakSelf.locationContainer.frame.origin.y < 0) {
                //隐藏其他两个视图
                if (weakSelf.containerView.frame.origin.y > 0){
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.searchView.allBtn.selected = NO;
                        weakSelf.containerView.frame = Rect(0, 40 - 350, kSCREEN_WIDTH, 350);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if (weakSelf.intelligenceTable.frame.origin.y > 0){
                    weakSelf.searchView.IntelligenceBtn.selected = NO;
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.intelligenceTable.frame = Rect(0, 40 - 140, kSCREEN_WIDTH, 140);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
                weakSelf.searchView.locationBtn.selected = YES;
                weakSelf.backgroungView.hidden = NO;
                weakSelf.backgroungView.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.backgroungView.alpha = 0.4;
                    weakSelf.locationContainer.frame = Rect(0, 40, kSCREEN_WIDTH, 350);
                }];
                //进行省份请求(先将省份数组清空)
                if (weakSelf.ProvinceArray.count > 0) {
                    [weakSelf.ProvinceArray removeAllObjects];
                }
                NSDictionary * dict = @{};
                NSError *error = nil;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary * provinceDict = @{@"param":@"getProvince",@"jsonParam":string};
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:ARTSCOME_INT parameters:provinceDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSLog(@"%@",responseObject);
                    if ([responseObject[@"code"]integerValue] == 0) {
                        //添加全国分类
                        AW_ProvinceModal * modal = [[AW_ProvinceModal alloc]init];
                        modal.Province_name = @"全国";
                        [weakSelf.ProvinceArray addObject:modal];
                        //插入其他省份
                        [responseObject[@"info"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary * dict = obj;
                            AW_ProvinceModal *modal = [[AW_ProvinceModal alloc]init];
                            modal.Province_id = dict[@"id"];
                            modal.Province_name = dict[@"name"];
                            //modal.hasCity = [dict[@"pid"]boolValue];
                            [weakSelf.ProvinceArray addObject:modal];
                        }];
                        [weakSelf.ProvinceTable reloadData];
                    }
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    NSLog(@"错误信息：%@",[error localizedDescription]);
                }];
            }else if (weakSelf.locationContainer.frame.origin.y > 0){
                weakSelf.searchView.locationBtn.selected = NO;
                weakSelf.searchView.allBtn.enabled = YES;
                weakSelf.searchView.IntelligenceBtn.enabled = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.backgroungView.alpha = 0;
                    weakSelf.locationContainer.frame = Rect(0, 40-350, kSCREEN_WIDTH, 350);
                } completion:^(BOOL finished) {
                    weakSelf.backgroungView.hidden = YES;
                }];
            }
            
        }else if (index == 3){
            //加载智能排序数据
            if (weakSelf.intelligenceTable.frame.origin.y < 0) {
                //隐藏其他两个视图
                if (weakSelf.containerView.frame.origin.y > 0){
                    weakSelf.searchView.allBtn.selected = NO;
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.containerView.frame = Rect(0, 40 - 350, kSCREEN_WIDTH, 350);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if (weakSelf.locationContainer.frame.origin.y > 0){
                    weakSelf.searchView.locationBtn.selected = NO;
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.locationContainer.frame = Rect(0, 40-350, kSCREEN_WIDTH, 350);
                    } completion:^(BOOL finished) {
                       
                    }];
                }
                weakSelf.backgroungView.hidden = NO;
                weakSelf.backgroungView.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.backgroungView.alpha = 0.4;
                    weakSelf.intelligenceTable.frame = Rect(0, 40, kSCREEN_WIDTH, 140);
                }];
                [weakSelf.intelligenceTable reloadData];
            }else if (weakSelf.intelligenceTable.frame.origin.y > 0){
                weakSelf.searchView.allBtn.enabled = YES;
                weakSelf.searchView.locationBtn.enabled = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.backgroungView.alpha = 0;
                    weakSelf.intelligenceTable.frame = Rect(0, 40 - 140, kSCREEN_WIDTH, 140);
                } completion:^(BOOL finished) {
                    weakSelf.backgroungView.hidden = YES;
                }];
            }
        }
    };
}

-(void)addContainView{
    [self.view addSubview:self.containerView];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:40 - 350]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:350]];
    //添加分类列表
    [self.containerView addSubview:self.firstLevelTable];
    [self.containerView addSubview:self.secondLevelTable];
}

-(void)addLocationContainView{
    [self.view addSubview:self.locationContainer];
    self.locationContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.locationContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:40 - 350]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.locationContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.locationContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.locationContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.locationContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:350]];
    //添加城市列表
    [self.locationContainer addSubview:self.ProvinceTable];
    [self.locationContainer addSubview:self.cityTable];
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchBackgroundView{
 [UIView animateWithDuration:0.3 animations:^{
     self.backgroungView.alpha = 0;
     self.containerView.frame = Rect(0, 40-350, kSCREEN_WIDTH, 350);
     self.intelligenceTable.frame = Rect(0, 40-140, kSCREEN_WIDTH, 140);
     self.locationContainer.frame = Rect(0, 40 - 350, kSCREEN_WIDTH, 350);
 } completion:^(BOOL finished) {
     self.backgroungView.hidden = YES;
     self.searchView.allBtn.selected = NO;
     self.searchView.locationBtn.selected = NO;
     self.searchView.IntelligenceBtn.selected = NO;
     self.searchView.allBtn.enabled = YES;
     self.searchView.locationBtn.enabled = YES;
     self.searchView.IntelligenceBtn.enabled = YES;
 }];

}

#pragma mark - UITbableDataSource Menthod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.firstLevelTable) {
        return self.bigClassArray.count;
    }else if (tableView == self.secondLevelTable){
        return self.smallClassArray.count;
    }else if(tableView == self.intelligenceTable){
        return self.intelligenceArray.count;
    }else if (tableView == self.ProvinceTable){
        return self.ProvinceArray.count;
    }else if (tableView == self.cityTable){
        return self.cityArray.count;
    }else{
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.firstLevelTable) {
        AW_BigClassModal * modal = self.bigClassArray[indexPath.row];
        static NSString * CellId = @"bigCell";
        AW_BigClassCell * bigCell = [tableView dequeueReusableCellWithIdentifier:CellId];
        if (!bigCell) {
            bigCell = BundleToObj(@"AW_BigClassCell");
        }
        //[bigCell.bigClassImage sd_setImageWithURL:[NSURL URLWithString:modal.bid_image]];
        bigCell.bigClassImage.image = [UIImage imageNamed:modal.tmpImage];
        bigCell.bigClassLabel.text = modal.big_name;
        UIView * backView = [[UIView alloc]init];
        backView.backgroundColor = HexRGB(0xe6e6e6);
        bigCell.selectedBackgroundView = backView;
        return bigCell;
    }else if (tableView == self.secondLevelTable){
        AW_SmallClassModal * modal = self.smallClassArray[indexPath.row];
        static NSString * cellId = @"smallCell";
        AW_SmallClassCell * smallCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!smallCell) {
            smallCell = BundleToObj(@"AW_SmallClassCell");
        }
        smallCell.smallClassLabel.text = modal.small_name;
        UIView * backView = [[UIView alloc]init];
        backView.backgroundColor = HexRGB(0xe6e6e6);
        smallCell.selectedBackgroundView = backView;
        return smallCell;
    }else if (tableView == self.intelligenceTable){
       static NSString * cellId = @"smartCell";
        AW_IntelligenceModal * modal = self.intelligenceArray[indexPath.row];
        AW_IntelligenceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = BundleToObj(@"AW_IntelligenceCell");
            UIView * backView = [[UIView alloc]init];
            backView.backgroundColor = HexRGB(0xe6e6e6);
            cell.selectedBackgroundView = backView;
        }
        cell.intelligenceLabel.text = modal.Intelligence_name;
        return cell;
    }else if (tableView == self.ProvinceTable){
        AW_ProvinceModal *modal = self.ProvinceArray[indexPath.row];
        static NSString * cellId = @"provinceCell";
        AW_ProvinceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = BundleToObj(@"AW_ProvinceCell");
            UIView * backView = [[UIView alloc]init];
            backView.backgroundColor = HexRGB(0xe6e6e6);
            cell.selectedBackgroundView = backView;
        }
        cell.provinceLabel.text = modal.Province_name;
        return cell;
    }else if (tableView == self.cityTable){
        AW_CityModal * modal = self.cityArray[indexPath.row];
        static NSString * cellId = @"ciryCell";
        AW_CityCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = BundleToObj(@"AW_CityCell");
            UIView * backView = [[UIView alloc]init];
            backView.backgroundColor = HexRGB(0xe6e6e6);
            cell.selectedBackgroundView = backView;
        }
        cell.cityLabel.text = modal.city_name;
        return cell;
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDelegate Menthod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.firstLevelTable) {
        return 40;
    }else if (tableView == self.secondLevelTable){
        return 35;
    }else if (tableView == self.intelligenceTable){
        return 35;
    }else if (tableView == self.ProvinceTable){
        return 40;
    }else if (tableView == self.cityTable){
        return 35;
    } else{
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (tableView == self.firstLevelTable) {
        AW_BigClassModal * tmpModal = self.bigClassArray[indexPath.row];
        NSLog(@"%@",tmpModal.bid_id);
        if (!tmpModal.bid_id) {
            if (indexPath.row == 0) {
                NSLog(@"点击了全部分类。。。。");
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.backgroungView.alpha = 0;
                    weakSelf.containerView.frame = Rect(0, 40-350, kSCREEN_WIDTH, 350);
                } completion:^(BOOL finished) {
                    weakSelf.backgroungView.hidden = YES;
                    weakSelf.searchView.allBtn.selected = NO;
                    weakSelf.searchView.locationBtn.enabled = YES;
                    weakSelf.searchView.IntelligenceBtn.enabled = YES;
                    [self.searchView.allBtn setTitle:@"全部分类" forState:UIControlStateNormal];
                    //进行全部分类请求
                    if (weakSelf.searchDataSource.dataArr.count > 0) {
                        [weakSelf.searchDataSource.dataArr removeAllObjects];
                    }
                    weakSelf.searchDataSource.class_id = @"";
                    weakSelf.searchDataSource.keyString = @"";
                    self.searchDataSource.currentPage = @"1";
                    [weakSelf.searchDataSource getTestData];
                }];
            }else if([tmpModal.big_name isEqualToString:@"原创"]){
                NSLog(@"点击了原创按钮");
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.backgroungView.alpha = 0;
                    weakSelf.containerView.frame = Rect(0, 40-350, kSCREEN_WIDTH, 350);
                } completion:^(BOOL finished) {
                    weakSelf.backgroungView.hidden = YES;
                    weakSelf.searchView.allBtn.selected = NO;
                    weakSelf.searchView.locationBtn.enabled = YES;
                    weakSelf.searchView.IntelligenceBtn.enabled = YES;
                    [self.searchView.allBtn setTitle:@"原创" forState:UIControlStateNormal];
                    //进行原创作品请求
                    if (weakSelf.searchDataSource.dataArr.count > 0) {
                        [weakSelf.searchDataSource.dataArr removeAllObjects];
                    }
                    weakSelf.searchDataSource.labelString = @"原创";
                    weakSelf.searchDataSource.class_id = @"";
                    weakSelf.searchDataSource.keyString = @"";
                    [weakSelf.searchDataSource getTestData];
                    
                }];
            
            }else{
                NSLog(@"点击了收礼人按钮");
                //先将小分类数组的数据清空
                if (self.smallClassArray.count > 0) {
                    [self.smallClassArray removeAllObjects];
                }
                NSDictionary * smallDict = self.tmpArray[0];
                NSArray * tmpArray = [smallDict valueForKey:@"收礼人"];
                [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString * str = obj;
                    AW_SmallClassModal * smallModal = [[AW_SmallClassModal alloc]init];
                    smallModal.small_name = str;
                    [self.smallClassArray addObject:smallModal];
                }];
                //刷新小分类数据
                [self.secondLevelTable reloadData];
            }
        
        }else{
            //进行小分类请求(点击大分类触发)
            NSError * error = nil;
            AW_BigClassModal * modal = self.bigClassArray[indexPath.row];
            NSDictionary * dict = @{@"id":modal.bid_id};
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * smallDict = @{@"param":@"getSmallType",@"jsonParam":string};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:smallDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]integerValue] == 0) {
                    //先将小分类数组的数据清空
                    if (self.smallClassArray.count > 0) {
                        [self.smallClassArray removeAllObjects];
                    }
                    //为小分类modal赋值
                    [responseObject[@"info"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary * dict = obj;
                        AW_SmallClassModal * smallModal = [[AW_SmallClassModal alloc]init];
                        smallModal.small_id = dict[@"id"];
                        smallModal.small_name = dict[@"name"];
                        [self.smallClassArray addObject:smallModal];
                    }];
                    //刷新小分类数据
                    [self.secondLevelTable reloadData];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息:%@",[error localizedDescription]);
            }];
        }
    }else if (tableView == self.secondLevelTable){
        AW_SmallClassModal * modal = self.smallClassArray[indexPath.row];
        NSLog(@"小分类id:==%@==",modal.small_id);
        if (modal.small_id) {
            //动画隐藏视图
            [UIView animateWithDuration:0.3 animations:^{
                self.backgroungView.alpha = 0;
                self.containerView.frame = Rect(0, 40 - 350, kSCREEN_WIDTH, 350);
            } completion:^(BOOL finished) {
                self.backgroungView.hidden = YES;
                //为button赋值
                [self.searchView.allBtn setTitle:modal.small_name forState:UIControlStateNormal];
                self.searchView.allBtn.selected = NO;
                self.searchView.locationBtn.enabled = YES;
                self.searchView.IntelligenceBtn.enabled = YES;
                //进行小分类数据请求 （刷新collectionView）
                weakSelf.searchDataSource.class_id = modal.small_id;
                if (weakSelf.searchDataSource.dataArr.count > 0) {
                    [weakSelf.searchDataSource.dataArr removeAllObjects];
                }
                weakSelf.searchDataSource.keyString = @"";
                weakSelf.searchDataSource.labelString = @"";
                [weakSelf.searchDataSource getTestData];
                
            }];
        }else{
          //在这进行收礼人请求
            [UIView animateWithDuration:0.3 animations:^{
                self.backgroungView.alpha = 0;
                self.containerView.frame = Rect(0, 40 - 350, kSCREEN_WIDTH, 350);
            } completion:^(BOOL finished) {
                self.backgroungView.hidden = YES;
                //为button赋值
                [self.searchView.allBtn setTitle:modal.small_name forState:UIControlStateNormal];
                self.searchView.allBtn.selected = NO;
                self.searchView.locationBtn.enabled = YES;
                self.searchView.IntelligenceBtn.enabled = YES;
                //进行小分类数据请求 （刷新collectionView）
                weakSelf.searchDataSource.labelString = modal.small_name;
                if (weakSelf.searchDataSource.dataArr.count > 0) {
                    [weakSelf.searchDataSource.dataArr removeAllObjects];
                }
                weakSelf.searchDataSource.keyString = @"";
                weakSelf.searchDataSource.class_id = @"";
                [weakSelf.searchDataSource getTestData];
                
            }];
        
        }
    }else if (tableView == self.intelligenceTable){
        AW_IntelligenceModal *modal = self.intelligenceArray[indexPath.row];
        NSLog(@"智能排序id:===%@==",modal.Intelligence_Id);
        //动画隐藏
       [UIView animateWithDuration:0.3 animations:^{
           self.backgroungView.alpha = 0;
           self.intelligenceTable.frame = Rect(0, 40-140, kSCREEN_WIDTH, 140);
       } completion:^(BOOL finished) {
           self.backgroungView.hidden = YES;
           self.searchView.IntelligenceBtn.selected = NO;
           [self.searchView.IntelligenceBtn setTitle:modal.Intelligence_name forState:UIControlStateNormal];
           weakSelf.searchView.locationBtn.enabled = YES;
           weakSelf.searchView.allBtn.enabled = YES;
           
           //进行智能排序请求
           if (weakSelf.searchDataSource.dataArr.count > 0) {
               [weakSelf.searchDataSource.dataArr removeAllObjects];
           }
           weakSelf.searchDataSource.sortString = modal.Intelligence_Id;
           [weakSelf.searchDataSource getTestData];
       }];
    }else if (tableView == self.ProvinceTable){
        if (indexPath.row == 0) {
            NSLog(@"点击了全国分类。。。");
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.backgroungView.alpha = 0;
                weakSelf.locationContainer.frame = Rect(0, 40-350, kSCREEN_WIDTH, 350);
            } completion:^(BOOL finished) {
                weakSelf.backgroungView.hidden = YES;
                weakSelf.searchView.locationBtn.selected = NO;
                weakSelf.searchView.allBtn.enabled = YES;
                weakSelf.searchView.IntelligenceBtn.enabled = YES;
                [self.searchView.locationBtn setTitle:@"全国" forState:UIControlStateNormal];
                //进行全国分类请求
                if (weakSelf.searchDataSource.dataArr.count > 0) {
                    [weakSelf.searchDataSource.dataArr removeAllObjects];
                }
                weakSelf.searchDataSource.locationName = @"全国";
                [weakSelf.searchDataSource getTestData];
            }];
        }else{
            AW_ProvinceModal * modal = self.ProvinceArray[indexPath.row];
            NSLog(@"%@",modal.Province_name);
            
            //记录省份名称
            self.provinceString = modal.Province_name;
            self.province_id = modal.Province_id;
            //省份下面有城市时才进行请求
            NSDictionary * dict = @{@"id":modal.Province_id};
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary * cityDict = @{@"param":@"getCity",@"jsonParam":string};
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            [manager POST:ARTSCOME_INT parameters:cityDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"]intValue] == 0) {
                    //先将分类数组的数据清空
                    if (self.cityArray.count > 0) {
                        [self.cityArray removeAllObjects];
                    }
                    //将省份加入modal
                    AW_CityModal * modal = [[AW_CityModal alloc]init];
                    modal.city_id = self.province_id;
                    modal.city_name = self.provinceString;
                    [weakSelf.cityArray addObject:modal];
                    
                    //城市请求成功就将城市数据存入modal
                    [responseObject[@"info"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary * cityDict = obj;
                        AW_CityModal * modal = [[AW_CityModal alloc]init];
                        modal.city_id = cityDict[@"id"];
                        modal.city_name = cityDict[@"name"];
                        [weakSelf.cityArray addObject:modal];
                    }];
                    [self.cityTable reloadData];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"错误信息：%@",[error localizedDescription]);
            }];

        }
        
    }else if (tableView == self.cityTable){
        AW_CityModal * modal = self.cityArray[indexPath.row];
        NSLog(@"城市名称：==%@==",modal.city_name);
        //将视图隐藏
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.backgroungView.alpha = 0;
            weakSelf.locationContainer.frame = Rect(0, 40 - 350, kSCREEN_WIDTH, 350);
        } completion:^(BOOL finished) {
            weakSelf.backgroungView.hidden = YES;
            weakSelf.searchView.allBtn.enabled = YES;
            weakSelf.searchView.IntelligenceBtn.enabled = YES;
            weakSelf.searchView.locationBtn.selected = NO;
            [self.searchView.locationBtn setTitle:modal.city_name forState:UIControlStateNormal];
            //进行城市分类请求
            if (weakSelf.searchDataSource.dataArr.count > 0) {
                [weakSelf.searchDataSource.dataArr removeAllObjects];
            }
            if (indexPath.row == 0) {
                NSString * str = [modal.city_name substringToIndex:modal.city_name.length - 1];
                weakSelf.searchDataSource.locationName = str;
                [weakSelf.searchDataSource getTestData];
            }else{
                weakSelf.searchDataSource.locationName = modal.city_name;
                [weakSelf.searchDataSource getTestData];
            }
        }];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
