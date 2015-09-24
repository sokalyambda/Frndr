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

#import "FRDAnimator.h"

static NSString *const kMainStoryboardName = @"Main";

@interface FRDRedirectionHelper ()

@end

@implementation FRDRedirectionHelper

+ (void)redirectToMainContainerControllerWithNavigationController:(FRDBaseNavigationController *)navigationController andDelegate:(id<ContainerViewControllerDelegate>)delegate
{
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:kMainStoryboardName bundle:nil];
    
    FRDPreferencesController *preferencesController = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDPreferencesController class])];
    FRDFriendsListController *friendsListController = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDFriendsListController class])];
    FRDSearchFriendsController *searchFriendsController = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDSearchFriendsController class])];
    FRDContainerViewController *container = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDContainerViewController class])];
    container.delegate = delegate;
    container.viewControllers = @[preferencesController, searchFriendsController, friendsListController];
    
    [navigationController pushViewController:container animated:YES];
}

@end
