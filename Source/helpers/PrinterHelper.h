//
//  PrinterHelper.h
//  ZilogCafe
//
//  Created by Camilo on 18-10-13.
//
//

#import <Foundation/Foundation.h>
#import "PrinterFunctions.h"
#import "StoreOrder.h"
#import "Modifier.h"
#import "ModifierValue.h"
#import "Product.h"
#import "Order.h"

#import "UtilityHelper.h"
@interface PrinterHelper : NSObject

+ (void) printReceiptWithStoreOrder : (StoreOrder *) storeOrder;

@end
