/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "EMChatManagerDefs.h"

@protocol ChatViewControllerDelegate <NSObject>

- (NSString *)avatarWithChatter:(NSString *)chatter;
- (NSString *)nickNameWithChatter:(NSString *)chatter;

@end

@interface ChatViewController : UIViewController
/**
 *  @author cao, 15-11-19 11:11:49
 *
 *  用来接上个界面传过来的环信id
 */
@property(nonatomic,copy)NSString * shopIM_phone;
/**
 *  @author cao, 15-11-23 10:11:08
 *
 *  用来接上个界面传过来的店主id
 */
@property(nonatomic,copy)NSString * shoper_id;
/**
 *  @author cao, 15-11-23 11:11:50
 *
 *  店铺id
 */
@property(nonatomic,copy)NSString * shop_id;

@property (strong, nonatomic, readonly) NSString *chatter;
@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (nonatomic) BOOL isInvisible;
@property (nonatomic, assign) id <ChatViewControllerDelegate> delelgate;
@property (strong, nonatomic) EMConversation *conversation;//会话管理者
- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type;

- (void)reloadData;

- (void)hideImagePicker;

#pragma mark - sendMessage
-(void)sendTextMessage:(NSString *)textMessage;
-(void)sendImageMessage:(UIImage *)image;
-(void)sendAudioMessage:(EMChatVoice *)voice;
-(void)sendVideoMessage:(EMChatVideo *)video;
-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address;
-(void)addMessage:(EMMessage *)message;
- (EMMessageType)messageType;
@end
