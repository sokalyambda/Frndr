//
//  FRDTermsLabel.m
//  Frndr
//
//  Created by Eugenity on 10.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDTermsLabel.h"

@implementation FRDTermsLabel

- (void)setText:(id)text
{
    [super setText:text];
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:10.f],
                                 NSUnderlineStyleAttributeName: @0,
                                 NSForegroundColorAttributeName: [UIColor whiteColor]
                                 };
    self.linkAttributes = attributes;
    self.activeLinkAttributes = attributes;
    
    [self addLinkToURL:[NSURL URLWithString:@"http://PRIVACY_POLICY"] withRange:[self.text rangeOfString:@"Privacy Policy"]];
    [self addLinkToURL:[NSURL URLWithString:@"http://TERMS_OF_SERVICE"] withRange:[self.text rangeOfString:@"Terms of Service"]];
}


@end
