//
//  FRDPersonalBioTableController.m
//  Frndr
//
//  Created by Pavlo on 9/21/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPersonalBioTableController.h"

#import "FRDPersonalBioTableHeader.h"

#import "UIResponder+FirstResponder.h"

static NSString * const kThingsILoveSectionName = @"The things I love most...";
static NSString * const kPersonalBioSectionName = @"My Personal Bio";

typedef NS_ENUM(NSInteger, FRDPersonalBioSectionType)
{
    FRDPersonalBioSectionTypeThingsILove,
    FRDPersonalBioSectionTypeBio
};

@interface FRDPersonalBioTableController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstThingILoveTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondThingILoveTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdThingILoveTextField;
@property (weak, nonatomic) IBOutlet UITextField *fourthThingILoveTextField;
@property (weak, nonatomic) IBOutlet UITextField *fifthThingILoveTextField;
@property (weak, nonatomic) IBOutlet UITextView *personalBioThingILoveTextView;

@end

@implementation FRDPersonalBioTableController

#pragma mark - View's Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerHeader];
}

/**
 * Not calling [super viewWillApper:] to disable autoscrolling when keyboard appears
 */
- (void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark - Actions

- (void)registerHeader
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([FRDPersonalBioTableHeader class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([FRDPersonalBioTableHeader class])];
}

- (void)dismissKeyboard
{
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.firstThingILoveTextField isFirstResponder]) {
        [self.secondThingILoveTextField becomeFirstResponder];
    } else if ([self.secondThingILoveTextField isFirstResponder]) {
        [self.thirdThingILoveTextField becomeFirstResponder];
    } else if ([self.thirdThingILoveTextField isFirstResponder]) {
        [self.fourthThingILoveTextField becomeFirstResponder];
    } else if ([self.fourthThingILoveTextField isFirstResponder]) {
        [self.fifthThingILoveTextField becomeFirstResponder];
    } else if ([self.fifthThingILoveTextField isFirstResponder]) {
        [self.personalBioThingILoveTextView becomeFirstResponder];
    }
    return YES;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FRDPersonalBioTableHeader *header = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FRDPersonalBioTableHeader class])];
    
    FRDPersonalBioSectionType sectionType = section;
    
    switch (sectionType) {
        case FRDPersonalBioSectionTypeThingsILove: {
            header.label.text = LOCALIZED(kThingsILoveSectionName);
            break;
        }
         
        case FRDPersonalBioSectionTypeBio: {
            header.label.text = LOCALIZED(kPersonalBioSectionName);
            break;
        }
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    static FRDPersonalBioTableHeader *header;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        header = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FRDPersonalBioTableHeader class])];
    });
    NSLog(@"Header height: %f", header.frame.size.height);
    return CGRectGetHeight(header.frame);
}

@end
