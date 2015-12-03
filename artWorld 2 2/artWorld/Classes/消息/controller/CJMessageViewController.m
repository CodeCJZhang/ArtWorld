//
//  MessageViewController.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/8.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJMessageViewController.h"
#import "CJMarketMessageDataSource.h"
#import "CJGroupMessageDataSource.h"
#import "CJSystemMessageController.h"
#import "CJLogisticsHelperController.h"
#import "CJAssignMeController.h"
#import "CJCommentMessageController.h"
#import "CJPraiseController.h"
#import "CJForwardedMessageController.h"

#import "SRRefreshView.h"
#import "ChatListCell.h"
#import "EMSearchBar.h"
#import "NSDate+Category.h"
#import "RealtimeSearchUtil.h"
#import "ChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "RobotManager.h"
#import "UserProfileManager.h"
#import "RobotChatViewController.h"
#import "UserDataBaseHelper.h"
#import "UIImageView+WebCache.h"

#define w self.view.frame.size.width
#define h self.view.frame.size.height
#define padding 8



@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.conversationType == eConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:self.chatter]) {
            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.chatter];
        }
        return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.chatter];
    } //else if (self.conversationType == eConversationTypeGroupChat) {
    //        if ([self.ext objectForKey:@"groupSubject"] || [self.ext objectForKey:@"isPublic"]) {
    //           return [self.ext objectForKey:@"groupSubject"];
    //        }
    //    }
    return self.chatter;
}

@end

@interface CJMessageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, IChatManagerDelegate,ChatViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@property (nonatomic,strong) UIScrollView *messagescroll;

@property (nonatomic,strong) UITableView *marketView;

@property (nonatomic,strong) UITableView *squareView;

@property (nonatomic,strong) UIView *listView;


@property (nonatomic,strong) CJMarketMessageDataSource *marketDataSouce;

@property (nonatomic,strong) CJGroupMessageDataSource *squareDataSouce;


@property (strong, nonatomic) NSMutableArray        *dataSource;
@property (strong, nonatomic) UITableView           *tableView;
@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;
@property (strong, nonatomic) EMSearchDisplayController *searchController;

/**
 *  @author cao, 15-11-19 14:11:27
 *
 *  个人头像信息
 */
@property(nonatomic,strong)NSMutableDictionary * totalDictionary;
@end

@implementation CJMessageViewController

-(NSMutableDictionary*)totalDictionary{
    if (!_totalDictionary) {
        _totalDictionary = [NSMutableDictionary dictionary];
        UserDataBaseHelper * helper = [[UserDataBaseHelper alloc]init];
        _totalDictionary = [helper queryAllUserInfo];
    }
    return _totalDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self networkStateView];
    
    [self messageViewDesign];
    
    [self.listView addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView addSubview:self.slimeView];
    [self searchController];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshDataSource];
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}


#pragma mark - 数据源初始化

-(CJMarketMessageDataSource *)marketDataSouce
{
    if (!_marketDataSouce)
    {
        _marketDataSouce = [[CJMarketMessageDataSource alloc]init];
        _marketDataSouce.tableview = self.marketView;
        __block typeof (self)weakSelf = self;
        _marketDataSouce.toSystemMessage = ^(){
            CJSystemMessageController *smc = [[CJSystemMessageController alloc]init];
            smc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:smc animated:YES];
        };
        _marketDataSouce.toLogisticsHelper = ^(){
            CJLogisticsHelperController *lhc = [[CJLogisticsHelperController alloc]init];
            lhc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:lhc animated:YES];
        };
    }
    return _marketDataSouce;
}

-(CJGroupMessageDataSource *)squareDataSouce
{
    if (!_squareDataSouce)
    {
        _squareDataSouce = [[CJGroupMessageDataSource alloc]init];
        _squareDataSouce.tableview = self.squareView;
        __block typeof (self)weakSelf = self;
        _squareDataSouce.toAtMe = ^(){
            CJAssignMeController *amc = [[CJAssignMeController alloc]init];
            amc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:amc animated:YES];
        };
        _squareDataSouce.toCommentMessage = ^(){
            CJCommentMessageController *cmc = [[CJCommentMessageController alloc]init];
            cmc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:cmc animated:YES];
        };
        _squareDataSouce.toPraiseMe = ^(){
            CJPraiseController *pc = [[CJPraiseController alloc]init];
            pc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:pc animated:YES];
        };
        _squareDataSouce.toForward = ^(){
            CJForwardedMessageController *fmc = [[CJForwardedMessageController alloc]init];
            fmc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:fmc animated:YES];
        };
    }
    return _squareDataSouce;
}


#pragma mark - 消息的界面配置

