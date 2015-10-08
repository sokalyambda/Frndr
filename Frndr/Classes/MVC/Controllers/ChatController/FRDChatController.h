//
//  FRDChatController.h
//  Frndr
//
//  Created by Pavlo on 10/5/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDKeyboardResponderController.h"

@class FRDFriend;

@interface FRDChatController : FRDKeyboardResponderController

@property (strong, nonatomic) FRDFriend *currentFriend;

@end
