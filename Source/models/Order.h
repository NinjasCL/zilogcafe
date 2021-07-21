//
//  Order.h
//  ZilogCafe
//
//  Created by Camilo on 13-10-13.
//
//

#import "CoreItem.h"
#import "Product.h"
#import "Store.h"
#import "StoreOrder.h"

@interface Order : CoreItem
@property (nonatomic, strong) PFUser * user;
@property (nonatomic, strong) Product * product;
@property (nonatomic, strong) Store * store;
@property (nonatomic, strong) NSNumber * quantity;
@property (nonatomic, strong) NSNumber * subTotalPrice;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) PFRelation * selectedModifierValues;
@property (nonatomic, strong) StoreOrder * storeOrder;

@property (nonatomic, strong) NSString * hash;
@end
