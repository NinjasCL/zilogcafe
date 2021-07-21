//
//  UtilityHelper.h
//  ZilogCafe
//
//  Created by Camilo on 06-10-13.
//
//

#import <Foundation/Foundation.h>

@interface UtilityHelper : NSObject
/*! Converts a Number to Chilean Currency */
+ (NSString *) numberToCurrency:(NSNumber *) number;

/*! Converts a Bool to Is Available Text */
+ (NSString *) isAvailableToString : (BOOL) isAvailable;


/*! Converts a Bool to Is Available Color */
+ (UIColor *) isAvailableToColor : (BOOL) isAvailable;


/*! Hashes an Object with MD5 */
+ (NSString *) getMD5Hash : (id) object;


/*! Get Random Verification Code for StoreOrder */
+ (NSNumber *) getRandomVerificationCode;


/*! Get an String from a Date */
+ (NSString *) stringFromDate : (NSDate *) date;

/*! Get an String from State */
+ (NSString *) stringFromState : (NSString *) state;

@end
