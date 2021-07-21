//
//  FeaturableItem.m
//  JumpittProto4
//
//  Created by Camilo on 03-06-13.
//
//

#import "FeaturableItem.h"

@implementation FeaturableItem
@dynamic isFeatured;
@dynamic featuredImage;

@synthesize featuredTimeRanges = _featuredTimeRanges;

- (void) setFeaturedTimeRanges:(PFRelation *)featuredTimeRanges {
    _featuredTimeRanges = featuredTimeRanges;
}

- (PFRelation *) featuredTimeRanges {
    if (!_featuredTimeRanges) {
        _featuredTimeRanges = [self relationforKey:@"featuredTimeRanges"];
    }
    
    return _featuredTimeRanges;
    
}
@end
