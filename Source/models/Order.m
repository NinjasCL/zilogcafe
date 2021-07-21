//
//  Order.m
//  ZilogCafe
//
//  Created by Camilo on 13-10-13.
//
//

#import "Order.h"

@implementation Order
@dynamic user;
@dynamic product;
@dynamic store;
@dynamic quantity;
@dynamic subTotalPrice;
@dynamic state;
@dynamic storeOrder;
@dynamic hash;

@synthesize selectedModifierValues = _selectedModifierValues;

- (PFRelation *) selectedModifierValues {
    if (!_selectedModifierValues) {
        _selectedModifierValues = [self relationforKey:@"selectedModifierValues"];
    }
    
    return  _selectedModifierValues;
}

+ (PFQuery *) getBaseQuery {
    PFQuery * query = [Order query];
    
    return query;
}

@end
