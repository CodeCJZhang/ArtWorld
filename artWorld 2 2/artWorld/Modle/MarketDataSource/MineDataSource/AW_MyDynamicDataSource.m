//
//  AW_MyDynamicDataSource.m
//  artWorld
//
//  Created by 曹学亮 on 15/8/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_MyDynamicDataSource.h"
#import "AW_MicroBlogListModal.h"//我的动态模型
#import "AW_MyDynamicTableHeadView.h"//我的动态tableView头视图
#import "AW_MyDynamicblogCell.h"
#import "AFNetworking.h"

@interface AW_MyDynamicDataSource()
/**
 *  @author cao, 15-08-20 21:08:07
 *
 *  tableView头视图
 */
@property(nonatomic,strong)AW_MyDynamicTableHeadView * headView;

/**
 *  @author cao, 15-09-21 22:09:50
 *
 *  计算高度的cell
 */
@property(nonatomic,strong)AW_MyDynamicblogCell * myBlogCell;
/**
 *  @author cao, 15-10-27 15:10:55
 *
 *  记录总页数
 */
@property(nonatomic,copy)NSString * totolPage;
/**
 *  @author cao, 15-10-27 15:10:08
 *
 *  当前的页数
 */
@property(nonatomic,copy)NSString * currentPage;
/**
 *  @author cao, 15-11-12 21:11:20
 *
 *  他的动态头视图
 */
@property(nonatomic,strong)AW_MyDynamicTableHeadView * otherHeadView;
@end

@implementation AW_MyDynamicDataSource

#pragma mark - Private Menthod
-(NSArray*)photosArray{
    if (!_photosArray) {
        _photosArray = [[NSArray alloc]init];
    }
    return _photosArray;
}

-(AW_MyDynamicTableHeadView*)headView{
    if (!_headView) {
        _headView = BundleToObj(@"AW_MyDynamicTableHeadView");
    }
    return _headView;
}

-(AW_MyDynamicTableHeadView*)otherHeadView{
    if (!_otherHeadView) {
        _otherHeadView = [[NSBundle mainBundle]loadNibNamed:@"AW_MyDynamicTableHeadView" owner:self options:nil][1];
    }
    return _otherHeadView;
}

-(AW_MyDynamicblogCell*)myBlogCell{
    if (!_myBlogCell) {
        _myBlogCell = BundleToObj(@"AW_MyDynamicblogCell");
    }
    return _myBlogCell;
}

