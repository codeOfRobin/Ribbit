//
//  friendsTableViewController.h
//  Ribbit
//
//  Created by Robin Malhotra on 01/07/14.
//  Copyright (c) 2014 Robin's code kitchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface friendsTableViewController : UITableViewController

@property (nonatomic,strong) NSArray *friends;
@property (nonatomic,strong) PFRelation *friendsRelation;
@end
