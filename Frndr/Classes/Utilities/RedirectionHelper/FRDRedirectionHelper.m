//
//  FRDRedirectionHelper.m
//  Frndr
//
//  Created by Eugenity on 24.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDRedirectionHelper.h"

#import "FRDContainerController.h"
#import "FRDSearchFriendsController.h"
#import "FRDPreferencesController.h"
#import "FRDFriendsListController.h"
#import "FRDBaseNavigationController.h"
#import "FRDTermsAndServicesController.h"
#import "FRDChatController.h"
#import "FRDGeolocationDeniedController.h"

#import "FRDAnimator.h"
#import "FRDFriend.h"

static NSString *const kMainStoryboardName = @"Main";

@implementation FRDRedirectionHelper

/**
 *  Redirect to main container view controller
 *
 *  @param navigationController Navigation controller which will be pushing the container controller
 *  @param delegate             Delegate for container controlelr
 */
+ (void)redirectToMainContainerControllerWithNavigationController:(FRDBaseNavigationController *)navigationController andDelegate:(id<ContainerViewControllerDelegate>)delegate
{
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:kMainStoryboardName bundle:nil];
    
    FRDPreferencesController *preferencesController = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDPreferencesController class])];
    preferencesController.transitionWithDamping = YES;
    
    FRDFriendsListController *friendsListController = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDFriendsListController class])];
    friendsListController.transitionWithDamping = YES;
    
    FRDSearchFriendsController *searchFriendsController = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDSearchFriendsController class])];
    searchFriendsController.transitionWithDamping = NO;
    
    FRDContainerViewController *container = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDContainerViewController class])];
    
    container.delegate = delegate;
    container.viewControllers = @[preferencesController, searchFriendsController, friendsListController];
    
    [navigationController pushViewController:container animated:YES];
}

/**
 *  Redirect to terms&services
 *
 *  @param uri                  Current URI (Universal Resource Identifier) for textView
 *  @param title                Title text
 *  @param presentingController Controller which will be presenting the terms controller
 */
+ (void)redirectToTermsAndServicesWithURI:(NSString *)uri title:(NSString *)title andPresentingController:(FRDBaseViewController *)presentingController
{
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:kMainStoryboardName bundle:nil];
    
    FRDTermsAndServicesController *controller = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDTermsAndServicesController class])];
    FRDBaseNavigationController *navigationController = [[FRDBaseNavigationController alloc] initWithRootViewController:controller];
    controller.sourceTextPath = uri;
    controller.titleText = title;
    
    [presentingController presentViewController:navigationController animated:YES completion:nil];
}

/**
 *  Redirect from push-notification
 *
 */
+ (void)redirectToChatWithFriend:(FRDFriend *)currentFriend
                       onSuccess:(SuccessBlock)success
                       onFailure:(FailureBlock)failure
{
    [FRDProjectFacade getFriendProfileWithFriendId:currentFriend.userId onSuccess:^(FRDFriend *currentFriend) {

        FRDBaseNavigationController *navigationController = (FRDBaseNavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        for (FRDBaseViewController *controller in navigationController.viewControllers) {
            if ([controller isKindOfClass:[FRDChatController class]]) {
                if (success) {
                    return success(YES);
                } else {
                    return;
                }
            }
        }
        
        if (navigationController.presentedViewController && ![navigationController.presentedViewController isKindOfClass:[FRDGeolocationDeniedController class]]) {
            [navigationController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        } else if ([navigationController.presentedViewController isKindOfClass:[FRDGeolocationDeniedController class]]) {
            return;
        }
        
        UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:kMainStoryboardName bundle:nil];

        FRDChatController *chatController = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDChatController class])];
        
        chatController.currentFriend = currentFriend;
        
        [navigationController pushViewController:chatController animated:YES];
        
        if (success) {
            return success(YES);
        } else {
            return;
        }

    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error, isCanceled);
        }
        
    }];
}

@end
