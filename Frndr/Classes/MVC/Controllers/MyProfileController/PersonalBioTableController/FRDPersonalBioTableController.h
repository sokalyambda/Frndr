//
//  FRDPersonalBioTableController.h
//  Frndr
//
//  Created by Pavlo on 9/21/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@interface FRDPersonalBioTableController : UITableViewController

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *mostLovedThingsFields;

@property (weak, nonatomic) IBOutlet UITextView *personalBioThingILoveTextView;

- (void)update;

@end
