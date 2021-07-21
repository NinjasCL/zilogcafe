//
//  StoreOrder.m
//  ZilogCafe
//
//  Created by Camilo on 13-10-13.
//
//

#import "StoreOrder.h"

@implementation StoreOrder
@dynamic user;
@dynamic isVerified;
@dynamic store;
@dynamic state;
@dynamic totalPrice;
@dynamic userQueueNumber;
@dynamic verificationCode;
@dynamic orderCount;
@dynamic orderNumber;

@synthesize orders = _orders;

static int _totalItemsInCart = 0;

- (PFRelation *) orders {
    if (!_orders) {
        _orders = [self relationforKey:@"orders"];
    }
    
    return _orders;
}

+ (PFQuery *) getBaseQuery {
    PFQuery * query = [self query];
    
    return query;
}

+ (void) setTotalItemsInCurrentStoreOrder : (NSInteger) itemCount {
    _totalItemsInCart = itemCount;
}

+ (NSNumber *) getTotalItemsInCurrentStoreOrder {
    return [NSNumber numberWithInteger:_totalItemsInCart];
}

/*! Returns if can create a new StoreOrder */
+ (PFQuery *) getCanCreateANewStoreOrderQuery {
    
    PFQuery * query = [self getBaseQuery];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser] ];
    
    /*
     If there is an StoreOrder with Waiting WebPay, we cannot create a new one
     until that changes to waitingPayment or WaitingPrinter
     */
    
    [query whereKey:@"state" equalTo:kJUMPITTOrderStateWaitingWebpayConfirmation];
    
    //query.limit = 1;
    
    return query;
    
}

/*! Get current StoreOrder */



+ (PFQuery *) getCurrentEditableStoreOrder {
    PFQuery * query = [self getBaseQuery];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query whereKey:@"state" equalTo:kJUMPITTOrderStateWaitingPayment];
    
    query.limit = 1;
    
    return query;
}

/*! Get orders that are not printed yet */
+ (PFQuery *) getWaitingPrinterOrders {
    PFQuery * query = [self getBaseQuery];
    
   [query whereKey:@"user" equalTo:[PFUser currentUser]];

   [query whereKey:@"state" equalTo:kJUMPITTOrderStatePaidWaitingPrinting];
    
    return query;
}

/*! Get store orders waiting for the orders to be ready */
+ (PFQuery *) getPrintedWaitingStoreOrders {
    PFQuery * query = [self getBaseQuery];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query whereKey:@"state" equalTo:kJUMPITTOrderStatePaidPrintedWaitingOrders];
    
    return query;
}

/*! Get store orders waiting for user (ready for pickup) */
+ (PFQuery *) getWaitingCustomerStoreOrders {
    PFQuery * query = [self getBaseQuery];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query whereKey:@"state" equalTo:kJUMPITTOrderStatePaidPrintedOrdersReadyWaitingCustomer];
    
    return query;
}


/*! Get store orders customer done (historial) */
+ (PFQuery *) getCustomerDoneStoreOrders {
    PFQuery * query = [self getBaseQuery];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query whereKey:@"state" equalTo:kJUMPITTOrderStatePaidPrintedOrdersReadyCustomerDone];
    
    return query;
}

/*! Get historial store orders */
+ (PFQuery *) getHistorialStoreOrders {
    PFQuery * query = [self getBaseQuery];
   
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query whereKey:@"state" containedIn:@[kJUMPITTOrderStatePaidPrintedOrdersReadyCustomerDone, kJUMPITTOrderStatePaidPrintedOrdersCancelled, kJUMPITTOrderStateUnknowError]];
    
    return query;
}


@end
