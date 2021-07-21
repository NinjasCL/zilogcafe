//
//  GlobalConstants.m
//  ZilogCafe
//
//  Created by Camilo on 10-10-13.
//
//

#import "GlobalConstants.h"

@implementation GlobalConstants
NSString * const kJUMPITTLastStoreOrderKey = @"kJUMPITTLastStoreOrderKey";

/*! The key for obtainning StoreOrder object from dictionary of intermal memory */
NSString * const kJUMPITTStoreOrderKey = @"kJUMPITTStoreOrderKey";

/*! The key for obtaining the current order count
 from the store order in internal memory */
NSString * const kJUMPITTStoreOrderCountKey = @"kJUMPITTStoreOrderCountKey";

NSString * const kJUMPITTModifierControlTypeSingleSelectionShort = @"kJUMPITTModifierControlTypeSingleSelectionShort";

/*! The hash part of the memory order */
NSString * const kJUMPITTInMemoryOrderHashKey = @"kJUMPITTInMemoryOrderHashKey";

/*! The Order object of the memory order */
NSString * const kJUMPITTInMemoryOrderOrderKey = @"kJUMPITTInMemoryOrderOrderKey";

NSString * const kJUMPITTModifierControlTypeSingleSelectionLong = @"kJUMPITTModifierControlTypeSingleSelectionLong";

NSString * const kJUMPITTOrderStateWaitingPayment = @"kJUMPITTOrderStateWaitingPayment";



/*! No new store orders can be created if there is one with this state
 *  waits until webpay sends the confirmation of the deposit
 *  was successfull.
 *  orders with this state can not be modified by the client
 */
 NSString * const kJUMPITTOrderStateWaitingWebpayConfirmation = @"kJUMPITTOrderStateWaitingWebpayConfirmation";


/*! The payment was succesfull and it's waiting for the tablet to comence printing
 *  orders with this state can not be modified by the client
 */
 NSString * const kJUMPITTOrderStatePaidWaitingPrinting = @"kJUMPITTOrderStatePaidWaitingPrinting";


/*! The store order was printed, and we are waiting for the products to be made
 *  orders with this state can not be modified by the client
 */
 NSString * const kJUMPITTOrderStatePaidPrintedWaitingOrders = @"kJUMPITTOrderStatePaidPrintedWaitingOrders";

/*! */
 NSString * const kJUMPITTOrderStatePaidPrintedOrdersCancelled = @"kJUMPITTOrderStatePaidPrintedOrdersCancelled";

/*! The products are ready, waiting for the customer to confirm reception
 *  orders with this state can not be modified by the client
 */
 NSString * const kJUMPITTOrderStatePaidPrintedOrdersReadyWaitingCustomer = @"kJUMPITTOrderStatePaidPrintedOrdersReadyWaitingCustomer";

/*! The store order was successfully delivered to the customer */
 NSString * const kJUMPITTOrderStatePaidPrintedOrdersReadyCustomerDone = @"kJUMPITTOrderStatePaidPrintedOrdersReadyCustomerDone";

/*! The store order was made, but the customer wasen't found */
 NSString * const kJUMPITTOrderStatePaidPrintedOrdersReadyCustomerNotFound = @"kJUMPITTOrderStatePaidPrintedOrdersReadyCustomerNotFound";

/*! Something was wrong, do not know why */
 NSString * const kJUMPITTOrderStateUnknowError = @"kJUMPITTOrderStateUnknowError";

/*! Notification for State Changed */
NSString * const kJUMPITTOrderStateChangedNotification = @"kJUMPITTOrderStateChangedNotification";


@end
