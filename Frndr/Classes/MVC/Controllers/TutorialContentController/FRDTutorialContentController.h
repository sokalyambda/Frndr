//
//  FRDTutorialContentController.h
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseViewController.h"

@interface FRDTutorialContentController : FRDBaseViewController

// Item controller information
@property (nonatomic) NSUInteger itemIndex;
@property (strong, nonatomic) NSString *imageName;

// IBOutlets
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end
