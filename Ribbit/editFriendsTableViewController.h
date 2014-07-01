//
//  editFriendsTableViewController.h
//  Ribbit
//
//  Created by Robin Malhotra on 30/06/14.
//  Copyright (c) 2014 Robin's code kitchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface editFriendsTableViewController : UITableViewController
@property (nonatomic,strong) NSArray *allUsers;
@property (nonatomic,strong) PFUser *currentUser;
-(BOOL)isFriend:(PFUser *) otherUser;
@property (nonatomic,strong) NSMutableArray *friends;
@end
