//
//  PrinterHelper.m
//  ZilogCafe
//
//  Created by Camilo on 18-10-13.
//
//

#import "PrinterHelper.h"

@implementation PrinterHelper

static NSString * portName = @"";
static NSString * portNumber = @"";
static NSString * portSettings = @"";
static NSString * drawerPortName = @"";

#pragma mark getter/setter

+ (NSString*)portName
{
    return portName;
}

+ (void)setPortName:(NSString *)m_portName
{
    if (portName != m_portName) {
        portName = [m_portName copy];
    }
}

+ (NSString *)portSettings
{
    return portSettings;
}

+ (void)setPortSettings:(NSString *)m_portSettings
{
    if (portSettings != m_portSettings) {
        portSettings = [m_portSettings copy];
    }
}

+ (NSString *)drawerPortName {
    return drawerPortName;
}

+ (void)setDrawerPortName:(NSString *)portName {
    if (drawerPortName != portName) {
        drawerPortName = [portName copy];
    }
}

#pragma mark - Print Function
+ (void)print3Inch:(NSString *) textToPrint {
    int width = 576;
    
    NSString *fontName = @"Courier";
    
    double fontSize = 12.0;
    
    //  fontSize *= multiple;
    fontSize *= 2;
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    CGSize size = CGSizeMake(width, 10000);
    CGSize messuredSize = [textToPrint sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
	
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			UIGraphicsBeginImageContextWithOptions(messuredSize, NO, 1.0);
		} else {
			UIGraphicsBeginImageContext(messuredSize);
		}
	} else {
		UIGraphicsBeginImageContext(messuredSize);
	}
    
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    UIColor *color = [UIColor whiteColor];
    [color set];
    
    CGRect rect = CGRectMake(0, 0, messuredSize.width + 1, messuredSize.height + 1);
    CGContextFillRect(ctr, rect);
    
    color = [UIColor blackColor];
    [color set];
    
    [textToPrint drawInRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping];
    
    UIImage *imageToPrint = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [PrinterFunctions PrintImageWithPortname:portName portSettings:portSettings imageToPrint:imageToPrint maxWidth:width compressionEnable:YES withDrawerKick:YES];
}

/*! 
 * Sends an StoreOrder to the Printer and then changes its status 
 * to waiting product
 */

