//
//  DTCNotesViewController.m
//  Everpobre
//
//  Created by David de Tena on 10/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCNotesViewController.h"
#import "DTCNote.h"
#import "DTCPhoto.h"
#import "DTCNotebook.h"

@interface DTCNotesViewController ()
@property (nonatomic,strong) DTCNotebook *notebook;
@end

@implementation DTCNotesViewController


#pragma mark - Init
-(id)initWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController
                                style:(UITableViewStyle)aStyle
                             notebook:(DTCNotebook *)notebook{

    if (self = [super initWithFetchedResultsController:aFetchedResultsController
                                                 style:aStyle]) {
        _notebook = notebook;
        self.title = notebook.name;
    }
    return self;
}


#pragma mark - Lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    //self.title = _notebook.name;
}


#pragma mark - Data Source
// Método que genera la celda
-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    // Averiguar la nota
    DTCNote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Crear la celda
    static NSString *noteCellId = @"NoteCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noteCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                                 initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:noteCellId];
    }
    
    // Sincronizar nota y celda
    cell.imageView.image = note.photo.image;
    cell.textLabel.text = note.name;
    
    // Devolverla
    return cell;
}

@end