- (void)messageViewDesign
{
    self.navigationController.navigationBar.translucent = NO;
    
    //配置UISegmentedControl开关
    [self.seg addTarget:self action:@selector(SegSelectedClick) forControlEvents:UIControlEventValueChanged];
    
    //配置scrollview
    _messagescroll = [[UIScrollView alloc]init];
    _messagescroll.contentSize = CGSizeMake(3 * w, 0);
    _messagescroll.showsHorizontalScrollIndicator = NO;
    _messagescroll.pagingEnabled = YES;
    _messagescroll.bounces = NO;
    _messagescroll.delegate = self;
    _messagescroll.frame = CGRectMake(0, 0, w, h -  49 - 64);
    [self.view addSubview:_messagescroll];
    
    //商城消息
    _marketView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, w, _messagescroll.frame.size.height)];
    [_marketView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _marketView.tableFooterView = [[UITableView alloc]init];
    _marketView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    _marketView.dataSource = self.marketDataSouce;
    _marketView.delegate = self.marketDataSouce;
    [_messagescroll addSubview:_marketView];
    
    //圈子消息
    _squareView = [[UITableView alloc]initWithFrame:CGRectMake(w, 0, w, _messagescroll.frame.size.height)];
    [_squareView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _squareView.tableFooterView = [[UITableView alloc]init];
    _squareView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    _squareView.dataSource = self.squareDataSouce;
    _squareView.delegate = self.squareDataSouce;
    [_messagescroll addSubview:_squareView];
    
    //即时通讯
    
    //    _listView.userInteractionEnabled = YES;
    //    _listView.backgroundColor = [UIColor greenColor];
    [_messagescroll addSubview:self.listView];
}


#pragma mark - UISegmentedControl点击事件方法

-(void)SegSelectedClick
{
    if (1 == self.seg.selectedSegmentIndex) {
        [self.messagescroll setContentOffset:CGPointMake(w, 0) animated:YES];
    }
    else if (2 == self.seg.selectedSegmentIndex)
    {
        [self.messagescroll setContentOffset:CGPointMake(w * 2, 0) animated:YES];
    }
    else
    {
        [self.messagescroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}


#pragma mark - 环信部分

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (UIView *)listView {
    if (!_listView) {
        _listView = [[UIView alloc]initWithFrame:CGRectMake(w * 2, 0, w, self.messagescroll.frame.size.height)];
        _listView.userInteractionEnabled = YES;
    }
    return _listView;
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

- (void)removeChatroomConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (conversation.conversationType == eConversationTypeChatRoom) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

//pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 113) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return _tableView;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak CJMessageViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ChatListCell";
            ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.name = conversation.chatter;
            if (conversation.conversationType == eConversationTypeChat) {
                cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
                cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
            }
            else{
                NSString *imageName = @"groupPublicHeader";
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:conversation.chatter]) {
                        cell.name = group.groupSubject;
                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                        break;
                    }
                }
                cell.placeholderImage = [UIImage imageNamed:imageName];
            }
            cell.detailMsg = [weakSelf subTitleMessageByConversation:conversation];
            cell.time = [weakSelf lastMessageTimeByConversation:conversation];
            cell.unreadCount = [weakSelf unreadMessageCountByConversation:conversation];
            if (indexPath.row % 2 == 1) {
                cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
            }else{
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            ChatViewController *chatController;
            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
                chatController = [[RobotChatViewController alloc] initWithChatter:conversation.chatter
                                                                 conversationType:conversation.conversationType];
                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
            }else {
                chatController = [[ChatViewController alloc] initWithChatter:conversation.chatter
                                                            conversationType:conversation.conversationType];
                chatController.title = [conversation showName];
            }
            [weakSelf.navigationController pushViewController:chatController animated:YES];
        }];
    }
    
    return _searchController;
}

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

//pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                if ([[RobotManager sharedInstance] isRobotMenuMessage:lastMessage]) {
                    ret = [[RobotManager sharedInstance] getRobotMenuMessageDigest:lastMessage];
                } else {
                    ret = didReceiveText;
                }
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    cell.name = conversation.chatter;
    if (conversation.conversationType == eConversationTypeChat) {
        cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
        //cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
        cell.imageURL = [self.totalDictionary valueForKey: conversation.chatter];
        NSLog(@"%@",[self.totalDictionary valueForKey: conversation.chatter]);
    }
    //设置聊天头像
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.totalDictionary valueForKey: conversation.chatter]]];
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
    if (indexPath.row % 2 == 1) {
        cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    ChatViewController *chatController;
    NSString *title = conversation.chatter;
    if (conversation.conversationType == eConversationTypeChat) {
        title = [[UserProfileManager sharedInstance] getNickNameWithUsername:conversation.chatter];
    }
    
    NSString *chatter = conversation.chatter;
    if ([[RobotManager sharedInstance] isRobotWithUsername:chatter]) {
        chatController = [[RobotChatViewController alloc] initWithChatter:chatter
                                                         conversationType:conversation.conversationType];
        chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:chatter];
    }else {
        chatController = [[ChatViewController alloc] initWithChatter:chatter
                                                    conversationType:conversation.conversationType];
        chatController.title = title;
    }
    
    chatController.delelgate = self;
    chatController.shopIM_phone = conversation.chatter;
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


//pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}


#pragma mark - UIScrollViewDelegate (环信)

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
    
    NSInteger page = _messagescroll.contentOffset.x / _messagescroll.frame.size.width;
    _seg.selectedSegmentIndex = page;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate (环信)
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    [_slimeView endRefresh];
}

#pragma mark - IChatMangerDelegate (环信)

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - registerNotifications (环信)
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - public (环信)

-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}

#pragma mark - ChatViewControllerDelegate (环信)

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
- (NSString *)avatarWithChatter:(NSString *)chatter{
    return [self.totalDictionary valueForKey:chatter];
}

// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    return chatter;
}

@end
