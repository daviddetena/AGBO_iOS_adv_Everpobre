//
//  DTCPhotoViewController.m
//  Everpobre
//
//  Created by David de Tena on 11/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCPhotoViewController.h"
#import "DTCPhoto.h"
@import CoreImage;

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
    
    // Me aseguro de que la vista no ocupa toda la pantalla,
    // sino lo que queda disponible dentro del Navigation
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Sincronizo vista con el modelo
    self.photoView.image = self.model.image;
    
    // Activity View oculto al mostrarse la vista
    [self disableActivityIndicator];
}


-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Sincronizo modelo con la vista (me actualiza el modelo
    // de Core Data) con las notificaciones KVO
    self.model.image = self.photoView.image;
}


#pragma mark - Utils
-(void) enableActivityIndicator{
    self.activityView.hidden = NO;
    if (![self.activityView isAnimating]) {
        [self.activityView startAnimating];
    }
}


-(void) disableActivityIndicator{
    self.activityView.hidden = YES;
    if ([self.activityView isAnimating]) {
        [self.activityView stopAnimating];
    }
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
    
    // Configuración de la animación del ViewController
    cameraPicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Mostrarlo de forma modal
    [self presentViewController:cameraPicker
                       animated:YES
                     completion:^{
                         // Esto se va a ejecutar cuando termine la animación que muestra al picker
                     }];
}

- (IBAction)applyFilter:(id)sender {
    
    // Ponemos activity indicator mientras se aplica el filtro
    [self enableActivityIndicator];
    
    // Aplicamos filtro en segundo plano, accediendo a una cola existente de fábrica
    // sin necesidad de crear una propia (usamos una iniciada por usuario)
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        // Crear un contexto de CoreImage
        CIContext *context = [CIContext contextWithOptions:nil];
        
        // Imagen de entrada para el filtro, en formato CoreImage: CIImage (necesito una CoreGraphics Image)
        CIImage *inputImg = [CIImage imageWithCGImage:[self.model.image CGImage]];
        
        // Crear filtro y configurarlo mediante KVC
        CIFilter *vintage = [CIFilter filterWithName:@"CIFalseColor"];
        [vintage setValue:inputImg forKey:@"inputImage"];
        
        // Imagen de salida
        CIImage *outputImg = vintage.outputImage;
        
        // Aplicar filtro (necesitamos CGImageRef)
        CGImageRef out = [context createCGImage:outputImg fromRect:outputImg.extent];
        
        // Sustituyo la imagen
        self.model.image = [UIImage imageWithCGImage:out];
        CGImageRelease(out);
        
        NSLog(@"Filtro aplicado en segundo plano");
        
        // Actualizamos UI en cola principal
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Actualizo UI
            self.photoView.image = self.model.image;
            
            NSLog(@"UI actualizada en cola principal");
            
            // Ocultamos activity Indicator
            [self disableActivityIndicator];

        });
    });
}

- (IBAction)deletePhoto:(id)sender {
    
    // Crear AlertController
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"¿Delete photo?"
                                          message:@"This operation cannot be undone"
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Actions para el UIAlertController
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // Eliminamos foto
        // La eliminamos del modelo
        self.model.image = nil;
        CGRect oldRect = self.photoView.bounds;
        
        // Actualizamos la vista haciendo una animación
        [UIView animateWithDuration:0.7
                         animations:^{
                             // Difumino, reduzco tamaño y lo hago con transformada fin para que gire
                             self.photoView.alpha = 0;
                             self.photoView.bounds = CGRectZero;
                             self.photoView.transform = CGAffineTransformMakeRotation(M_PI_2);
                             
                             // AÑADIR EFECTO DE TRANSICIÓN PARA QUE VAYA DESDE EL CENTRO DE LA IMAGEN AL
                             // ICONO DE LA PAPELERA
                             // Está en IBOutlet y hay que pedir el centro, que estará en el centro de coordenadas
                             // de la toolbar
                             
                         } completion:^(BOOL finished) {
                             // Recuperamos configuración del photoView original
                             self.photoView.alpha = 1;
                             self.photoView.bounds = oldRect;
                             self.photoView.transform = CGAffineTransformIdentity;
                             
                             // Sincronizo la vista con el modelo actualizado
                             self.photoView.image = nil;
                         }];
    }];
    
    // Añadimos acciones al UIAlertController
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    
    // Y lo presentamos
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
// Acabó la vista modal del UIPicker
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // ¡OJO! PICO DE MEMORIA ASEGURADO, especialmente en dispositivos antiguos (5 o 4s)
    // Sacamos UIImage del diccionario
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // OJO AL DATO
    // Mirar en el online categoría que hace un resize de la image al tamaño de la pantalla, desapareciendo el pico de memoria
    
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
