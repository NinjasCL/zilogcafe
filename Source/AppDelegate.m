#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "GPGuardPost.h"

#import "GlobalConstants.h"

#import "NotificationHelper.h"

@implementation AppDelegate


#pragma mark - Badge
+ (void) setShoppingCartTabBadgeValue:(NSInteger) value {
    _badgeValue = value;
    
//    NSString * badge = [NSString stringWithFormat:@"%d", _badgeValue];
//    [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = @"1";

    
//    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:@"5"];

}

+ (NSString *) getBadgeValue {
    return [NSString stringWithFormat:@"%d", _badgeValue];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
     [Parse setApplicationId:@"WDkSqugqyMbH04RLwbLLTAj07ki7U7sSXQDnanc3" clientKey:@"AztNSw4JCbrZiiiKRKTnV52tQGKvY2yPMY3qBIuo"];
    //
    // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
    // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
    // [PFFacebookUtils initializeFacebook];
    // ****************************************************************************

    //[PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];

    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Override point for customization after application launch.
     


    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                    UIRemoteNotificationTypeAlert|
                                                    UIRemoteNotificationTypeSound];
    
    //[self style];
    
    // Set MailGun Api
    [GPGuardPost setPublicAPIKey:@"pubkey-12iy72o1purpy5ijecaycavoled0jep4"];
    
    // Extract the notification data
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
 
    NSString * state = [notificationPayload objectForKey:@"state"];
    
    if (state) {
        NSLog(@"Notificacion Recibida");
        [NotificationHelper postOrderStateChangedNotification];
    }
    
    // Create our Installation query
//    
//    PFQuery *pushQuery = [PFInstallation query];
//    
//    [pushQuery whereKey:@"user" equalTo:[PFUser currentUser]]; // Set channel
//
//    NSDictionary * data = @{@"state": kJUMPITTOrderStatePaidPrintedOrdersReadyWaitingCustomer, @"alert" : @"Pedido Listo Para Retirar"};
//    
//    // Send push notification to query
//    PFPush *push = [[PFPush alloc] init];
//    
//    [push setQuery:pushQuery];
//    
//    [push setData:data];
//    
////    [push setMessage:@"Giants scored against the A's! It's now 2-2."];
//    [push sendPushInBackground];

    return YES;
}

- (void) style {
    
    UINavigationController *navigationController = (UINavigationController *) self.window.rootViewController;
    
    UINavigationBar * navigationbar = navigationController.navigationBar;
    
    // rgb(44, 62, 80)
    [navigationbar setBackgroundColor:[UIColor colorWithRed:44.0 green:62.0 blue:80.0 alpha:1.0]];
    
}

/*
 
///////////////////////////////////////////////////////////
// Uncomment this method if you are using Facebook
///////////////////////////////////////////////////////////
 
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
} 
 
*/

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    
    NSLog(@"%@", newDeviceToken);
    
    PFInstallation * currentInstallation = [PFInstallation currentInstallation];
    
    if ([PFUser currentUser]) {
        
        currentInstallation[@"user"] = [PFUser currentUser];
    }
    
    [currentInstallation setDeviceTokenFromData:newDeviceToken];

    
    [currentInstallation saveEventually];
    
//    NSLog(@"%@", newDeviceToken);
    
//    [PFPush storeDeviceToken:newDeviceToken];
//
    [PFPush storeDeviceToken:newDeviceToken];
    [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
//    [PFPush handlePush:userInfo];
    


    if (application.applicationState != UIApplicationStateActive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString * state = [userInfo objectForKey:@"state"];
    
    NSLog(@"Notificacion Recibida");
    
    if (state) {
        NSLog(@"Recibida Notificacion de Cambio de Estado %@", state);
        
        [NotificationHelper postOrderStateChangedNotification];
        
        NSString * mesagge = @"";
        
        if ([state isEqualToString:kJUMPITTOrderStatePaidPrintedOrdersReadyWaitingCustomer]) {
            mesagge = @"Su pedido esta listo para retirar";
        } else if ([state isEqualToString:kJUMPITTOrderStatePaidPrintedWaitingOrders]) {
            mesagge = @"Su pedido ha comenzado a Prepararse";
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Zilog Cafe" message:mesagge delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}
#pragma mark - ()

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"Zilog successfully subscribed to push notifications on the broadcast channel.");

        
    } else {
        NSLog(@"Zilog failed to subscribe to push notifications on the broadcast channel. %@", error);
    }
}


@end
