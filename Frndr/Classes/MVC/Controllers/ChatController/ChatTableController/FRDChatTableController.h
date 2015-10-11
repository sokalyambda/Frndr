//
//  FRDChatTableController.h
//  Frndr
//
//  Created by Pavlo on 10/5/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@class FRDFriend;

@interface FRDChatTableController : UITableViewController

@property (strong, nonatomic) NSMutableArray *messageHistory;
@property (strong, nonatomic) FRDFriend *currentFriend;
@property (assign, nonatomic) NSInteger currentPage;

- (void)scrollTableViewToBottomAnimated:(BOOL)animated;

@end
