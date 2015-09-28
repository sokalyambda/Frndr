//
//  FRDSwitch.m
//  CustomSwitch
//
//  Created by Pavlo on 9/20/15.
//  Copyright © 2015 Pavlo. All rights reserved.
//

#import "FRDSwitch.h"

@interface FRDSwitch ()

@property (nonatomic) UIImageView *switchImageView;
@property (nonatomic) UIImageView *onImageView;
@property (nonatomic) UIImageView *offImageView;
@property (nonatomic) UILabel *onLabel;
@property (nonatomic) UILabel *offLabel;

@property (nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic) CGRect savedOnFrame;
@property (nonatomic) CGRect savedOffFrame;

@end

@implementation FRDSwitch

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIColor *labelsColor = UIColorFromRGB(0x35B8B4);
    
    _switchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Slider_Thumb"]];
    
    _onImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwitchBackground"]];
    _savedOnFrame = _onImageView.frame;
    
    _offImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwitchBackground"]];
    _savedOffFrame = _offImageView.frame;
    
    _onLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _onLabel.textAlignment = NSTextAlignmentCenter;
    
    _offLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _offLabel.textAlignment = NSTextAlignmentCenter;

    [self setOnText:@"YES" withFont:[UIFont fontWithName:@"Gill Sans" size:16] andColor:labelsColor];
    [self setOffText:@"NO" withFont:[UIFont fontWithName:@"Gill Sans" size:16] andColor:labelsColor];
    
    [self addSubview:_onImageView];
    [self addSubview:_onLabel];
    
    [self addSubview:_offImageView];
    [self addSubview:_offLabel];
    
    [self addSubview:_switchImageView];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:_tapRecognizer];
}

#pragma mark - Accessors

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    _on = on;
    
    if (on) {
        self.offLabel.layer.opacity = 0.0;
        self.offImageView.layer.opacity = 0.0;
        
        self.onLabel.layer.opacity = 1.0;
        self.onImageView.layer.opacity = 1.0;
        
        [self moveSwitchToOnPosition:animated];
    } else {
        self.onLabel.layer.opacity = 0.0;
        self.onImageView.layer.opacity = 0.0;
        
        self.offLabel.layer.opacity = 1.0;
        self.offImageView.layer.opacity = 1.0;
        
        [self moveSwitchToOffPosition:animated];
    }
}

- (void)setSwitchImage:(UIImage *)image
{
    self.switchImageView.image = image;
    self.switchImageView.frame = CGRectMake(0,
                                            CGRectGetMidY(self.bounds) - image.size.height / 2.0,
                                            image.size.width,
                                            image.size.height);
}

- (void)setOnImage:(UIImage *)image
{
    CGRect frame = CGRectMake(0,
                              CGRectGetMidY(self.bounds) - image.size.height / 2.0,
                              image.size.width,
                              image.size.height);
    self.onImageView.image = image;
    self.onImageView.frame = frame;
    self.savedOnFrame = frame;
}

- (void)setOffImage:(UIImage *)image
{
    CGRect frame = CGRectMake(0,
                              CGRectGetMidY(self.bounds) - image.size.height / 2.0,
                              image.size.width,
                              image.size.height);
    self.offImageView.image = image;
    self.offImageView.frame = frame;
    self.savedOffFrame = frame;
}

- (void)setOnText:(NSString *)text withFont:(UIFont *)font andColor:(UIColor *)color
{
    self.onLabel.text = text;
    self.onLabel.font = font;
    self.onLabel.textColor = color;
    [self.onLabel sizeToFit];

    CGFloat xPosition = (CGRectGetWidth(self.savedOnFrame) - CGRectGetWidth(self.switchImageView.frame)) / 2.0;
    xPosition -= CGRectGetMidX(self.onLabel.bounds);
    
    self.onLabel.frame = CGRectMake(xPosition,
                                    CGRectGetMidY(self.savedOnFrame) - CGRectGetMidY(self.onLabel.bounds),
                                    CGRectGetWidth(self.onLabel.frame),
                                    CGRectGetHeight(self.onLabel.frame));
}

- (void)setOffText:(NSString *)text withFont:(UIFont *)font andColor:(UIColor *)color
{
    self.offLabel.text = text;
    self.offLabel.font = font;
    self.offLabel.textColor = color;
    [self.offLabel sizeToFit];
    
    CGFloat xPosition = (CGRectGetWidth(self.savedOffFrame) + CGRectGetMaxX(self.switchImageView.frame)) / 2.0;
    xPosition -= CGRectGetMidX(self.offLabel.bounds);
    
    self.offLabel.frame = CGRectMake(xPosition,
                                    CGRectGetMidY(self.savedOffFrame) - CGRectGetMidY(self.offLabel.bounds),
                                    CGRectGetWidth(self.offLabel.frame),
                                    CGRectGetHeight(self.offLabel.frame));
}

#pragma mark - Actions

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self setOn:!self.isOn animated:YES];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)updateLabels
{
    
}

- (void)moveSwitchToOnPosition:(BOOL)animated
{
    CGPoint destination = self.switchImageView.layer.position;
    destination.x = CGRectGetWidth(self.frame) - CGRectGetMidX(self.switchImageView.bounds);

    if (animated) {
        CABasicAnimation *switching = [CABasicAnimation animationWithKeyPath:@"position.x"];
        switching.fromValue = @(self.switchImageView.layer.position.x);
        switching.toValue = @(destination.x);
        switching.duration = 0.25;
        
        [self.switchImageView.layer addAnimation:switching forKey:@"position.x"];
    }
    
    self.switchImageView.layer.position = destination;
}

- (void)moveSwitchToOffPosition:(BOOL)animated
{
    CGPoint destination = self.switchImageView.layer.position;
    destination.x = CGRectGetMidX(self.switchImageView.bounds);
    
    if (animated) {
        CABasicAnimation *switching = [CABasicAnimation animationWithKeyPath:@"position.x"];
        switching.fromValue = @(self.switchImageView.layer.position.x);
        switching.toValue = @(destination.x);
        switching.duration = 0.25;
        
        [self.switchImageView.layer addAnimation:switching forKey:@"position.x"];
    }
    
    self.switchImageView.layer.position = destination;
}

#pragma mark - Touch handling

@end
