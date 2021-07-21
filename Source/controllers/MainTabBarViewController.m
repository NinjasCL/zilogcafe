//
//  MainTabBarViewController.m
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import "MainTabBarViewController.h"
#import "StoreOrder.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController


- (void) viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * storeOrderDic = [defaults objectForKey:kJUMPITTLastStoreOrderKey];
    
    if ([[storeOrderDic allKeys] count] <= 0) {
        [self getLastStoreOrderInDatabase];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
}

// For updating the cart
- (void) getLastStoreOrderInDatabase {
    PFQuery * query = [StoreOrder query];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"state" equalTo:kJUMPITTOrderStateWaitingPayment];
    [query whereKeyExists:@"orderCount"];
    
    query.limit = 1;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary * storeOrderDic = [NSMutableDictionary dictionary];

        
        if (object) {
            
            //storeOrderDic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:kJUMPITTLastStoreOrderKey]];
            NSLog(@"Init with Order %@", object);
        
#pragma message "TODO: Make counting objects "
        
        NSNumber * count = object[@"orderCount"];

        
        if (!count) {
            count = [NSNumber numberWithInt:0];
        }
        
        [StoreOrder setTotalItemsInCurrentStoreOrder:[count integerValue]];

        NSLog(@"Count %@", count);
        
        [storeOrderDic setObject:object.objectId forKey:kJUMPITTStoreOrderKey];
        [storeOrderDic setObject:count forKey:kJUMPITTStoreOrderCountKey];
        
            
        } else {
            NSLog(@"Init with Dummy");
            [StoreOrder setTotalItemsInCurrentStoreOrder:0];

            [storeOrderDic setObject:@"dummy" forKey:kJUMPITTStoreOrderKey];
            [storeOrderDic setObject:[NSNumber numberWithInteger:0] forKey:kJUMPITTStoreOrderCountKey];
            
        }

        
        [defaults setObject:storeOrderDic forKey:kJUMPITTLastStoreOrderKey];

        [defaults synchronize];
        
    }];
}

@end
