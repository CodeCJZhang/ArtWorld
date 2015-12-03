//
//  IMB_TableDataSource.m
//  GoComIM
//
//  Created by 闫建刚 on 14-9-22.
//  Copyright (c) 2014年 iMobile. All rights reserved.
//

#import "IMB_TableDataSource.h"

#import "IMB_Constants.h"


@implementation IMB_TableDataSource

@synthesize isNotFirstLoading = _isNotFirstLoading;
@synthesize isLoadingData = _isLoadingData;
@synthesize hasLoadMoreFooter = _hasLoadMoreFooter;
@synthesize hasRefreshHeader = _hasRefreshHeader;

-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(NSMutableArray*)payArr{
    if (!_payArr) {
        _payArr = [[NSMutableArray alloc]init];
    }
    return _payArr;
}
-(NSMutableArray*)sendArr{
    if (!_sendArr) {
        _sendArr = [[NSMutableArray alloc]init];
    }
    return _sendArr;
}
-(NSMutableArray*)receiveArr{
    if (!_receiveArr) {
        _receiveArr = [[NSMutableArray alloc]init];
    }
    return _receiveArr;
}
-(NSMutableArray*)evaluteArr{
    if (!_evaluteArr) {
        _evaluteArr = [[NSMutableArray alloc]init];
    }
    return _evaluteArr;
}
#pragma mark - Release method
- (void)dealloc{
    [self releaseResources];
    NSLog(@"%@ dealloc ...",NSStringFromClass([self class]));
}

#pragma mark - Life Cycle method

- (id)initWithDidSelectObjectBlock:(DidSelectObjectBlock)didSelectObjectBlock{
    if (self = [super init]) {
        self.didSelectObjectBlock = didSelectObjectBlock;
    }
    return self;
}

#pragma mark - Propery method

- (void)setHasRefreshHeader:(BOOL)hasRefreshHeader{
    if (_hasRefreshHeader != hasRefreshHeader) {
        _hasRefreshHeader = hasRefreshHeader;
        __block typeof(self) weakSelf = self;
        if (hasRefreshHeader) {
            [_tableView addHeaderWithCallback:^{
                // 判断是否正在上提分页加载数据
                if (!weakSelf.isLoadingData) {
                    weakSelf.tableView.footerHidden = YES;
                    [weakSelf refreshData];
                }else{
                    [_tableView headerEndRefreshing];
                }
            }];
            [_tableView headerBeginRefreshing];
        }
    }

}

- (void)setHasLoadMoreFooter:(BOOL)hasLoadMoreFooter{
    if (self.hasLoadMoreFooter != hasLoadMoreFooter) {
        _hasLoadMoreFooter = hasLoadMoreFooter;
        __block typeof(self) weakSelf = self;
        [_tableView addFooterWithCallback:^{
            if (_isNotFirstLoading) {
                [weakSelf nextPageData];
                _isLoadingData = YES;
            }
        }];
        if (_hasLoadMoreFooter) {

            [_tableView setFooterHidden:YES];
            [_tableView footerBeginRefreshing];
        }
    }
}

- (void)dataDidLoad{
    [_tableView reloadData];
    if (_hasRefreshHeader) {
        [_tableView headerEndRefreshing];
    }
    if (_hasLoadMoreFooter) {
        [_tableView footerEndRefreshing];
    #warning 暂时注释，将来放开（2015-01-04）
        /*if (self.dataArr.count <= [SIZE_OF_PAGE integerValue]) {
            [_tableView setFooterHidden:YES];
        }else{*/
            //[_tableView setFooterHidden:NO];
        //}
        self.isLoadingData = NO;
    }
    if (!_isNotFirstLoading) {
        _isNotFirstLoading = YES;
    }
} // 数据已经加载完毕


#pragma mark - Public method

- (void)refreshData{
    
} // 刷新数据

- (void)nextPageData{
    
} // 下一页数据

- (void)releaseResources{
    self.tableView = nil;
    _didSelectObjectBlock = nil;
    [_dataArr removeAllObjects];
    _dataArr = nil;
} // 释放资源

#pragma mark - UITableViewDataSource method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

#pragma mark - UITableViewDataSource method

static NSString *cellIdentifier = @"CellIdentifier";

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_didSelectObjectBlock) {
        if (self.dataArr.count > 0) {
            _didSelectObjectBlock(indexPath.row,self.dataArr[indexPath.row]);
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)pretreatWithHeight{
    
}

@end
