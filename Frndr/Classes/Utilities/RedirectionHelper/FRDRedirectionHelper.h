//
//  FRDRedirectionHelper.h
//  Frndr
//
//  Created by Eugenity on 24.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@class FRDBaseNavigationController;
@protocol ContainerViewControllerDelegate;

@interface FRDRedirectionHelper : NSObject

+ (void)redirectToMainContainerControllerWithNavigationController:(FRDBaseNavigationController *)navigationController andDelegate:(id<ContainerViewControllerDelegate>)delegate;

@end
