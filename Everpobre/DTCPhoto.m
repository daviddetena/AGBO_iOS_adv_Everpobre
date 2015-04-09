#import "DTCPhoto.h"

@interface DTCPhoto ()

// Private interface goes here.

@end

@implementation DTCPhoto

#pragma mark - Custom properties
-(UIImage *) image{
    // Convertimos el NSData de CoreData en UIImage
    UIImage *image = [UIImage imageWithData:self.photoData];
    return image;
}

-(void) setImage:(UIImage *)image{
    // Convertimos UIImage en NSData entendible por Core Data
    self.photoData  = UIImageJPEGRepresentation(image, 0.9);
}

@end
