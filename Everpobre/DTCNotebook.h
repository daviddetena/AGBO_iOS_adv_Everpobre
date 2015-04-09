#import "_DTCNotebook.h"

@interface DTCNotebook : _DTCNotebook {}

#pragma mark - Factory methods
// Método de clase con nombre de la libreta y el contexto
+(instancetype) notebookWithName:(NSString *) name
                         context: (NSManagedObjectContext *) context;

@end
