//
//  DTCNotebooksViewController.m
//  Everpobre
//
//  Created by David de Tena on 09/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCNotebooksViewController.h"
#import "DTCNotebook.h"
#import "DTCNote.h"
#import "DTCNotesViewController.h"

@interface DTCNotebooksViewController ()

@end

@implementation DTCNotebooksViewController


#pragma mark - View lifecycle

// Ponemos título
-(void) viewDidLoad{
    [super viewDidLoad];
    self.title = @"Everpobre";
    
    // Add button
    [self addNewNotebookButton];
    
    // Edit button
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

#pragma mark - Table Data Source

// Es el único método que no está implementado en la clase de la que heredamos, porque no es posible
// saber qué información se mostrará en la celda en ese momento
-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar cual es la libreta
    DTCNotebook *notebook = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Crear una celda, preguntamos si hay alguna disponible, si no la hay, la creamos
    static NSString *cellId = @"notebookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:cellId];
    }
    
    // Configurarla (sincronizar libreta  con celda). Indicamos nombre de libreta y el número de notas
    cell.textLabel.text = notebook.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d notas", [notebook.notes count]];
    
    // Devolverla
    return cell;
}

-(void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // El usuario quiere eliminar celda
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Eliminamos vista y pedimos al controlador que actualice modelo
        
        // Obtenemos libreta actual a partir del FetchedResultsController
        DTCNotebook *notebook = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        // Eliminamos celda de la tabla y del modelo.
        // CoreData manda una notificación de cambio por KVO a FetchedResultsController,
        // que avisa a la tabla y le dice que se refresque para no mostrar la celda eliminada
        [self.fetchedResultsController.managedObjectContext deleteObject:notebook];
    }
}


#pragma mark - Table Data delegate

// Al pulsar en una libreta se accederá al TableVC de sus notas
-(void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // Obtenemos libreta seleccionada
    DTCNotebook *notebook = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Necesitamos FetchRequest con predicado (que indique que queremos todas las notas de la libreta actual)
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[DTCNote entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DTCNoteAttributes.name
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)],
                            [NSSortDescriptor sortDescriptorWithKey:DTCNoteAttributes.modificationDate ascending:NO]];
    // Número de resultados que devolverá en cada lote
    req.fetchBatchSize = 20;
    //Queremos todas las notas de la libreta note
    req.predicate = [NSPredicate predicateWithFormat:@"notebook = %@",notebook];
    
    // Añadimos el FetchRequest al controlador NSFetchedResults
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:notebook.managedObjectContext
                                      sectionNameKeyPath:nil
                                      cacheName:nil];
    
    // Crear controlador de notas
    DTCNotesViewController *notesVC = [[DTCNotesViewController alloc]
                                       initWithFetchedResultsController:fc
                                       style:UITableViewStylePlain
                                       notebook:notebook];
    
    // Hacer un push
    [self.navigationController pushViewController:notesVC animated:YES];
}



#pragma mark - Utils

// Añadimos botón de nueva nota
-(void) addNewNotebookButton{
    // Botón añadir del sistema en la derecha de la barra de navegación
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addNewNotebook:)];
    self.navigationItem.rightBarButtonItem = addButton;
}


#pragma mark - Actions

// Añadimos nueva libreta en una nueva celda de la tabla
-(void) addNewNotebook:(id) sender{
    
    // Al crear una nueva libreta en el modelo, CoreData manda una notificación de cambio
    // por KVO a FetchedResultsController, que avisa a la tabla y le dice que se refresque
    [DTCNotebook notebookWithName:@"Nueva libreta"
                          context:self.fetchedResultsController.managedObjectContext];
}


@end
