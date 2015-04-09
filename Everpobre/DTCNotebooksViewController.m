//
//  DTCNotebooksViewController.m
//  Everpobre
//
//  Created by David de Tena on 09/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCNotebooksViewController.h"
#import "DTCNotebook.h"

@interface DTCNotebooksViewController ()

@end

@implementation DTCNotebooksViewController


#pragma mark - View lifecycle

// Ponemos título
-(void) viewDidLoad{
    [super viewDidLoad];
    self.title = @"Everpobre";
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


@end
