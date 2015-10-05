//
//  FRDGalleryPhoto.h
//  Frndr
//
//  Created by Eugenity on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMappingProtocol.h"

@interface FRDGalleryPhoto : NSObject<FRDMappingProtocol>

@property (strong, nonatomic) NSString *photoName;
@property (strong, nonatomic) NSURL *photoURL;

@end
