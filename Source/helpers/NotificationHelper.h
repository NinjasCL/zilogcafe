//
//  NotificationHelper.h
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import <Foundation/Foundation.h>

@interface NotificationHelper : NSObject
extern NSString * const kJUMPITTNotificationMessage;
extern NSString * const kJUMPITTNotificationMailgunEmailValidationFinished;

/*! Notification Methods */
+ (void) postNotificationWithName:(NSString *) notificationName;

+ (void) postNotificationWithMessage : (NSString *) message andName: (NSString *) notificationName;

+ (void) postNotificationWithMessage : (NSString *) message andName : (NSString *) notificationName andUserInfo: (NSDictionary *) userInfo;

/*! Post a notification when an StoreOrder have changed their state */
+ (void) postOrderStateChangedNotification;

@end
