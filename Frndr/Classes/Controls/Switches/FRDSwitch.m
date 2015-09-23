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

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self commonInit];
}

- (void)commonInit
{
    UIColor *labelsColor = UIColorFromRGB(0x35B8B4);
    
    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc]
                                        initWithFontAttributes:@{ UIFontDescriptorSizeAttribute : @16,
                                                                  UIFontDescriptorNameAttribute : @"Gill Sans" }];
    
    _switchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Slider_Thumb"]];
    _onImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwitchBackground"]];
    _offImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwitchBackground"]];
    
    _onLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _onLabel.textAlignment = NSTextAlignmentCenter;
    
    _offLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _offLabel.textAlignment = NSTextAlignmentCenter;

    [self setOnText:@"YES"
 withFontDescriptor:fontDescriptor
           andColor:labelsColor];
    
    [self setOffText:@"NO"
  withFontDescriptor:fontDescriptor
            andColor:labelsColor];
    
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
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
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
    self.onImageView.image = image;
    self.onImageView.frame = CGRectMake(0,
                                        CGRectGetMidY(self.bounds) - image.size.height / 2.0,
                                        image.size.width,
                                        image.size.height);
}

- (void)setOffImage:(UIImage *)image
{
    self.offImageView.image = image;
    self.offImageView.frame = CGRectMake(0,
                                        CGRectGetMidY(self.bounds) - image.size.height / 2.0,
                                        image.size.width,
                                        image.size.height);
}

- (void)setOnText:(NSString *)text withFontDescriptor:(UIFontDescriptor *)descriptor andColor:(UIColor *)color
{
    self.onLabel.text = text;
    self.onLabel.font = [UIFont fontWithDescriptor:descriptor size:0.0];
    self.onLabel.textColor = color;
    [self.onLabel sizeToFit];

    CGFloat xPosition = (CGRectGetWidth(self.frame) - CGRectGetWidth(self.switchImageView.frame)) / 2.0;
    xPosition -= CGRectGetMidX(self.onLabel.bounds);
    
    self.onLabel.frame = CGRectMake(xPosition,
                                    CGRectGetMidY(self.bounds) - CGRectGetMidY(self.onLabel.bounds),
                                    CGRectGetWidth(self.onLabel.frame),
                                    CGRectGetHeight(self.onLabel.frame));
}

- (void)setOffText:(NSString *)text withFontDescriptor:(UIFontDescriptor *)descriptor andColor:(UIColor *)color
{
    self.offLabel.text = text;
    self.offLabel.font = [UIFont fontWithDescriptor:descriptor size:0.0];
    self.offLabel.textColor = color;
    [self.offLabel sizeToFit];
    
    CGFloat xPosition = (CGRectGetWidth(self.frame) + CGRectGetMaxX(self.switchImageView.frame)) / 2.0;
    xPosition -= CGRectGetMidX(self.offLabel.bounds);
    
    self.offLabel.frame = CGRectMake(xPosition,
                                    CGRectGetMidY(self.bounds) - CGRectGetMidY(self.offLabel.bounds),
                                    CGRectGetWidth(self.offLabel.frame),
                                    CGRectGetHeight(self.offLabel.frame));
}

#pragma mark - Actions

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self setOn:!self.isOn animated:YES];
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

@end
