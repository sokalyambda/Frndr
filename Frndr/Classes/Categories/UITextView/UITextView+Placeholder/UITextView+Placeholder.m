//
//  UITextView+Placeholder.m
//  Frndr
//
//  Created by Pavlo on 10/9/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "UITextView+Placeholder.h"

@implementation UITextView (Placeholder)

- (void)clearTextWithPlaceholder:(NSString *)placeholder
{
    self.text = @"";
    [self insertText:placeholder];
}

@end
