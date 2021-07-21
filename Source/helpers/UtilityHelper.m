//
//  UtilityHelper.m
//  ZilogCafe
//
//  Created by Camilo on 06-10-13.
//
//

#import "UtilityHelper.h"
#import "ColorHelper.h"

#import <CommonCrypto/CommonDigest.h>

@implementation UtilityHelper
+ (NSString *) numberToCurrency:(NSNumber *) number {
    //return [NSString stringWithFormat:@"$%@", number];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];

    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"es_CL"]];
    
    NSString *formattedString = [numberFormatter stringFromNumber:number];
    
    return formattedString;
}

+ (NSString *) isAvailableToString : (BOOL) isAvailable {
    if (isAvailable) {
        return @"Disponible";
    }
    
    return @"No Disponible";
}

+ (UIColor *) isAvailableToColor : (BOOL) isAvailable {
    if (isAvailable) {
        return [ColorHelper nephritis];
    }
    
    return [ColorHelper alizarin];
}

// Return the Md5 of a String
// internal use only
+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

// Return the Md5 of an Object
+ (NSString *) getMD5Hash:(id)object {
    NSString * objectString = [NSString stringWithFormat:@"%@",object];
    return [self md5:objectString];
}


/*! Get Random Verification Code for StoreOrder */
+ (NSNumber *) getRandomVerificationCode {
    int min = 1000;
    int max = 10000;
    
    // Random Number from 1000 to 9999
    int randNum = arc4random() % (max - min) + min;

    return [NSNumber numberWithInt:randNum];
}

/*! Get an String from a Date */
+ (NSString *) stringFromDate : (NSDate *) date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSLog(@"Date %@  \n Date Formatted: %@", date, [dateFormatter stringFromDate:date])
    [dateFormatter setDateFormat:@"dd/MM/yy"];
    
    return [dateFormatter stringFromDate:date];
}

/*! Get an String from State */
+ (NSString *) stringFromState : (NSString *) state {
    
    if ([state isEqualToString:kJUMPITTOrderStatePaidPrintedWaitingOrders]) {
        return @"En Proceso";
    } else if([state isEqualToString:kJUMPITTOrderStatePaidPrintedOrdersReadyWaitingCustomer]) {
        return @"Para Retirar";
    } else if([state isEqualToString:kJUMPITTOrderStatePaidWaitingPrinting]) {
        return @"Imprimiendo";
    }
    
    
    return @"Finalizado";
    
    
}
@end
