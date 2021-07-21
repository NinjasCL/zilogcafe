//
//  Product.h
//  JumpittProto4
//
//  Created by Camilo on 03-06-13.
//
//

#import "StoreItem.h"

@interface Product : StoreItem
@property (nonatomic, strong) PFRelation * modifiers;

/*! Query Returning Methods */

/*! Return All products that are enabled */
+ (PFQuery *) getProductsQuery;

/*! Return All products that are enabled that belongs to a store */
+ (PFQuery *) getProductsInStoreQuery : (Store *) store;
@end
