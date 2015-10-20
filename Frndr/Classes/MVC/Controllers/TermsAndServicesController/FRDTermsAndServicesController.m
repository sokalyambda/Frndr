//
//  FRDTermsAndServicesController.m
//  Frndr
//
//  Created by Eugenity on 11.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDTermsAndServicesController.h"

#import "FRDSerialViewConstructor.h"

@interface FRDTermsAndServicesController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation FRDTermsAndServicesController

#pragma mark - Accessors



#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTextViewInformation];
}

#pragma mark - Actions

- (void)loadTextViewInformation
{
    NSString *path = [[NSBundle mainBundle] pathForResource:self.sourceTextPath ofType:nil];
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
    } else {
        self.textView.text = content;
    }
}

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    self.navigationTitleView.titleText = LOCALIZED(self.titleText);
    //show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //set right bar button item
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    //remove back button (custom and system)
    UIBarButtonItem *leftIconImageButton = [FRDSerialViewConstructor customRightBarButtonForController:self withAction:nil];
    self.navigationItem.leftBarButtonItem = leftIconImageButton;
}

- (IBAction)doneClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIStatusBar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
