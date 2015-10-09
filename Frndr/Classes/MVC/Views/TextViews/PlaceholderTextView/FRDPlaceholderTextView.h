//
//  FRDPlaceholderTextView.h
//  Frndr
//
//  Created by Eugenity on 09.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//


@interface FRDPlaceholderTextView : UITextView

@property (nonatomic) NSString *placeholder;
@property (nonatomic) UIColor *placeholderColor;
//
-(void)textChanged:(NSNotification*)notification;

@end
