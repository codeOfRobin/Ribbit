//
//  CameraViewController.h
//  Ribbit
//
//  Created by Robin Malhotra on 02/07/14.
//  Copyright (c) 2014 Robin's code kitchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *videoFilePath;
@end
