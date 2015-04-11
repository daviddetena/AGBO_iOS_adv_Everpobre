//
//  DTCNoteViewController.h
//  Everpobre
//
//  Created by David de Tena on 10/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import <UIKit/UIKit.h>
@import UIKit;

@class DTCNote;

@interface DTCNoteViewController : UIViewController <UITextFieldDelegate>

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UILabel *creationDateView;
@property (weak, nonatomic) IBOutlet UILabel *modificationDateView;
@property (weak, nonatomic) IBOutlet UITextField *nameView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;

// Modelo
@property (nonatomic,strong) DTCNote *model;

#pragma mark - Init
-(id) initWithModel: (DTCNote *) model;


#pragma mark - Actions
- (IBAction)displayPhoto:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
