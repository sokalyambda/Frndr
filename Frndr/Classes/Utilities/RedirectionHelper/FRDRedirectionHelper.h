//
//  FRDRedirectionHelper.h
//  Frndr
//
//  Created by Eugenity on 24.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDProjectFacade.h"

@class FRDBaseNavigationController, FRDBaseViewController, FRDFriend;
@protocol ContainerViewControllerDelegate;

@interface FRDRedirectionHelper : NSObject

+ (void)redirectToMainContainerControllerWithNavigationController:(FRDBaseNavigationController *)navigationController andDelegate:(id<ContainerViewControllerDelegate>)delegate;
+ (void)redirectToTermsAndServicesWithURL:(NSURL *)url andPresentingController:(FRDBaseViewController *)presentingController;

+ (void)redirectToChatWithFriend:(FRDFriend *)currentFriend
                       onSuccess:(SuccessBlock)success
                       onFailure:(FailureBlock)failure;

@end
