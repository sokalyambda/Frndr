//
//  BZRMacros.h
//  Periop
//
//  Created by Admin on 02.10.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

@interface FRDMacros

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height < ( double )481 ) )
#define IS_IPHONE_5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define IS_IPHONE_6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)
#define IS_IPHONE_6P ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736)

#define WEAK_SELF __weak typeof(self) weakSelf = self

#define IS_IOS7_OR_BELOW ([UIDevice currentDevice].systemVersion.floatValue < 8.0)

#ifndef LOCALIZED
#define LOCALIZED(arg) NSLocalizedString(arg, nil)
#endif

#pragma mark - DebugLog

#ifndef DLog
#ifdef DEBUG
#define DLog(_format_, ...) NSLog(_format_, ## __VA_ARGS__)
#else
#define DLog(_format_, ...)
#endif
#endif

#ifdef DEBUG
//    #define DEBUG_PRINT
#define DEBUG_PRINTLOG
#endif

#ifdef DEBUG_PRINT
#define LOG_GENERAL(format, ...) NSLog(@"%s: " format, __FUNCTION__, ##__VA_ARGS__)
#else
#define LOG_GENERAL(format, ...) do {} while(0)
#endif

#ifdef DEBUG_PRINTLOG
#define LOG_NETWORK(format, ...) NSLog(@"%s: " format, __FUNCTION__, ##__VA_ARGS__)
#else
#define LOG_NETWORK(format, ...) do {} while(0)
#endif

@end
