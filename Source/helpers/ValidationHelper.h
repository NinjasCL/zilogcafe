//
//  ValidationHelper.h
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import <Foundation/Foundation.h>

@interface ValidationHelper : NSObject
+ (BOOL) validateString:(NSString *) checkString withMinimumLength:(NSInteger) length;

+ (BOOL) validateString:(NSString *) checkString withMaximumLength:(NSInteger) length;

+ (BOOL) validateNotEmpty : (NSString *) checkString;

+ (BOOL) validateNotEmptyTrimmingSpaces : (NSString *) checkString;

+ (BOOL) validateEmail : (NSString *) email;

+ (void) validateEmailWithMailGun:(NSString *)email;

+ (BOOL) validatePassword : (NSString *) password;

+ (BOOL) validateUserFullName : (NSString *) userFullName;
@end
