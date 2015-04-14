//
//  DTCPhotoViewController.h
//  Everpobre
//
//  Created by David de Tena on 11/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import UIKit;

@class DTCPhoto;


@interface DTCPhotoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (strong,nonatomic) DTCPhoto *model;

#pragma mark - Init
-(id) initWithModel: (DTCPhoto *) model;


#pragma mark - Actions
- (IBAction)takePicture:(id)sender;
- (IBAction)applyFilter:(id)sender;
- (IBAction)deletePhoto:(id)sender;


@end
