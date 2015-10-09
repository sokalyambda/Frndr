//
//  FRDPlaceholderTextView.m
//  Frndr
//
//  Created by Eugenity on 09.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPlaceholderTextView.h"

static CGFloat const kAnimationDuration = .25f;

@interface FRDPlaceholderTextView ()

@property (strong, nonatomic) UILabel *placeHolderLabel;

@end

@implementation FRDPlaceholderTextView

#pragma mark - Accessors

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}

#pragma mark - Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - Notifications

- (void)textChanged:(NSNotification *)notification
{
    if(!self.placeholder.length) {
        return;
    }
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        if(!self.text.length) {
            [self.placeHolderLabel setAlpha:1];
        } else {
            [self.placeHolderLabel setAlpha:0];
        }
    }];
}

- (void)drawRect:(CGRect)rect
{
    if(self.placeholder.length) {
        if (!_placeHolderLabel) {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if(!self.text.length && self.placeholder.length) {
        [self.placeHolderLabel setAlpha:1];
    }
    
    [super drawRect:rect];
}

@end
