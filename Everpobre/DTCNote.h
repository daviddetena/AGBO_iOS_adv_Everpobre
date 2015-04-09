#import "_DTCNote.h"

@interface DTCNote : _DTCNote {}

#pragma mark - Factory Methods

// Nota con nombre, su libreta y el contexto
+(instancetype) noteWithName: (NSString *)name notebook: (DTCNotebook *)notebook context:(NSManagedObjectContext *)context;

@end
