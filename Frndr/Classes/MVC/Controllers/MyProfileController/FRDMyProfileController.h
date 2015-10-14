//
//  FRDMyProfileController.h
//  Frndr
//
//  Created by Pavlo on 9/21/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDKeyboardResponderController.h"

@class FRDFriend;

@interface FRDMyProfileController : FRDKeyboardResponderController

@property (strong, nonatomic) FRDFriend *currentFriend;

@end
