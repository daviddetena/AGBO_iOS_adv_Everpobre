//
//  DTCNotebookViewController.m
//  Everpobre
//
//  Created by David de Tena on 13/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCNotebookViewController.h"
#import "DTCNotebook.h"

@interface DTCNotebookViewController ()

@end

@implementation DTCNotebookViewController

#pragma mark - Init
-(id) initWithModel: (DTCNotebook *)model{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
    }
    return self;
}

#pragma mark - View life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Me aseguro de que la vista no ocupa toda la pantalla,
    // sino lo que queda disponible dentro del Navigation
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Asignamos delegados
    self.notebookView.delegate = self;
    
    // Sincronizar modelo -> vista
    [self syncViewWithModel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Sincronizo vistas -> modelo (la nota se actualiza y ya aparece en la tabla)
    // El contexto manda la notificación al FetchedResults, que actualiza la tabla
    [self syncModelWithView];
}


#pragma mark - Utils
-(void) syncViewWithModel{
    // En el campo de texto se muestra el nombre de la nota
    self.notebookView.text = self.model.name;
}

-(void) syncModelWithView{
    
    // Recuperar datos de la interfaz y meterlos en el modelo
    self.model.name = self.notebookView.text;
}

-(void) dismissViewController{
    // Ocultamos VC actual a partir del ViewController que lo mostró
    [self.presentingViewController
     dismissViewControllerAnimated:YES completion:^{
         //
     }];
}



#pragma mark - UITextFieldDelegate
// Qué hacer cuando se pulsa Return
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // Buen momento de validar y en ese caso ocultamos teclado (resignFirstResponder)
    // Deja de tener el foco
    if ([textField.text length]>0) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

// Es el método que se ejecuta justo después del anterior
- (void) textFieldDidEndEditing:(UITextField *)textField{
    // Si finaliza la edición correctamente ocultamos vista
    if ([self textFieldShouldReturn:textField]) {
        [self dismissViewController];
    }
}

#pragma mark - Actions
- (IBAction)hideKeyboard:(id)sender{
    // Finaliza la edición al pulsar sobre una zona distinta
    // del TextField (oculta teclado)
    [self.notebookView endEditing:YES];
}

- (IBAction)didPressCancelButton:(id)sender {
    // Ocultamos controlador (el modelo se actualiza solo)
    [self dismissViewController];
}

- (IBAction)didPressDoneButton:(id)sender {
    // Ocultamos controlador (el modelo se actualiza solo)
    [self dismissViewController];
}


@end