#pragma mark - GetData Menthod
-(void)getTextData{
    
    //在这进行请求
    /*NSLog(@"%@",self.person_id);
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSDictionary * dict = @{@"personId":self.person_id,
                            @"userId":user_id,
                            @"pageSize":@"10",
                            @"pageNumber":self.currentPage,
                            };
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * dynamicDict = @{@"":@"",@"":@""};*/
    
    
    
NSArray * textArray = @[
                        @{
                       @"totalNumber":@"10",
                       @"data":@[
                            @{
                            @"id":@"001",
                            @"nickname":@"许京甫",
                            @"head_img":@"http://sc.jb51.net/uploads/allimg/140603/11-1406031H254507.jpg",
                            @"isVerified":@"NO",
                            @"signature":@"xxxxx",
                            @"content":@"艺天下是一个专注于工艺美术&原创产品设计传播平台",
                            //@"clear_img":@"",
                            @"fuzzy_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                            @"create_time":@"09-17 12:34",
                            //@"location":@"",
                            @"isPraised":@"NO",
                            },
                            @{
                                @"id":@"002",
                                @"nickname":@"李白",
                                @"head_img":@"http://f6.topit.me/6/60/f0/1115146453853f0606o.jpg",
                                @"isVerified":@"YES",
                                @"signature":@"xxxxx",
                                @"content":@"艺天下是一个专注于工艺美术&原创产品设计传播平台 匠人的手非常神奇，从中可以揉捏造就出来很多东西。",
                                @"clear_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                                @"fuzzy_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                                @"create_time":@"05-13 12:32",
                               // @"location":@"",
                                @"isPraised":@"NO",
                                },
                            @{
                                @"id":@"003",
                                @"nickname":@"杜甫",
                                @"head_img":@"http://pic23.nipic.com/20120825/4430093_180436515192_2.jpg",
                                @"isVerified":@"YES",
                                @"signature":@"xxxxx",
                                @"content":@"",
                                @"clear_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjq6ecfuj20c806o3zx.jpg",
                                @"fuzzy_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                                @"create_time":@"05-13 12:32",
                                @"location":@"河北石家庄",
                                @"isPraised":@"YES",
                                },
                            @{
                                @"id":@"004",
                                @"nickname":@"王安石",
                                @"head_img":@"http://v1.qzone.cc/avatar/201406/26/21/56/53ac26802ad64395.png!200x200.jpg",
                                @"isVerified":@"YES",
                                @"signature":@"xxxxx",
                                @"content":@"艺天下是一个专注于工艺美术&原创产品设计传播平台 匠人的手非常神奇，从中可以揉捏造就出来很多东西，经过了手的抚摸，竟然让人觉得那些器物似乎有了生命。",
                                @"clear_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjq6ecfuj20c806o3zx.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjpxgfpkj20c805j3zf.jpg",
                                @"fuzzy_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                                @"create_time":@"05-13 12:32",
                                @"location":@"北京",
                                @"isPraised":@"YES",
                                },
                            @{
                                @"id":@"005",
                                @"nickname":@"鲁迅",
                                @"head_img":@"http://aliimg.changba.com/cache/photo/222124363_640_640.jpg",
                                @"isVerified":@"NO",
                                @"signature":@"xxxxx",
                                //@"content":@"",
                                @"clear_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjq6ecfuj20c806o3zx.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjpxgfpkj20c805j3zf.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjq52bovj20c806mmy3.jpg",
                                @"fuzzy_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                                @"create_time":@"05-13 12:32",
                                //@"location":@"",
                                @"isPraised":@"NO",
                                },
                            @{
                                @"id":@"006",
                                @"nickname":@"马云",
                                @"head_img":@"http://f.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=6890a1ac22a446237e9fad66ad125e38/4afbfbedab64034f7d4219d0adc379310b551d5c.jpg",
                                @"isVerified":@"YES",
                                @"signature":@"xxxxx",
                                @"content":@"艺天下是一个专注于工艺美术&原创产品设计传播平台 匠人的手非常神奇，从中可以揉捏造就出来很多东西，经过了手的抚摸，竟然让人觉得那些器物似乎有了生命。之所以透过作品可以看见匠人的心，是因为他们在造物的过程中，手的每一个举措都承载着自己的虔诚",
                                @"clear_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjq6ecfuj20c806o3zx.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjpxgfpkj20c805j3zf.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjq52bovj20c806mmy3.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjqaxl7oj20c806nq46.jpg",
                                @"fuzzy_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                                @"create_time":@"05-13 12:32",
                                @"location":@"杭州",
                                @"isPraised":@"NO",
                                },
                            @{
                                @"id":@"007",
                                @"nickname":@"淘宝",
                                @"head_img":@"http://i-7.vcimg.com/trim/402f36dd913bce4c85ec24a89c096a4545853/trim.jpg",
                                @"isVerified":@"YES",
                                @"signature":@"xxxxx",
                               // @"content":@"",
                                @"clear_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjq6ecfuj20c806o3zx.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjpxgfpkj20c805j3zf.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjq52bovj20c806mmy3.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjqaxl7oj20c806nq46.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjpy8tj5j20c8067ab1.jpg",
                                @"fuzzy_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                                @"create_time":@"05-13 12:32",
                                @"location":@"帝都",
                                @"isPraised":@"YES",
                                },
                            @{
                                @"id":@"008",
                                @"nickname":@"京东",
                                @"head_img":@"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=350fd3e53a12b31bc739c52db3281a4c/3ac79f3df8dcd100fc23b783718b4710b8122fd0.jpg",
                                @"isVerified":@"YES",
                                @"signature":@"xxxxx",
                                @"content":@"艺天下是一个专注于工艺美术&原创产品设计传播平台匠人的手非常神奇，从中可以揉捏造就出来很多东西，经过了手的抚摸，竟然让人觉得那些器物似乎有了生命。之所以透过作品可以看见匠人的心，是因为他们在造物的过程中，手的每一个举措都承载着自己的虔诚。以虔诚的心打造出来的物件，必定也能打动世人。",
                                @"clear_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjq6ecfuj20c806o3zx.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjpxgfpkj20c805j3zf.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjq52bovj20c806mmy3.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjqaxl7oj20c806nq46.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjpy8tj5j20c8067ab1.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjpz9l2oj20c806j0tk.jpg",
                                @"fuzzy_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                                @"create_time":@"05-13 12:32",
                               // @"location":@"",
                                @"isPraised":@"NO",
                                },
                            @{
                                @"id":@"009",
                                @"nickname":@"美团",
                                @"head_img":@"http://7xavvq.com2.z0.glb.qiniucdn.com/11/MjAxMjA3MDYwMDEwMzdfMTI1LjEyNy4xMjcuNV8yNDY3Nzg=.jpg!700",
                                @"isVerified":@"YES",
                                @"signature":@"xxxxx",
                                @"content":@"匠人的手非常神奇，从中可以揉捏造就出来很多东西，经过了手的抚摸，竟然让人觉得那些器物似乎有了生命。之所以透过作品可以看见匠人的心，是因为他们在造物的过程中，手的每一个举措都承载着自己的虔诚。以虔诚的心打造出来的物件，必定也能打动世人。",
                                @"clear_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjq6ecfuj20c806o3zx.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjpxgfpkj20c805j3zf.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjq52bovj20c806mmy3.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjqaxl7oj20c806nq46.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjpy8tj5j20c8067ab1.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjpz9l2oj20c806j0tk.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjq1apq1j20c8069wfv.jpg",
                                @"fuzzy_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                                @"create_time":@"05-13 12:32",
                                @"location":@"帝都",
                                @"isPraised":@"NO",
                                },
                            @{
                                @"id":@"010",
                                @"nickname":@"百度外卖",
                                @"head_img":@"http://www.itouxiang.net/uploads/allimg/140430/1_140430083805_2.jpg",
                                @"isVerified":@"NO",
                                @"signature":@"xxxxx",
                                @"content":@"匠人的手非常神奇，从中可以揉捏造就出来很多东西，经过了手的抚摸，竟然让人觉得那些器物似乎有了生命。之所以透过作品可以看见匠人的心.匠人的手非常神奇，从中可以揉捏造就出来很多东西，经过了手的抚摸，竟然让人觉得那些器物似乎有了生命。之所以透过作品可以看见匠人的心。匠人的手非常神奇，从中可以揉捏造就出来很多东西，经过了手的抚摸，竟然让人觉得那些器物似乎有了生命。之所以透过作品可以看见匠人的心。",
                                @"clear_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjq6ecfuj20c806o3zx.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjpxgfpkj20c805j3zf.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjq52bovj20c806mmy3.jpg,http://ww1.sinaimg.cn/bmiddle/806bc807gw1ewmjqaxl7oj20c806nq46.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjpy8tj5j20c8067ab1.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjpz9l2oj20c806j0tk.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjq1apq1j20c8069wfv.jpg,http://ww3.sinaimg.cn/bmiddle/806bc807gw1ewmjpzxsk4j20c806nq3q.jpg",
                                @"fuzzy_img":@"http://ww2.sinaimg.cn/bmiddle/806bc807gw1ewmjq0nw0sj20c808dgn4.jpg",
                                @"create_time":@"05-13 12:32",
                                @"location":@"河北保定",
                                @"isPraised":@"YES",
                                },
                               ],
    
                            },
                    ];
    __weak typeof(self) weakSelf = self;
     [textArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             NSDictionary * dict = obj;
             AW_MicroBlogListModal * modal = [[AW_MicroBlogListModal alloc]init];
             modal.totalNumber = dict[@"totalNumber"];
             NSArray * microBlogArray = dict[@"data"];
             [microBlogArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 NSDictionary * blogDict = obj;
                 //插入分割线
                 AW_MicroBlogListModal * separateModal = [[AW_MicroBlogListModal alloc]init];
                 separateModal.isSeparator = YES;
                 separateModal.rowHeight = kMarginBetweenCompontents;
                 [weakSelf.dataArr addObject:separateModal];
                 //插入微博数据
                 AW_MicroBlogListModal * blogModal = [[AW_MicroBlogListModal alloc]init];
                 AW_UserModal * userModal = [[AW_UserModal alloc]init];
                 blogModal.userModal = userModal;
                 userModal.nickname = blogDict[@"nickname"];
                 userModal.head_img = blogDict[@"head_img"];
                 userModal.isVerified = [blogDict[@"isVerified"]boolValue];
                 userModal.signature = blogDict[@"signature"];
                 blogModal.microBlog_id = blogDict[@"id"];
                 blogModal.microBlog_Content = blogDict[@"content"];
                 blogModal.create_time = blogDict[@"create_time"];
                 blogModal.fuzzy_img = blogDict[@"fuzzy_img"];
                 blogModal.location = blogDict[@"location"];
                 if (blogDict[@"location"]) {
                     blogModal.hasAdress = YES;
                 }
                 blogModal.isPraised = [blogDict[@"isPraised"]boolValue];
                 NSArray * stringArray = [blogDict[@"clear_img"] componentsSeparatedByString:@","];
                 NSLog(@"==%@==",stringArray);
                 NSMutableArray * pictureArray = [NSMutableArray array];
                 if (stringArray.count > 0) {
                     [stringArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         NSString *string = obj;
                         [pictureArray addObject:string];
                     }];
                 }
                 blogModal.imageArray = pictureArray;
                 blogModal.rowHeight = [weakSelf perpareModal:blogModal];
                 [weakSelf.dataArr addObject:blogModal];
             }];
     }];
    [self dataDidLoad];
}

