//
//  Product.m
//  JumpittProto4
//
//  Created by Camilo on 03-06-13.
//
//

#import "Product.h"
#import "Store.h"

@implementation Product



@synthesize modifiers = _modifiers;

- (void) setModifiers:(PFRelation *)modifiers {
    _modifiers = modifiers;
}

- (PFRelation *) modifiers {
    if (!_modifiers) {
        _modifiers = [self relationforKey:@"modifiers"];
    }
    
    return _modifiers;
}

#pragma mark - Product Query Methods

// Query that is the base for all the others
+ (PFQuery *) getBaseQuery {
    PFQuery * query = [Product query];
    
    [query whereKey:@"isEnabled" equalTo:[NSNumber numberWithBool:YES]];
    
    return query;
}

+ (PFQuery *) getProductsQuery {
    PFQuery * query = [self getBaseQuery];
    
    [query orderByAscending:@"price"];
    [query addAscendingOrder:@"displayName"];
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    // 60 seconds
    //query.maxCacheAge = 60;
    
    return query;
}

+ (PFQuery *) getProductsInStoreQuery : (Store *) store {
  
    PFQuery * query = [self getBaseQuery];
  
    [query whereKey:@"store" equalTo:store];
    
    
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    // 60 seconds
    //query.maxCacheAge = 60;
    
    return query;
    
}
@end
