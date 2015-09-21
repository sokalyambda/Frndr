//
//  FRDTopContentView.h
//  Frndr
//
//  Created by Eugenity on 21.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSUInteger, FRDTopViewActionType) {
    FRDTopViewActionTypeLeftIcon,
    FRDTopViewActionTypeRightIcon
};

@protocol FRDTopContentViewDelegate;

@interface FRDTopContentView : UIView

@property (nonatomic) NSString *topTitleText;
@property (nonatomic) NSString *leftIconName;
@property (nonatomic) NSString *rightIconName;

@property (weak, nonatomic) id<FRDTopContentViewDelegate> delegate;

@end

@protocol FRDTopContentViewDelegate <NSObject>

@optional
- (void)topContentView:(FRDTopContentView *)contentView didPressItemWithType:(FRDTopViewActionType)type;

@end