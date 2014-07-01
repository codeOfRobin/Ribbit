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

-(void)viewWillAppear:(BOOL)animated
{
    
}
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
    
    if ([self isFriend:user])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(BOOL)isFriend:(PFUser *)otherUser
{
    for (PFUser *friend in self.friends)
    {
        if ([friend.objectId isEqualToString:otherUser.objectId])
        {
        return YES;
        }
    }
    
    return NO;
}

#pragma mark-Table view Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    PFUser *user=[self.allUsers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation=[self.currentUser relationForKey:@"friendsRelation"];

    
    if ([self isFriend:[self.allUsers objectAtIndex:indexPath.row]])
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        for (PFUser *friend in self.friends)
        {
            if ([friend.objectId isEqualToString:user.objectId])
            {
                [self.friends removeObject:friend];
                break;
            }
            
        }
        
        
        [friendsRelation removeObject:user];
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [self.friends addObject:user];
        [friendsRelation addObject:user];
        
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@" Erir %@",error.userInfo);
        }
    }];
    
    
    
    
}
@end
