//
//  DTCNotesViewController.h
//  Everpobre
//
//  Created by David de Tena on 10/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "AGTCoreDataTableViewController.h"
@class DTCNotebook;

@interface DTCNotesViewController : AGTCoreDataTableViewController

#pragma mark - Init
-(id) initWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController
                                 style:(UITableViewStyle)aStyle
                              notebook: (DTCNotebook *) notebook;

@end
