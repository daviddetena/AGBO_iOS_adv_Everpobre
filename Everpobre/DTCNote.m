#import "DTCNote.h"
#import "DTCPhoto.h"

@interface DTCNote ()

// Private interface goes here.

@end

@implementation DTCNote


#pragma mark - Class Methods

+(NSArray *) observableKeys{
    // Cada vez que haya una modificación en la propiedad photoData de mi photo KVO mandará una notificación
    // que se usará para actualizar la fecha de modificación
    return @[DTCNoteAttributes.name, DTCNoteAttributes.text, DTCNoteRelationships.notebook, @"photo.photoData"];
}

+(instancetype) noteWithName:(NSString *)name
                    notebook:(DTCNotebook *)notebook
                     context:(NSManagedObjectContext *)context{
    
    DTCNote *note = [self insertInManagedObjectContext:context];
    note.name = name;
    note.notebook = notebook;
    note.creationDate = [NSDate date];
    note.modificationDate = [NSDate date];
    note.photo = [DTCPhoto insertInManagedObjectContext:context];
    
    return note;
}

#pragma mark - KVO
-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    self.modificationDate = [NSDate date];
}

@end