#pragma mark - UITableViewDelegate Menthod

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AW_MicroBlogListModal * modal = self.dataArr[indexPath.row];
    return modal.rowHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    if ([user_id intValue] == [self.person_id intValue]) {
        self.tableView.tableHeaderView = self.headView;
    }else{
        self.tableView.tableHeaderView = self.otherHeadView;
    }   
    AW_MicroBlogListModal * modal = self.dataArr[indexPath.row];
    if (modal.isSeparator) {
        static NSString * cellId = @"isSeparate";
        UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
      static NSString * cellId = @"myDynamicCell";
        AW_MyDynamicblogCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = BundleToObj(@"AW_MyDynamicblogCell");
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell hasText:modal.microBlog_Content ImageArray:modal.imageArray showAdress:modal.hasAdress];
        [cell configDataWithDynamicModal:modal];
        
        //点击图片按钮的回调
        __weak typeof(cell) weakCell = cell;
        cell.didClickedImageBtns = ^(NSInteger index){
            UIView * v = [weakCell.ImageViewArray[index - 101] superview];
            AW_MyDynamicblogCell * tmpCell  = (AW_MyDynamicblogCell*)[v superview];
            NSIndexPath * path = [tableView indexPathForCell:tmpCell];
            AW_MicroBlogListModal * tmpModal = self.dataArr[path.row];
            NSString * imageURLString = tmpModal.imageArray[index-101];
            NSLog(@"姓名：====%@===图片地址:===%@====,第几张图片==%ld===",tmpModal.userModal.nickname,imageURLString,index - 101);
            //将图片数据传到controller中
            if (_didClickedImageBtn) {
                self.photosArray = [tmpModal.imageArray copy];
                _imageIndex = index - 101;
                _didClickedImageBtn(self.photosArray,_imageIndex);
            }
        };
        //点击按钮后的回调
        cell.didClickedBtns = ^(NSInteger index){
            AW_MicroBlogListModal * selectModal;
            if (index == 1) {
                UIView * v = [weakCell.transmitBtn superview];
                UIView * v1 = [v superview];
                UIView * v2 = [v1 superview];
                AW_MyDynamicblogCell * cell = (AW_MyDynamicblogCell*)[v2 superview];
                NSIndexPath * path = [tableView indexPathForCell:cell];
                selectModal = self.dataArr[path.row];
            }else if (index == 2){
                UIView * v = [weakCell.commentBtn superview];
                UIView * v1 = [v superview];
                UIView * v2 = [v1 superview];
                AW_MyDynamicblogCell * cell = (AW_MyDynamicblogCell*)[v2 superview];
                NSIndexPath * path = [tableView indexPathForCell:cell];
                selectModal = self.dataArr[path.row];
            }else if (index == 3){
                UIView * v = [weakCell.praiseBtn superview];
                UIView * v1 = [v superview];
                UIView * v2 = [v1 superview];
                AW_MyDynamicblogCell * cell = (AW_MyDynamicblogCell*)[v2 superview];
                NSIndexPath * path = [tableView indexPathForCell:cell];
                selectModal = self.dataArr[path.row];
            }
            //将要转发,评论,赞的人的modal传到controller中
            if (_didClickedBottomBtns) {
                _didClickedBottomBtns(index,selectModal);
            }
        };
        return cell;
    }
}
/**
 *  @author cao, 15-08-16 13:08:29
 *
 *  计算单元格高度
 *
 *  @param modal 我的动态模型
 *
 *  @return 单元格高度
 */
