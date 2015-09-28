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

@end

@implementation FRDPersonalBioTableController

#pragma mark - View's Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerHeader];
}

/**
 * Not calling [super viewWillAppear:] to disable autoscrolling when keyboard appears
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

#pragma mark - Public Methods

- (void)update
{
    FRDCurrentUserProfile *profile = [FRDStorageManager sharedStorage].currentUserProfile;
    self.personalBioThingILoveTextView.text = profile.biography;
    
    for (NSString *lovedThing in profile.thingsLovedMost) {
        int idx = [profile.thingsLovedMost indexOfObject:lovedThing];
        UITextField *currentField = self.mostLovedThingsFields[idx];
        currentField.text = lovedThing;
    }
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
        [self dismissKeyboard];
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
    return CGRectGetHeight(header.frame);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
