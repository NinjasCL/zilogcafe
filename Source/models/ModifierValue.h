//
//  ModifierValue.h
//  JumpittProto4
//
//  Created by Camilo on 03-06-13.
//
//

#import "SellableItem.h"
#import "Product.h"

@interface ModifierValue : SellableItem

@property (nonatomic, strong) Product * product;
@property (nonatomic, strong) PFObject * modifier;

@end
