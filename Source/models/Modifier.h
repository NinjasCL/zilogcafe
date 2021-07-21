//
//  Modifier.h
//  JumpittProto4
//
//  Created by Camilo on 03-06-13.
//
//

#import "Item.h"
#import "Product.h"
#import "ModifierValue.h"

@interface Modifier : Item
@property (nonatomic, strong) NSString * controlType;
@property (nonatomic, strong) Product * product;
@property (nonatomic, strong) ModifierValue * defaultValue;
@property (nonatomic, strong) PFRelation * values;

/*! Returns a Query for obtaining modifiers associated with a product */
+ (PFQuery *) getModifiersForProductQuery : (Product *) product;

@end
