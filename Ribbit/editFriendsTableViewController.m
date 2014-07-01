//
//  editFriendsTableViewController.m
//  Ribbit
//
//  Created by Robin Malhotra on 30/06/14.
//  Copyright (c) 2014 Robin's code kitchen. All rights reserved.
//

#import "editFriendsTableViewController.h"
@interface editFriendsTableViewController ()

@end

@implementation editFriendsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    PFQuery *query=[PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if(error)
        {
            NSLog(@"%@",error.userInfo);
        }
        else
        {
            self.allUsers=objects;
            [self.tableView reloadData];

        }
    }];
    
    self.currentUser=[PFUser currentUser];
 
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.allUsers count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    PFUser *user=[self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text=user.username;
    return cell;
}

#pragma mark-Table view Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    PFRelation *friendsRelation=[self.currentUser relationForKey:@"friendsRelation"];
    PFUser *user=[self.allUsers objectAtIndex:indexPath.row];
    [friendsRelation addObject:user];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@" Erir %@",error.userInfo);
        }
    }];
}
@end
