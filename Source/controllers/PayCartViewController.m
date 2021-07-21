//
//  PayCartViewController.m
//  ZilogCafe
//
//  Created by Camilo on 19-11-13.
//
//

#import "PayCartViewController.h"

#import "UtilityHelper.h"

#import "AppDelegate.h"

@interface PayCartViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (nonatomic) BOOL  paymentDone;
@end

@implementation PayCartViewController

- (void) viewWillAppear:(BOOL)animated {
    self.totalPrice.text = [UtilityHelper numberToCurrency:self.storeOrder[@"totalPrice"]];
}

#pragma message " Tratar de hacerlo DRY"

- (void) updateTabBarBadge {
    NSInteger badge = [[AppDelegate getBadgeValue] integerValue];
    badge++;
    
    [AppDelegate setShoppingCartTabBadgeValue:badge];
    NSString * badgeValue = [NSString stringWithFormat:@"%d", badge];
    
    NSLog(@"badge Value %@", badgeValue);

//    [[[[[self tabBarController] tabBar] items]
//      objectAtIndex:1] setBadgeValue:badgeValue];
    
//    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:badgeValue];

    
    UITabBarItem * item = [[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem];
    
    item.badgeValue = badgeValue;
    
//    [[self.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = badgeValue;

}

- (IBAction)payCart:(id)sender {
    NSLog(@"PayCart %@", self.storeOrder);
    
    self.storeOrder.state = kJUMPITTOrderStatePaidWaitingPrinting;
    
    [SVProgressHUD show];
    
    PFRelation * ordersRelation = self.storeOrder.orders;
    PFQuery * ordersQuery = [ordersRelation query];
    
    [ordersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject * order in objects) {
            order[@"state"] = kJUMPITTOrderStatePaidWaitingPrinting;
            
            [order saveEventually];
        }
    }];
    
    [self.storeOrder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"Pagado,  Espere Alerta de Retiro"];
            
            [self.delegate payCartSucceded];
            
            self.paymentDone = YES;
            
            [self updateTabBarBadge];
            
            [self close:nil];
        }
    }];
}


- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // Somethinng
        
        if (self.paymentDone) {
            [self.delegate payCartClosedAndSuccessfullyPaid];
        } else {
            [self.delegate payCartClosed];
        }
        
    }];
}



@end
