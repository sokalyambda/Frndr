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

#import "FRDAnimator.h"

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
    FRDFriendsListController *friendsListController = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDFriendsListController class])];
    FRDSearchFriendsController *searchFriendsController = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDSearchFriendsController class])];
    FRDContainerViewController *container = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDContainerViewController class])];
    
    searchFriendsController.updateNeeded = YES;
    
    container.delegate = delegate;
    container.viewControllers = @[preferencesController, searchFriendsController, friendsListController];
    
    [navigationController pushViewController:container animated:YES];
}

/**
 *  Redirect to terms&services
 *
 *  @param url                  Current URL for webView
 *  @param presentingController Controller which will be presenting the terms controller
 */
+ (void)redirectToTermsAndServicesWithURL:(NSURL *)url andPresentingController:(FRDBaseViewController *)presentingController
{
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:kMainStoryboardName bundle:nil];
    
    FRDTermsAndServicesController *controller = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDTermsAndServicesController class])];
    FRDBaseNavigationController *navigationController = [[FRDBaseNavigationController alloc] initWithRootViewController:controller];
    controller.currentURL = url;
    
    [presentingController presentViewController:navigationController animated:YES completion:nil];
    NSLog(@"url string %@", url.absoluteString);
}

@end