#warning 文字高度计算未解决
-(float)perpareModal:(AW_MicroBlogListModal*)modal{
    
    self.myBlogCell.blogContent.preferredMaxLayoutWidth = kSCREEN_WIDTH - 16;
    self.myBlogCell.blogContent.text = modal.microBlog_Content;
    NSLog(@"微博内容:====%@===",modal.microBlog_Content);
    [self.myBlogCell hasText:modal.microBlog_Content ImageArray:modal.imageArray showAdress:modal.location];
    [self.myBlogCell layoutIfNeeded];
    [self.myBlogCell.contentView layoutIfNeeded];
    [self.myBlogCell.blogContent sizeToFit];
    
    //计算文字高度
    NSMutableParagraphStyle * paragrafStyle = [[NSMutableParagraphStyle alloc]init];
    paragrafStyle.lineBreakMode = NSLineBreakByWordWrapping;
    self.myBlogCell.blogContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.myBlogCell.blogContent.numberOfLines = 0;
    NSDictionary * fontAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    //使用字体大小来计算每一行的高度，每一行片段的起点，而不是base line的起点
    CGSize blogLabelSize = [modal.microBlog_Content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 16, CGFLOAT_MAX) options:
                            NSStringDrawingUsesLineFragmentOrigin |
                            NSStringDrawingUsesFontLeading attributes:fontAttributes context:nil].size;
    //计算图片高度
    float currentImageHeight = 0;
    if (modal.imageArray.count >= 1 && modal.imageArray.count<= 3) {
        currentImageHeight = (kSCREEN_WIDTH - 40)/3;
    }else if(modal.imageArray.count >=4 && modal.imageArray.count <=6){
        currentImageHeight = ((kSCREEN_WIDTH - 40)/3)*2 + 8;
    }else if(modal.imageArray.count >=7 && modal.imageArray.count <= 9){
        currentImageHeight = ((kSCREEN_WIDTH - 40)/3)*3 + 16;
    }
    NSLog(@"文本高度===%f===",blogLabelSize.height);
    NSLog(@"图片高度===%f===",currentImageHeight);
    if (modal.microBlog_Content.length == 0) {
        if (modal.imageArray.count > 0) {
            if (modal.hasAdress == YES) {
                return 128 + currentImageHeight;
            }else if (modal.hasAdress == NO){
                return 103 + currentImageHeight;
            }else{
                return 0;
            }
        }else {
            if (modal.hasAdress == YES) {
                return 115;
            }else if (modal.hasAdress == NO){
                return 95;
            }else{
                return 0;
            }
        }
    }else {
        if (modal.imageArray.count > 0) {
            if (modal.hasAdress == YES) {
                return 136 + blogLabelSize.height + currentImageHeight + 8;
            }else if (modal.hasAdress == NO){
                return 111 + blogLabelSize.height + currentImageHeight + 8;
            }else{
                return 0;
            }
        }else {
            if (modal.hasAdress == YES) {
                return 128 + blogLabelSize.height + 8;
            }else if (modal.hasAdress == NO){
                return 103 + blogLabelSize.height + 8;
            }else{
                return 0;
            }
        }
    }
}

//释放资源
-(void)releaseResources{
    [super releaseResources];
    _myBlogCell = nil;
}

//下拉刷新
-(void)refreshData{
    [self getTextData];
}

//上提分页
-(void)nextPageData{
   // [self getTextData];
}

@end
