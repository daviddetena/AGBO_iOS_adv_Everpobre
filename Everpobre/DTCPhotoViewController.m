//
//  DTCPhotoViewController.m
//  Everpobre
//
//  Created by David de Tena on 11/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCPhotoViewController.h"
#import "DTCPhoto.h"

@interface DTCPhotoViewController ()

@end

@implementation DTCPhotoViewController


#pragma mark - Init
-(id) initWithModel: (DTCPhoto *) model{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
    }
    return self;
}

#pragma mark - View life cycle
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Sincronizo vista con el modelo
    self.photoView.image = self.model.image;
}


-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Sincronizo modelo con la vista (me actualiza el modelo
    // de Core Data) con las notificaciones KVO
    self.model.image = self.photoView.image;
}

#pragma mark - Actions

- (IBAction)takePicture:(id)sender {
    
    // Crear UIImagePickerController
    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc]init];
    
    // Configurarla
    // Comprobamos si se puede seleccionar la camara
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // Usamos la camara
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        // Tiro del carrete
        cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    cameraPicker.editing = NO;
    cameraPicker.delegate = self;
    
    // Mostrarlo de forma modal
    [self presentViewController:cameraPicker
                       animated:YES
                     completion:^{
                         // Esto se va a ejecutar cuando termine la animación que muestra al picker
                     }];
}

- (IBAction)applyFilter:(id)sender {
    
}

- (IBAction)deletePhoto:(id)sender {
    
}

#pragma mark - UIImagePickerControllerDelegate
// Acabó la vista modal del UIPicker
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // ¡OJO! PICO DE MEMORIA ASEGURADO, especialmente en dispositivos antiguos (5 o 4s)
    // Sacamos UIImage del diccionario
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Guardamos en modelo
    self.model.image = image;
    
    // El presentador (PhotoVC) tiene que ocultar el picker modal que estamos presentando
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // Se ejecuta cuando se haya ocultado del todo
                             }];
}

// El usuario canceló el uso de la cámara/carrete
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    // El presentador (PhotoVC) tiene que ocultar el picker modal que estamos presentando
    [self dismissViewControllerAnimated:YES
                               completion:^{
                                   // Qué hacer al ocultar el picker
                               }];
}

@end
