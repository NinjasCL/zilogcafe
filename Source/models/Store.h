//
//  Store.h
//  JumpittProto4
//
//  Created by Camilo on 02-06-13.
//
//

#import "Item.h"

@interface Store : Item
@property (nonatomic, strong) PFRelation * tabletUsers;
@property (nonatomic, strong) NSNumber * currentQueueNumber;
@property (nonatomic, strong) PFRelation * products;


/*! Store Query Methods */

/*! Get all Stores */
+ (PFQuery *) getStoresQuery;

/*! Get a Store by Name 
    param NSString * storeName
 */
+ (PFQuery *) getStoreByNameQuery: (NSString *) storeName;
@end
