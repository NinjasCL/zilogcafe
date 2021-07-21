//
//  SellableItem.h
//  JumpittProto4
//
//  Created by Camilo on 03-06-13.
//
//

#import "Item.h"

@interface SellableItem : Item
@property (nonatomic, assign) BOOL isEdible;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSNumber * estimatedPreparationTime;
@property (nonatomic, strong) NSNumber * maxQuantityPerOrder;
@end
