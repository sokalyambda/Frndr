//
//  FRDFriend.h
//  Frndr
//
//  Created by Eugenity on 17.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseUserModel.h"

@interface FRDFriend : FRDBaseUserModel

@property (assign, nonatomic, getter=isNewFriend) BOOL newFriend;
@property (strong, nonatomic) NSString *lastMessage;
@property (strong, nonatomic) NSDate *lastMessagePostedDate;

@end
