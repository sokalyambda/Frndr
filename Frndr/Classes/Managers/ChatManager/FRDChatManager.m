//
//  FRDChatManager.m
//  Frndr
//
//  Created by Eugenity on 06.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatManager.h"
#import "Frndr-Swift.h"

#import "FRDChatMessage.h"

#import "FRDFacebookService.h"

//static NSString *const kBaseHostURL = @"http://192.168.88.161:8859";//Misha
//static NSString *const kBaseHostURL = @"http://192.168.88.47:8859";//Vanya
static NSString *const kBaseHostURL = @"http://projects.thinkmobiles.com:8859";//Live

static NSString *const kConnectedToServerEvent = @"connectedToServer";
static NSString *const kAuthorizeEvent = @"authorize";
static NSString *const kChatMessageEvent = @"chat message";
static NSString *const kLogoutEvent = @"logout";

static NSString *const kSuccess = @"success";

@interface FRDChatManager ()

@property (strong, nonatomic) SocketIOClient *socketIOClient;

@end

@implementation FRDChatManager

#pragma mark - Lifecycle

+ (FRDChatManager *)sharedChatManager
{
    static FRDChatManager *chatManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatManager = [[self alloc] init];
    });
    
    return chatManager;
}

//+ (FRDChatManager *)sharedChatManager
//{
//    @synchronized (_chatManager) {
//        if (!_chatManager)
//            _chatManager = [[self alloc] init];
//    }
//    return _chatManager;
//}
//
//+ (void)releaseChatManager
//{
//    @synchronized (_chatManager) {
//        if (_chatManager)
//            _chatManager = nil;
//    }
//}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        if ([FRDFacebookService isFacebookSessionValid]) {
//            //Has to be performed once
//            [self connectToHostAndListenEvents];
//        }
//    }
//    return self;
//}

#pragma mark - Actions

- (void)connectToHostAndListenEvents
{
    if (![FRDFacebookService isFacebookSessionValid]) {
        return;
    }
    
    self.socketIOClient = nil;
    
    NSLog(@"self.socketIOClient %@", self.socketIOClient);
    
    NSString *userId = [FRDStorageManager sharedStorage].currentUserProfile.userId;
    //Init socket client
    self.socketIOClient = [[SocketIOClient alloc] initWithSocketURL:kBaseHostURL opts:nil];
    
    //Connect to server
    [self.socketIOClient connect];
    
    //Listen to 'connectedToServer' event
    WEAK_SELF;
    [self.socketIOClient on:kConnectedToServerEvent callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nullable emitter) {
        NSDictionary *dataDict = data.firstObject;
        if ([dataDict[kSuccess] boolValue]) {
            [weakSelf.socketIOClient emit:kAuthorizeEvent withItems:@[userId]];
        }
    }];
    
    //Listen to new message event
    [self.socketIOClient on:kChatMessageEvent callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nullable emitter) {
        
        NSDictionary *messageDict = data.firstObject;
        FRDChatMessage *message = [[FRDChatMessage alloc] initWithSocketRespose:messageDict];
        
        //post notification with new message
        [[NSNotificationCenter defaultCenter] postNotificationName:DidReceiveNewMessageNotification object:message];
        
        NSLog(@"data %@", data);
    }];
    
    /*
     Response general structure
     {
     ownerId: userId,
     friendId: friendId,
     message: msg
     }
     */
}

/**
 *  Close the channel
 */
- (void)closeChannel
{
    
    if (![FRDFacebookService isFacebookSessionValid]) {
        return;
    }
    
    [self.socketIOClient disconnect];
    
    self.socketIOClient = nil;
//    [[self class] releaseChatManager];
}

@end
