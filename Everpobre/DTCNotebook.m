#import "DTCNotebook.h"

@interface DTCNotebook ()

// Private interface goes here.

@end

@implementation DTCNotebook

+(instancetype) notebookWithName:(NSString *) name
                         context: (NSManagedObjectContext *) context{
    
    DTCNotebook *notebook = [self insertInManagedObjectContext:context];
    notebook.name = name;
    notebook.creationDate = [NSDate date];
    notebook.modificationDate = [NSDate date];
    
    return notebook;
}


@end
