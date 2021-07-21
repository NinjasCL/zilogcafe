//
//  FeaturableItem.h
//  JumpittProto4
//
//  Created by Camilo on 03-06-13.
//
//

#import "Item.h"
#import "CoreImage.h"
@interface FeaturableItem : Item
@property (nonatomic, assign) BOOL isFeatured;
@property (nonatomic, strong) PFRelation * featuredTimeRanges;
@property (nonatomic, strong) CoreImage * featuredImage;
@end
