// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DTCNote.h instead.

@import CoreData;
#import "DTCEverpobreBaseClass.h"

extern const struct DTCNoteAttributes {
	__unsafe_unretained NSString *creationDate;
	__unsafe_unretained NSString *modificationDate;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *text;
} DTCNoteAttributes;

extern const struct DTCNoteRelationships {
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *notebook;
	__unsafe_unretained NSString *photo;
} DTCNoteRelationships;

@class DTCLocation;
@class DTCNotebook;
@class DTCPhoto;

@interface DTCNoteID : NSManagedObjectID {}
@end

@interface _DTCNote : DTCEverpobreBaseClass {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DTCNoteID* objectID;

@property (nonatomic, strong) NSDate* creationDate;

//- (BOOL)validateCreationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* modificationDate;

//- (BOOL)validateModificationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DTCLocation *location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DTCNotebook *notebook;

//- (BOOL)validateNotebook:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DTCPhoto *photo;

//- (BOOL)validatePhoto:(id*)value_ error:(NSError**)error_;

@end

@interface _DTCNote (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreationDate;
- (void)setPrimitiveCreationDate:(NSDate*)value;

- (NSDate*)primitiveModificationDate;
- (void)setPrimitiveModificationDate:(NSDate*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (DTCLocation*)primitiveLocation;
- (void)setPrimitiveLocation:(DTCLocation*)value;

- (DTCNotebook*)primitiveNotebook;
- (void)setPrimitiveNotebook:(DTCNotebook*)value;

- (DTCPhoto*)primitivePhoto;
- (void)setPrimitivePhoto:(DTCPhoto*)value;

@end
