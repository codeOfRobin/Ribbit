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
    


}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


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
