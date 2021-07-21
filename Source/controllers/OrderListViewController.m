//
//  OrderListViewController.m
//  ZilogCafe
//
//  Created by Camilo on 16-11-13.
//
//

#import "OrderListViewController.h"

#import "StoreOrderListViewController.h"

#import "StoreOrder.h"

#import "AppDelegate.h"

@interface OrderListViewController ()

@property (weak, nonatomic) IBOutlet UILabel * inProgressNumber;

@property (weak, nonatomic) IBOutlet UILabel * readyNumber;

@property (nonatomic) NSInteger  inProgressCounter;

@property (nonatomic) NSInteger waitingCustomerCounter;

@property (weak, nonatomic) IBOutlet UILabel *waitingPrinter;

@property (nonatomic) NSInteger waitingPrinterCounter;

@end

@implementation OrderListViewController

- (void) viewWillAppear:(BOOL)animated {
    self.readyNumber.text = [NSString stringWithFormat:@"%d", self.waitingCustomerCounter];
    
    self.inProgressNumber.text = [NSString stringWithFormat:@"%d", self.inProgressCounter];
    
    self.waitingPrinter.text = [NSString stringWithFormat:@"%d", self.waitingPrinterCounter ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderState:) name:kJUMPITTOrderStateChangedNotification object:nil];
    
    [self refresh:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) updateOrderState: (NSNotification *) notification {
    [self refresh:nil];
}

- (void) updateTabBarBadge {
    
    [AppDelegate setShoppingCartTabBadgeValue:0];
    
    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
}

- (IBAction)refresh:(id)sender {
    [self countPendingOrders];
    
    [self countReadyOrders];
    
    [self countPrinterOrders];
}

- (void) countPrinterOrders {
    PFQuery * printerQuery = [StoreOrder getWaitingPrinterOrders];
    [SVProgressHUD show];
    
    [printerQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        
        self.waitingPrinterCounter = number;
        
        self.waitingPrinter.text = [NSString stringWithFormat:@"%d", self.waitingPrinterCounter ];
                
        NSLog(@"Count Waiting Printer Orders %d", number);
        
        [SVProgressHUD dismiss];
    }];
    
}
- (void) countPendingOrders {
    PFQuery * pendingQuery = [StoreOrder getPrintedWaitingStoreOrders];
    [SVProgressHUD show];
    
    [pendingQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            self.inProgressNumber.text = [NSString stringWithFormat:@"%d", number];
        
            self.inProgressCounter = number;
        
            NSLog(@"Count Waiting Orders %d", number);
                
            [SVProgressHUD dismiss];
    }];
}

- (void) countReadyOrders {
    PFQuery * readyQuery = [StoreOrder getWaitingCustomerStoreOrders];
    
    [SVProgressHUD show];
    [readyQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.readyNumber.text = [NSString stringWithFormat:@"%d", number];
        
        self.waitingCustomerCounter = number;
        
        NSLog(@"Count Waiting Customer %d", number);
        
        [SVProgressHUD dismiss];
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString  * segueIdentifier = segue.identifier;
    
    StoreOrderListViewController * controller = segue.destinationViewController;

    controller.listType = segueIdentifier;
    
//    if ([segueIdentifier isEqualToString:@"waitingOrders"]) {
//    
//            controller.listType = @"waitingOrders";
//    
//    } else if ([segueIdentifier isEqualToString:@"readyOrders"]) {
//        
//            controller.listType = @"readyOrders";
//
//    } else if ([segueIdentifier isEqualToString:@"completedOrders"]) {
//        
//            controller.listType = @"completedOrders";
//        
//    } else if ([segueIdentifier isEqualToString:@"printerOrders"]) {
//             controller.listType = @"printerOrders";
//    }
    
    
}

@end
