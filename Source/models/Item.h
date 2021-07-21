//
//  Item.h
//  JumpittProto4
//
//  Created by Camilo on 02-06-13.
//
//

#import "CoreItem.h"
#import "Category.h"
#import "Tag.h"

@interface Item : CoreItem
@property (nonatomic, assign) BOOL isAvailable;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL isAdultsOnly;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) BOOL isRequired;
@property (nonatomic, strong) NSNumber * priority;
@property (nonatomic, strong) Category * category;
@property (nonatomic, strong) PFRelation * tags;
@end
