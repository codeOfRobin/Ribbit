//
//  CameraViewController.m
//  Ribbit
//
//  Created by Robin Malhotra on 02/07/14.
//  Copyright (c) 2014 Robin's code kitchen. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

-(void)viewDidAppear:(BOOL)animated
{
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.friendsRelation=[[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery *query=[self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error.userInfo);
        }
        else
        {
            self.friends=objects;
            [self.tableView reloadData];
        }
    }];

    
    self.imagePicker=[[UIImagePickerController alloc] init];
    self.imagePicker.delegate=self;
    self.imagePicker.allowsEditing=NO;
    self.imagePicker.videoMaximumDuration=10;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        
    }
    else
    {
        self.imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    self.imagePicker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    [self presentViewController:self.imagePicker animated:NO completion:^{
        
    }];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recipients=[[NSMutableArray alloc]init ];

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
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    PFUser *friend=[self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text=friend.username;
    if ([self.recipients containsObject:friend])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    PFUser *user=[self.friends objectAtIndex:indexPath.row];
    if (cell.accessoryType==UITableViewCellAccessoryNone)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
        [self.recipients addObject:user];
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        [self.recipients removeObject:user];
    }
}

#pragma mark-Send and cancel methods

- (void)reset
{
    self.image=nil;
    self.videoFilePath=nil;
    [self.recipients removeAllObjects];
}

- (IBAction)cancel:(id)sender
{
    [self reset];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender
{
    if (self.image==nil && [self.videoFilePath length]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops" message:@"please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        [self uploadMessage];
        [self reset];

        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark-Helper

-(void)uploadMessage
{
    if (self.image!=nil)
    {
        CGRect rect= [[UIScreen mainScreen]bounds];
        UIImage *newImage=[self resizeImage:self.image toHeight:rect.size.height andWidth:rect.size.width];
    }
}

-(UIImage *)resizeImage:(UIImage *)image toHeight:(float)height andWidth:(float)width
{
    CGSize newSize=CGSizeMake(width, height);
    CGRect newRect=CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRect];
    UIImage *resizedImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Camera delegate 

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        // a photo is used
        if (self.imagePicker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            self.image=[info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);

        }
        
    }
    
    else
    {
        self.videoFilePath=(__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
        if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath))
           {
               UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
    
           }
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
