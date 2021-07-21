//
//  Item.m
//  JumpittProto4
//
//  Created by Camilo on 02-06-13.
//
//

#import "Item.h"

@implementation Item
@dynamic isAvailable;
@dynamic isEnabled;
@dynamic isAdultsOnly;
@dynamic isRequired;
@dynamic isDefault;
@dynamic priority;
@dynamic category;

@synthesize tags = _tags;

- (void) setTags:(PFRelation *)tags {
    _tags = tags;
}

- (PFRelation *) tags {
    if (!_tags) {
        _tags = [self relationforKey:@"tags"];
    }
    
    return _tags;
}

@end
