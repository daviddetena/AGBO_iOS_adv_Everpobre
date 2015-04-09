#import "DTCNotebook.h"

@interface DTCNotebook ()

// Private interface goes here.

@end

@implementation DTCNotebook

#pragma mark - Class methods

// Propiedades que serán observables
+(NSArray *) observableKeys{
    return @[DTCNotebookAttributes.name, DTCNotebookRelationships.notes];
}

// Factory method
+(instancetype) notebookWithName:(NSString *) name
                         context: (NSManagedObjectContext *) context{
    
    DTCNotebook *notebook = [self insertInManagedObjectContext:context];
    notebook.name = name;
    notebook.creationDate = [NSDate date];
    notebook.modificationDate = [NSDate date];
    
    return notebook;
}

#pragma mark - KVO
-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    // De los cambios que se produzcan sólo me interesa que han cambiado para
    // actualizar la fecha de modificación
    self.modificationDate = [NSDate date];

}


@end