+ (void) printReceiptWithStoreOrder : (StoreOrder *) storeOrder {
    
    /** EXAMPLE RECEIPT
     
    ========    ZilogCafe    =========
     
           18/10/2013 17:20:39
     
             # Orden : 3021
     
     ---------------------------------
     Cafe Espresso                $900
     
     - Tamaño : Doble           + $200
    
          Cantidad :                 2
          Subtotal :            $2.200
     ---------------------------------
     Capuccino                  $1.200
     
     - Tamaño : Sencillo         +  $0
     - Tipo de Leche : Soya      + 300
     
          Cantidad :                 1
          Subtotal :            $1.500
     =================================
               TOTAL: $3.700
     =================================
     
     Nombre :            Marcos Amador
     
     # Verificador :              9242
     
     ---------------------------------
        Gracias por su preferencia
     
     
     
     */
    
    [SVProgressHUD showWithStatus:@"Imprimiendo"];
    
//    [storeOrder.user fetchIfNeeded];
//    [storeOrder.store fetchIfNeeded];
    PFUser * user = storeOrder[@"user"];
    
    Store * store = storeOrder[@"store"];
    [store fetchIfNeeded];
    
    NSString * __block receiptHeader = @"";
    NSString * __block receiptFooter = @"";
    
    [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        //"          DD/MM/YYY    HH:MM \r\n\r\n"

        receiptHeader = [NSString stringWithFormat:
                                    @"\r\n    ========    Zilog Cafe    ========= \r\n"
                                    "\t\t%@\r\n\r\n"
                                    " \t\t\t  # ORDEN :\t%10@ \r\n\r\n",
                                    [NSDate date], storeOrder.orderNumber];
        
        receiptFooter = [NSString stringWithFormat:
                                    @"     =================================\r\n"
                                    "               TOTAL: %@\r\n"
                                    "     =================================\r\n"
                                    "     Nombre :\t\t%10@\r\n"
                                    "     # Verificador : \t\t%10@\r\n"
                                    "     ---------------------------------\r\n"
                                    "        Gracias por su preferencia\r\n",
                                    
                                    [UtilityHelper numberToCurrency:storeOrder.totalPrice],
                                    user[@"fullName"],
                                    storeOrder.verificationCode];
        
        NSMutableString   * receiptBody = [NSMutableString string];
        
        // get the orders
        //    PFQuery * ordersQuery = [storeOrder.orders query];
        //    [ordersQuery includeKey:@"product"];
        
        PFRelation * ordersRelation = [storeOrder relationforKey:@"orders"];
        
        PFQuery * ordersQuery = [ordersRelation query];
        [ordersQuery includeKey:@"product"];
        [ordersQuery orderByAscending:@"product"];
        
        //NSArray * orders = [ordersQuery findObjects];
        
        [ordersQuery findObjectsInBackgroundWithBlock:^(NSArray * orders, NSError *error) {
            // now we have the orders, for each
            // get the product and its selected modifiers values
            
            NSLog(@"%@", orders);
            
            for (Order * order in orders) {
                //NSLog(@"%@", order);
                //[order fetchIfNeeded];
                [receiptBody appendString:@"     ---------------------------------\r\n"];
                //            Order * order = (Order *) _order;
                
                Product * product = order[@"product"];
                [product fetchIfNeeded];
                
                // Product
                [receiptBody appendString:[NSString stringWithFormat:@"\t\t\t %10@ \t %10@\r\n", product[@"displayName"], [UtilityHelper numberToCurrency:product[@"price"]]]];
                
                //            PFQuery * selectedModifierValuesQuery = [order.selectedModifierValues query];
                
                PFRelation  * selectedModifierValues = [order relationforKey:@"selectedModifierValues"];
                
                PFQuery * selectedModifierValuesQuery = [selectedModifierValues query];
                
                [selectedModifierValuesQuery includeKey:@"modifier"];
                
                // Must values have to continue
                NSArray * values = [selectedModifierValuesQuery findObjects];
                
                
                [receiptBody appendString:@"\r\n"];
                
                
                NSLog(@"%@", values);
                
                //            [selectedModifierValuesQuery findObjectsInBackgroundWithBlock:^(NSArray * values, NSError *error) {
                for (ModifierValue * modifierValue in values) {
                    
                    Modifier * modifier = (Modifier *) modifierValue[@"modifier"];
                    
                    // Modifiers
                    [receiptBody appendString:[NSString stringWithFormat:@"     - %10@ \r\n\t\t %20@\t+ %10@\r\n\r\n", modifier[@"displayName"], modifierValue[@"displayName"], [UtilityHelper numberToCurrency:modifierValue[@"price"]]]];
                    
                    
                }
                
                [receiptBody appendString:@"\r\n"];
                
                // Quantity
                [receiptBody appendString:[NSString stringWithFormat:@"          Cantidad :\t%@\r\n", order[@"quantity"]]];
                
                // SubTotal
                [receiptBody appendString:[NSString stringWithFormat:@"          Subtotal :\t%@\r\n", [UtilityHelper numberToCurrency:order[@"subTotalPrice"]]]];
                
                
                //            }];
                
            }
            
            
            NSString * receipt = [NSString stringWithFormat:@"%@ %@ %@", receiptHeader, receiptBody, receiptFooter];
            
            NSLog(@"%@", receipt);
            
            [self print3Inch:receipt];
            
            [SVProgressHUD dismiss];
        }];
        
        
        
        //    NSString * receipt = [NSString stringWithFormat:@"%@ %@ %@", receiptHeader, receiptBody, receiptFooter];
        
        // Its printed
        // changes the state to printed
        storeOrder.state = kJUMPITTOrderStatePaidPrintedWaitingOrders;
//        storeOrder.orderNumber = store[@"currentQueueNumber"];
        [storeOrder saveEventually];
        
//        [store incrementKey:@"currentQueueNumber"];
            
        }];

    
        
}

@end
