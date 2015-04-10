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
    
    // Add button
    [self addNewNoteButton];
}


#pragma mark - Table Data Source
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

// Permitimos que se puedan eliminar notas de la libreta
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Obtenemos la nota de la celda
        DTCNote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        // La eliminiamos
        [self.fetchedResultsController.managedObjectContext deleteObject:note];
    }
}


#pragma mark - Table Delegate



#pragma mark - Utils

// Añadimos botón de nueva nota
-(void) addNewNoteButton{
    // Botón añadir del sistema en la derecha de la barra de navegación
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addNewNote:)];
    self.navigationItem.rightBarButtonItem = addButton;
}


#pragma mark - Actions

// Añadimos nueva libreta en una nueva celda de la tabla
-(void) addNewNote:(id) sender{
    
    // Al crear una nueva nota en el modelo, CoreData manda una notificación de cambio
    // por KVO a FetchedResultsController, que avisa a la tabla y le dice que se refresque
    [DTCNote noteWithName:@"Nueva nota"
                 notebook:self.notebook
                  context:self.notebook.managedObjectContext];
}

@end
