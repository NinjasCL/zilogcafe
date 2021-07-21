//
//  CoreImage.h
//  JumpittProto4
//
//  Created by Camilo on 04-06-13.
//
//

#import "ParseClass.h"

@interface CoreImage : ParseClass
@property (nonatomic, strong) PFFile * displayImage;
@property (nonatomic, strong) PFFile * displayImageThumbnail;
@end
