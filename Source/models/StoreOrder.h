//
//  StoreOrder.h
//  ZilogCafe
//
//  Created by Camilo on 13-10-13.
//
//

#import "UtilityHelper.h"
#import "CoreItem.h"
#import "Store.h"

/*! Saves the cart */
@interface StoreOrder : CoreItem
@property (nonatomic, strong) PFUser * user;
@property (nonatomic, strong) PFRelation * orders;
@property (nonatomic, assign) BOOL isVerified;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) Store * store;
@property (nonatomic, strong) NSNumber * totalPrice;
@property (nonatomic, strong) NSNumber * userQueueNumber;
@property (nonatomic, strong) NSNumber * verificationCode;
@property (nonatomic, strong) NSNumber * orderCount;
@property (nonatomic, strong) NSNumber * orderNumber;

/*! Returns if can create a new StoreOrder */
+ (PFQuery *) getCanCreateANewStoreOrderQuery;

/*! Get current StoreOrder */
+ (PFQuery *) getCurrentEditableStoreOrder;

/*! Get orders that are not printed yet */
+ (PFQuery *) getWaitingPrinterOrders;

/*! Get store orders waiting to be ready */
+ (PFQuery *) getPrintedWaitingStoreOrders;

/*! Get store orders waiting for user to confirm */
+ (PFQuery *) getWaitingCustomerStoreOrders;

/*! Get store orders customer done */
+ (PFQuery *) getCustomerDoneStoreOrders;

/*! Get all historial store orders */
+ (PFQuery *) getHistorialStoreOrders;

+ (void) setTotalItemsInCurrentStoreOrder : (NSInteger) itemCount;

+ (NSNumber *) getTotalItemsInCurrentStoreOrder;


@end
