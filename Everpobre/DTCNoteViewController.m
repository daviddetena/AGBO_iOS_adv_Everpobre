//
//  DTCNoteViewController.m
//  Everpobre
//
//  Created by David de Tena on 10/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCNoteViewController.h"
#import "DTCNote.h"

@interface DTCNoteViewController ()

@end

@implementation DTCNoteViewController

#pragma mark - Init
-(id) initWithModel: (DTCNote *) model{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
    }
    return  self;
}

#pragma mark - View Lifecycle
-(void)  viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Asignamos delegados
    self.nameView.delegate = self;
    
    // Sincronizar modelo -> vista
    [self syncViewWithModel];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Sincronizo vistas -> modelo
    [self syncViewWithModel];
}

#pragma mark - Utils
-(void) syncViewWithModel{
    
    // NSString para las fechas
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateStyle = NSDateFormatterShortStyle;
    
    self.creationDateView.text = [fmt stringFromDate:self.model.creationDate];
    self.modificationDateView.text = [fmt stringFromDate:self.model.modificationDate];
    
    // Nombre
    self.nameView.text = self.model.name;
    
    // Texto
    self.textView.text = self.model.text;
}

-(void) syncModelWithView{

    // Recuperar datos de la interfaz y meterlos en el modelo
    self.model.name = self.nameView.text;
    self.model.text = self.textView.text;
}


#pragma mark - Actions
- (IBAction) displayPhoto:(id)sender {

}

- (IBAction) hideKeyboard:(id)sender{
    // Deja de editar la vista y todas sus subvistas
    // (para ocultar el teclado)
    [self.view endEditing:YES];
}


#pragma mark - UITextFieldDelegate
// Qué hacer cuando se pulsa Return
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // Buen momento de validar y en ese caso ocultamos teclado (resignFirstResponder)
    // return NO si no pasa la validación
    // Deja de tener el foco
    if ([textField.text length]>0) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

// Es el método que se ejecuta justo después del anterior
- (void) textFieldDidEndEditing:(UITextField *)textField{
    
    // Buen momento para guardar el texto (pasó la validación)
}

@end
