//
//  DTCNotebookViewController.h
//  Everpobre
//
//  Created by David de Tena on 13/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import UIKit;
@class DTCNotebook;

@interface DTCNotebookViewController : UIViewController<UITextFieldDelegate>

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UITextField *notebookView;
@property (strong,nonatomic) DTCNotebook *model;

#pragma mark - Init
-(id) initWithModel: (DTCNotebook *)model;

#pragma mark - Methods
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)didPressCancelButton:(id)sender;
- (IBAction)didPressDoneButton:(id)sender;


@end
