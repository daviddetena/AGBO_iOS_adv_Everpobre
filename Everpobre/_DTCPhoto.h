// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DTCPhoto.h instead.

@import CoreData;

extern const struct DTCPhotoAttributes {
	__unsafe_unretained NSString *photoData;
} DTCPhotoAttributes;

extern const struct DTCPhotoRelationships {
	__unsafe_unretained NSString *notes;
} DTCPhotoRelationships;

@class DTCNote;

@interface DTCPhotoID : NSManagedObjectID {}
@end

@interface _DTCPhoto : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DTCPhotoID* objectID;

@property (nonatomic, strong) NSData* photoData;

//- (BOOL)validatePhotoData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *notes;

- (NSMutableSet*)notesSet;

@end

@interface _DTCPhoto (NotesCoreDataGeneratedAccessors)
- (void)addNotes:(NSSet*)value_;
- (void)removeNotes:(NSSet*)value_;
- (void)addNotesObject:(DTCNote*)value_;
- (void)removeNotesObject:(DTCNote*)value_;

@end

@interface _DTCPhoto (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitivePhotoData;
- (void)setPrimitivePhotoData:(NSData*)value;

- (NSMutableSet*)primitiveNotes;
- (void)setPrimitiveNotes:(NSMutableSet*)value;

@end
