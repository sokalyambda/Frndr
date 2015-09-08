//
//  UIFont+Styles.m
//  BizrateRewards
//
//  Created by Eugenity on 18.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "UIFont+Styles.h"

static CGFloat const kTitelSmallFontSize = 18.f;
static CGFloat const kTitelMediumFontSize = 22.f;
static CGFloat const kTitelLargeFontSize = 26.f;

static CGFloat const kDescriptionSmallFontSize = 14.f;
static CGFloat const kDescriptionMediumFontSize = 16.f;
static CGFloat const kDescriptionLargeFontSize = 18.f;

static CGFloat const kPointsInscriptionSmallFontSize = 13.f;
static CGFloat const kPointsInscriptionMediumFontSize = 15.f;
static CGFloat const kPointsInscriptionLargeFontSize = 17.f;

static CGFloat const kPointsValueSmallFontSize = 16.f;
static CGFloat const kPointsValueMediumFontSize = 18.f;
static CGFloat const kPointsValueLargeFontSize = 20.f;

static CGFloat const kSurveyCongratsSmallFontSize = 12.f;
static CGFloat const kSurveyCongratsMediumFontSize = 14.f;
static CGFloat const kSurveyCongratsLargeFontSize = 16.f;

static CGFloat const kSurveyRemarkSmallFontSize = 11.f;
static CGFloat const kSurveyRemarkMediumFontSize = 13.f;
static CGFloat const kSurveyRemarkLargeFontSize = 15.f;

static NSString *const kOpenSansFontName = @"OpenSans";
static NSString *const kOpenSansSemiboldFontName = @"OpenSans-Semibold";
static NSString *const kOpenSansBoldFontName = @"OpenSans-Bold";

@implementation UIFont (Styles)

//MARK: Tutorial
+ (UIFont *)tutorialTitleFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:kOpenSansFontName size:kTitelSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:kOpenSansFontName size:kTitelMediumFontSize];
    } else {
        return [UIFont fontWithName:kOpenSansFontName size:kTitelLargeFontSize];
    }
}

+ (UIFont *)tutorialDesciptionFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:kOpenSansFontName size:kDescriptionSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:kOpenSansFontName size:kDescriptionMediumFontSize];
    } else {
        return [UIFont fontWithName:kOpenSansFontName size:kDescriptionLargeFontSize];
    }
}

//MARK: Surveys
+ (UIFont *)surveyPointsInscriptionFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:kOpenSansSemiboldFontName size:kPointsInscriptionSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:kOpenSansSemiboldFontName size:kPointsInscriptionMediumFontSize];
    } else {
        return [UIFont fontWithName:kOpenSansSemiboldFontName size:kPointsInscriptionLargeFontSize];
    }
}

+ (UIFont *)surveyPointsValueFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:kOpenSansBoldFontName size:kPointsValueSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:kOpenSansBoldFontName size:kPointsValueMediumFontSize];
    } else {
        return [UIFont fontWithName:kOpenSansBoldFontName size:kPointsValueLargeFontSize];
    }
}

+ (UIFont *)surveyCongratsFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:kOpenSansSemiboldFontName size:kSurveyCongratsSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:kOpenSansSemiboldFontName size:kSurveyCongratsMediumFontSize];
    } else {
        return [UIFont fontWithName:kOpenSansSemiboldFontName size:kSurveyCongratsLargeFontSize];
    }
}

+ (UIFont *)surveyRemarkFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:kOpenSansFontName size:kSurveyRemarkSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:kOpenSansFontName size:kSurveyRemarkMediumFontSize];
    } else {
        return [UIFont fontWithName:kOpenSansFontName size:kSurveyRemarkLargeFontSize];
    }
}

//MARK: Privacy&Terms
+ (UIFont *)privacyAndTermsFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:kOpenSansFontName size:kPointsInscriptionSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:kOpenSansFontName size:kPointsInscriptionMediumFontSize];
    } else {
        return [UIFont fontWithName:kOpenSansFontName size:kPointsInscriptionLargeFontSize];
    }
}

@end
