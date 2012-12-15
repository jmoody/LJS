// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndClass.h instead.

#import <CoreData/CoreData.h>


extern const struct DndClassAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *key;
} DndClassAttributes;

extern const struct DndClassRelationships {
	__unsafe_unretained NSString *characters;
} DndClassRelationships;

extern const struct DndClassFetchedProperties {
} DndClassFetchedProperties;

@class DndCharacter;




@interface DndClassID : NSManagedObjectID {}
@end

@interface _DndClass : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DndClassID*)objectID;




@property (nonatomic, strong) NSString* displayName;


//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* key;


//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* characters;

- (NSMutableSet*)charactersSet;





@end

@interface _DndClass (CoreDataGeneratedAccessors)

- (void)addCharacters:(NSSet*)value_;
- (void)removeCharacters:(NSSet*)value_;
- (void)addCharactersObject:(DndCharacter*)value_;
- (void)removeCharactersObject:(DndCharacter*)value_;

@end

@interface _DndClass (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;




- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;





- (NSMutableSet*)primitiveCharacters;
- (void)setPrimitiveCharacters:(NSMutableSet*)value;


@end
