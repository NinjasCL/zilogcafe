//
//  CoreItem.h
//  JumpittProto4
//
//  Created by Camilo on 02-06-13.
//
//

#import "ParseClass.h"
//#import "CoreImage.h"

@interface CoreItem : ParseClass
@property (nonatomic, strong) NSString  * displayName;
@property (nonatomic, strong) NSString * displayDescription;
@property (nonatomic, strong) PFFile * displayImage;

/*! For internal cache only */
@property (nonatomic, strong) UIImage * image;
@end
