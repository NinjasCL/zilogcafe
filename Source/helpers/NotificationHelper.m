//
//  NotificationHelper.m
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import "NotificationHelper.h"

@implementation NotificationHelper
NSString * const kJUMPITTNotificationMessage = @"kJUMPITTNotificationMessage";

NSString * const kJUMPITTNotificationMailgunEmailValidationFinished = @"kJUMPITTNotificationMailgunEmailValidationFinished";

#pragma mark - Generic Notification Methods
+ (void) postNotificationWithName:(NSString *) notificationName {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}

+ (void) postNotificationWithName : (NSString *) notificationName andUserInfo: (NSDictionary *) userInfo {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];
    
}

+ (void) postNotificationWithMessage : (NSString *) message andName: (NSString *) notificationName {
    
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:message forKey:kJUMPITTNotificationMessage];
    
    [self postNotificationWithName:notificationName andUserInfo:userInfo];
}

+ (void) postNotificationWithMessage : (NSString *) message andName : (NSString *) notificationName andUserInfo: (NSDictionary *) userInfo {
    
    NSMutableDictionary * userInfoWithMessage = [userInfo copy];
    
    [userInfoWithMessage setObject:message forKey:kJUMPITTNotificationMessage];
    
    [self postNotificationWithName:notificationName andUserInfo:userInfoWithMessage];
}

+ (void) postOrderStateChangedNotification {
    [self postNotificationWithName:kJUMPITTOrderStateChangedNotification];
}

@end
