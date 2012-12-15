// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndRole.h instead.

#import <CoreData/CoreData.h>


extern const struct DndRoleAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *key;
} DndRoleAttributes;

extern const struct DndRoleRelationships {
	__unsafe_unretained NSString *characters;
} DndRoleRelationships;

extern const struct DndRoleFetchedProperties {
} DndRoleFetchedProperties;

@class DndCharacter;




@interface DndRoleID : NSManagedObjectID {}
@end

@interface _DndRole : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DndRoleID*)objectID;




@property (nonatomic, strong) NSString* displayName;


//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* key;


//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* characters;

- (NSMutableSet*)charactersSet;





@end

@interface _DndRole (CoreDataGeneratedAccessors)

- (void)addCharacters:(NSSet*)value_;
- (void)removeCharacters:(NSSet*)value_;
- (void)addCharactersObject:(DndCharacter*)value_;
- (void)removeCharactersObject:(DndCharacter*)value_;

@end

@interface _DndRole (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;




- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;





- (NSMutableSet*)primitiveCharacters;
- (void)setPrimitiveCharacters:(NSMutableSet*)value;


@end
