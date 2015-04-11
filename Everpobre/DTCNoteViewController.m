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
    
    // Alta en notificaciones de teclado para ver cuando se muestra/oculta el teclado
    [self setupKeyboardNotifications];
    
    // Sincronizar modelo -> vista
    [self syncViewWithModel];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Baja en las notificaciones de teclado para ver cuando se muestra/oculta el teclado
    [self tearDownKeyboardNotifications];
    
    // Sincronizo vistas -> modelo
    [self syncModelWithView];
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

-(void) setupKeyboardNotifications{
    // Alta en notificaciones para cuando se muestra y oculta el teclado
    NSNotificationCenter *nc = [NSNotificationCenter
                                defaultCenter];
    [nc addObserver:self
           selector:@selector(notifyThatKeyboardWillAppear:)
               name:UIKeyboardWillShowNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(notifyThatKeyboardWillDisappear:)
               name:UIKeyboardWillHideNotification
             object:nil];
    
}

-(void) tearDownKeyboardNotifications{
    NSNotificationCenter *nc = [NSNotificationCenter
                                defaultCenter];
    [nc removeObserver:self];
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



#pragma mark - Notifications

//UIKeyboardWillShowNotification
- (void) notifyThatKeyboardWillAppear:(NSNotification *) n{
    // Sacar la duración de la animación de teclado
    double duration = [[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Sacar el tamaño (bounds) del teclado del objeto userInfo
    // que viene en la notificación
    NSValue *wrappedFrame = [n.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect kbdFrame = [wrappedFrame CGRectValue];
    
    // Calcular los nuevos bounds de self.textView (hacerlo más pequeño)
    // Hacerlo con animación que coincida con la del teclado
    CGRect currentFrame = self.textView.frame;
    CGRect newRect = CGRectMake(currentFrame.origin.x, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height - kbdFrame.size.height + self.bottomBar.frame.size.height);
    
    // Durante la animación le asignamos el nuevo frame del textView
    [UIView animateWithDuration:duration animations:^{
        self.textView.frame = newRect;
    }];
    
}


//UIKeyboardWillHideNotification
- (void) notifyThatKeyboardWillDisappear:(NSNotification *) n{
    
    // Sacar la duración de la animación de teclado
    double duration = [[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // Devolver a self.textView sus bounds originales mediante una
    // animación que coincida con la del teclado.
    
    // Durante la animación le asignamos el nuevo frame del textView
    [UIView animateWithDuration:duration animations:^{
        self.textView.frame = CGRectMake(8, 150, 304, 359);
    }];    
}

@end
