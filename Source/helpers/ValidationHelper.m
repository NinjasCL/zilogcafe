//
//  ValidationHelper.m
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import "ValidationHelper.h"
#import "MessageHelper.h"
#import "NotificationHelper.h"
#import "GPGuardPost.h"

@implementation ValidationHelper
+ (BOOL) validateString:(NSString *) checkString withMinimumLength:(NSInteger) length {
    
    if (checkString.length < length) {
        return NO;
    }
    
    return YES;
}

+ (BOOL) validateString:(NSString *) checkString withMaximumLength:(NSInteger) length {

    if (checkString.length > length) {
        return NO;
    }
    
    return YES;
}


+ (BOOL) validateNotEmpty : (NSString *) checkString {
    
    
    if (checkString.length > 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL) validateNotEmptyTrimmingSpaces : (NSString *) checkString {
    
    // Trim String
    NSString *trimmedString = [checkString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    
    return [self validateNotEmpty:trimmedString];
}

+ (BOOL) validateEmail : (NSString *) email {
    // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    // From http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
    
    NSString * checkString = email;
    
    if (checkString.length <= 0) {
        [MessageHelper showEmailRequiredMessage];
        return NO;
    }
    
    
    BOOL stricterFilter = YES;
    
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL isEmailOK = [emailTest evaluateWithObject:checkString];
    
    if (!isEmailOK) {
        [MessageHelper showEmailNotValidMessage];
        return NO;
    }
    
    return isEmailOK;
}

#pragma message "TODO: Fix to apply KISS principle"
+ (void) validateEmailWithMailGun:(NSString *)email {

    
//    [GPGuardPost validateAddress:email success:^(BOOL validity, NSString *suggestion) {
//        
//        [NotificationHelper postMailgunVerificationFinished:[NSNumber numberWithBool:validity]];
//        
//        if (!validity) {
//            [MessageHelper showEmailNotValidMessage];
//        }
//    } failure:^(NSError *error) {
//        [MessageHelper showEmailNotValidMessage];
//    }];
//    
    
}

+ (BOOL) validatePassword : (NSString *) password {
    BOOL isValid = [self validateNotEmpty:password];
    
    if (isValid) {
        isValid = [self validateString:password withMinimumLength:8];
        
        if (!isValid) {
            [MessageHelper showPasswordNotValidMessage];
            return NO;
        }
        
    } else {
        [MessageHelper showPasswordRequiredMessage];
        return NO;
    }
    
    return YES;
}

+ (BOOL) validateUserFullName : (NSString *) userFullName {
    BOOL isValid = [self validateNotEmptyTrimmingSpaces:userFullName];

    if (!isValid) {
        [MessageHelper showUserFullNameRequiredMessage];
        return NO;
    }
    
    return YES;
}

@end
