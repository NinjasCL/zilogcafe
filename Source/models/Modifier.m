//
//  Modifier.m
//  JumpittProto4
//
//  Created by Camilo on 03-06-13.
//
//

#import "Modifier.h"

@implementation Modifier

@dynamic controlType;
@dynamic product;
@dynamic defaultValue;

@synthesize values = _values;

- (void) setValues:(PFRelation *)values {
    _values = values;
}

- (PFRelation *) values {
    if (!_values) {
        _values = [self relationforKey:@"values"];
    }
    
    return  _values;
}

+ (PFQuery *) getBaseQuery {
    PFQuery * query = [Modifier query];
    
    return query;
}

+ (PFQuery *) getModifiersForProductQuery : (Product *) product {
    PFQuery * query = [product.modifiers query];
    
    [query includeKey:@"defaultValue"];
    [query whereKeyExists:@"defaultValue"];
    [query orderByAscending:@"priority"];
    [query addAscendingOrder:@"displayName"];
    
    return query;
}
@end
