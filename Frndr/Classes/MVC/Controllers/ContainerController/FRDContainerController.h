//
//  FRDContainerController.h
//  Frndr
//
//  Created by Eugenity on 21.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSUInteger, FRDPresentedControllerType) {
    FRDPresentedControllerTypeNext,
    FRDPresentedControllerTypePrevious
};

@protocol ContainerViewControllerDelegate;
@class FRDBaseContentController;

/** A very simple container view controller for demonstrating containment in an environment different from UINavigationController and UITabBarController.
 @discussion This class implements support for non-interactive custom view controller transitions.
 @note One of the many current limitations, besides not supporting interactive transitions, is that you cannot change view controllers after the object has been initialized.
 */
@interface FRDContainerViewController : UIViewController

/// The container view controller delegate receiving the protocol callbacks.
@property (nonatomic, weak) id<ContainerViewControllerDelegate>delegate;

/// The view controllers currently managed by the container view controller.
@property (nonatomic, copy) NSArray *viewControllers;

/// The currently selected and visible child view controller.
@property (nonatomic, assign) FRDBaseContentController *selectedViewController;

/** Designated initializer.
 @note The view controllers array cannot be changed after initialization.
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

/**
 *  Manipulate with child controllers
 *
 *  @param presentedType show next or previous controller
 */
- (void)showNextPreviousController:(FRDPresentedControllerType)presentedType;

@end

@protocol ContainerViewControllerDelegate <NSObject>
@optional
/** Informs the delegate that the user selected view controller by tapping the corresponding icon.
 @note The method is called regardless of whether the selected view controller changed or not and only as a result of the user tapped a button. The method is not called when the view controller is changed programmatically. This is the same pattern as UITabBarController uses.
 */
- (void)containerViewController:(FRDContainerViewController *)containerViewController didSelectViewController:(FRDBaseContentController *)viewController;

/// Called on the delegate to obtain a UIViewControllerAnimatedTransitioning object which can be used to animate a non-interactive transition.
- (id <UIViewControllerAnimatedTransitioning>)containerViewController:(FRDContainerViewController *)containerViewController animationControllerForTransitionFromViewController:(FRDBaseContentController *)fromViewController toViewController:(FRDBaseContentController *)toViewController;

@end
