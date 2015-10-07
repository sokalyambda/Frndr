//
//  FRDChatMessage.h
//  Frndr
//
//  Created by Eugenity on 07.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSUInteger, FRDMessageOwnerType) {
    FRDMessageOwnerTypeUser,
    FRDMessageOwnerTypeFriend,
    FRDMessageOwnerTypeSystem,
};

#import "FRDMappingProtocol.h"

@interface FRDChatMessage : NSObject<FRDMappingProtocol>

@property (strong, nonatomic) NSString *messageId;
@property (strong, nonatomic) NSString *ownerId;
@property (strong, nonatomic) NSString *companionId;
@property (strong, nonatomic) NSString *messageBody;
@property (strong, nonatomic) NSDate *creationDate;

@property (assign, nonatomic) FRDMessageOwnerType ownerType;

@end
