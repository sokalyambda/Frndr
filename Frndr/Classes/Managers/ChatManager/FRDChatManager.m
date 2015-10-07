//
//  FRDChatManager.m
//  Frndr
//
//  Created by Eugenity on 06.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatManager.h"
#import "Frndr-Swift.h"

//static NSString *const kBaseHostURL = @"http://192.168.88.161:8859";//Misha
//static NSString *const kBaseHostURL = @"http://192.168.88.47:8859";//Vanya
static NSString *const kBaseHostURL = @"http://projects.thinkmobiles.com:8859";//Live

static NSString *const kConnectedToServerEvent = @"connectedToServer";
static NSString *const kAuthorizeEvent = @"authorize";
static NSString *const kChatMessageEvent = @"chat message";

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        //Has to be performed once
        [self connectToHostAndListenEvents];
    }
    return self;
}

#pragma mark - Actions

- (void)connectToHostAndListenEvents
{
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
    
    [self.socketIOClient on:kChatMessageEvent callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nullable emitter) {
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
    [self.socketIOClient disconnect];
}

@end
