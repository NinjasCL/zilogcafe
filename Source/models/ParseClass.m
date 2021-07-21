//
//  ParseClass.m
//  JumpittProto4
//
//  Created by Camilo on 02-06-13.
//
//

#import "ParseClass.h"
#import <Parse/PFObject+Subclass.h>
@implementation ParseClass
+ (void)initialize {
    [super initialize];
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass(self);
}
@end
