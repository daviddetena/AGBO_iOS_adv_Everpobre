#import "DTCNote.h"
#import "DTCPhoto.h"

@interface DTCNote ()

// Private interface goes here.

@end

@implementation DTCNote

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

@end
