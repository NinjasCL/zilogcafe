//
//  GlobalConstants.h
//  ZilogCafe
//
//  Created by Camilo on 10-10-13.
//
//

#import <Foundation/Foundation.h>

@interface GlobalConstants : NSObject

/*! Internal Memory Store Order Keys For Dictionary */

/*! The key for obtaining StoreOrder from Internal memory */
extern NSString * const kJUMPITTLastStoreOrderKey;

/*! The key for obtainning StoreOrder object from dictionary of intermal memory */
extern NSString * const kJUMPITTStoreOrderKey;

/*! The key for obtaining the current order count
 from the store order in internal memory */
extern NSString * const kJUMPITTStoreOrderCountKey;

/*! The hash part of the memory order */
extern NSString * const kJUMPITTInMemoryOrderHashKey;
/*! The Order object of the memory order */
extern NSString * const kJUMPITTInMemoryOrderOrderKey;

/*! Modifier Control Types */

/*! Shows an array of Items */
extern NSString * const kJUMPITTModifierControlTypeSingleSelectionShort;

/*! Shows a Single iTem of an array */
extern NSString * const kJUMPITTModifierControlTypeSingleSelectionLong;

/*! Order and StoreOrder status codes */

/*! An order that is saved, can be modified */
extern NSString * const kJUMPITTOrderStateWaitingPayment;

/*! No new store orders can be created if there is one with this state
 *  waits until webpay sends the confirmation of the deposit 
 *  was successfull.
 *  orders with this state can not be modified by the client
 */
extern NSString * const kJUMPITTOrderStateWaitingWebpayConfirmation;

/*! The payment was succesfull and it's waiting for the tablet to comence printing 
 *  orders with this state can not be modified by the client
 */
extern NSString * const kJUMPITTOrderStatePaidWaitingPrinting;


/*! The store order was printed, and we are waiting for the products to be made 
  *  orders with this state can not be modified by the client
 */
extern NSString * const kJUMPITTOrderStatePaidPrintedWaitingOrders;

/*! The order was paid, and printed, but was cancelled */
extern NSString * const kJUMPITTOrderStatePaidPrintedOrdersCancelled;

/*! The products are ready, waiting for the customer to confirm reception 
  *  orders with this state can not be modified by the client
 */
extern NSString * const kJUMPITTOrderStatePaidPrintedOrdersReadyWaitingCustomer;

/*! The store order was successfully delivered to the customer 
  *  orders with this state can not be modified by the client
 */
extern NSString * const kJUMPITTOrderStatePaidPrintedOrdersReadyCustomerDone;

/*! The store order was made, but the customer wasen't found 
  *  orders with this state can not be modified by the client
 */
extern NSString * const kJUMPITTOrderStatePaidPrintedOrdersReadyCustomerNotFound;

/*! Something was wrong, do not know why 
  *  orders with this state can not be modified by the client
 */
extern NSString * const kJUMPITTOrderStateUnknowError;

/*! Order State Notification when a StoreOrder was modified in server */
extern NSString * const kJUMPITTOrderStateChangedNotification;

@end
