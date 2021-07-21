//
//  UIColor+Hex.h
//  ZilogCafe
//
//  Created by Camilo on 06-10-13.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(UInt32)col;
+ (UIColor *)colorWithHexString:(NSString *)str;
@end
