//
//  StoreItem.h
//  JumpittProto4
//
//  Created by Camilo on 03-06-13.
//
//

#import "SellableItem.h"
#import "Store.h"
@interface StoreItem : SellableItem
@property (nonatomic, strong) Store * store;
@end
