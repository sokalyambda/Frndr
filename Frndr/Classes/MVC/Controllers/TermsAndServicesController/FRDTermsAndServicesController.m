//
//  FRDTermsAndServicesController.m
//  Frndr
//
//  Created by Eugenity on 11.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDTermsAndServicesController.h"

@interface FRDTermsAndServicesController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation FRDTermsAndServicesController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateWebViewInformation];
}

#pragma mark - Actions

- (void)updateWebViewInformation
{
    NSURLRequest *currentRequest = [NSURLRequest requestWithURL:self.currentURL];
    [self.webView loadRequest:currentRequest];
}

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    self.navigationItem.title = LOCALIZED(@"Terms of Service");
    //show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //set right bar button item
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    //remove back button (custom and system)
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)doneClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [FRDAlertFacade showFailureResponseAlertWithError:error forController:self andCompletion:nil];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - UIStatusBar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
