//
//  Store.m
//  JumpittProto4
//
//  Created by Camilo on 02-06-13.
//
//

#import "Store.h"

@implementation Store
@dynamic currentQueueNumber;

@synthesize tabletUsers = _tabletUsers;
@synthesize products = _products;


#pragma mark - Relation Getters and Setters
- (void) setTabletUsers:(PFRelation *)tabletUsers {
    _tabletUsers = tabletUsers;
}

- (PFRelation *) tabletUsers {
    if (!_tabletUsers) {
        _tabletUsers = [self relationforKey:@"tabletUsers"];
    }
    
    return _tabletUsers;
}

- (void) setProducts:(PFRelation *)products {
    _products = products;
}

- (PFRelation *) products {
    if(!_products) {
        _products = [self relationforKey:@"products"];
    }
    
    return _products;
}


#pragma mark - Store Query Methods

+ (PFQuery *) getBaseQuery {
    PFQuery * query = [Store query];
    [query whereKey:@"isEnabled" equalTo:[NSNumber numberWithBool:YES]];
    
    return query;
}

+ (PFQuery *) getStoresQuery {
    PFQuery * query = [self getBaseQuery];
    
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
   
    // 1 day in seconds
    //query.maxCacheAge = 86400;
    
    return query;
}

+ (PFQuery *) getStoreByNameQuery: (NSString *) storeName {
    PFQuery * query = [self getBaseQuery];
    
    [query whereKey:@"displayName" containsString:storeName];

    // Just return 1 result
    query.limit = 1;
    
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    // 1 day in seconds
    //query.maxCacheAge = 86400;
    
    return query;
}



@end
