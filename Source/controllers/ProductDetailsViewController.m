//
//  ProductDetailsViewController.m
//  ZilogCafe
//
//  Created by Camilo on 06-10-13.
//
//

#import "ProductDetailsViewController.h"
#import "ModifierListViewController.h"

#import "UtilityHelper.h"
#import "MessageHelper.h"

#import "StoreOrder.h"
#import "Order.h"


#import "JSBadgeView.h"
#import "MAConfirmButton.h"

@interface ProductDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *productName;
//@property (weak, nonatomic) IBOutlet UILabel *productPrice;

//@property (weak, nonatomic) IBOutlet UILabel *productIsAvailable;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
//@property (weak, nonatomic) IBOutlet UITextView *productDescription;

@property (strong, nonatomic) NSMutableDictionary * modifiersAndValues;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitle;

@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *payButton;

@property (strong, nonatomic) NSArray * modifiers;

@property (weak, nonatomic) IBOutlet UILabel *currentPrice;


@property (strong, nonatomic) JSBadgeView * badgeView;

//@property (strong, nonatomic) MAConfirmButton * addCartButton;

//@property (weak, nonatomic) IBOutlet UIView *badgeViewParent;

//@property (weak, nonatomic) IBOutlet UIView *containerView;

@end


@implementation ProductDetailsViewController

- (BOOL) canModify {
    if (!_canModify) {
        _canModify = YES;
    }
    
    return _canModify;
}

//- (MAConfirmButton *) addCartButton {
//    if (!_addCartButton) {
//        _addCartButton = [MAConfirmButton buttonWithTitle:[UtilityHelper numberToCurrency: self.subtotalPrice] confirm:@"Agregar al Carro"];
//        
//        _addCartButton.toggleAnimation = MAConfirmButtonToggleAnimationRight;
//        
//        [_addCartButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        [_addCartButton setAnchor:CGPointMake(self.productImage.bounds.origin.x + _addCartButton.bounds.size.width + 90, 35)];
//    }
//    
//    return _addCartButton;
//}

//- (JSBadgeView *) badgeView {
//    if(!_badgeView) {
//        
//        [[JSBadgeView appearance] setBadgeTextShadowColor:[UIColor clearColor]];
//        
//        [[JSBadgeView appearance] setBadgeShadowColor:[UIColor clearColor]];
//        
//        [[JSBadgeView appearance] setBadgeStrokeColor:[UIColor clearColor]];
//       
//        [[JSBadgeView appearance] setBadgeOverlayColor:[UIColor clearColor]];
//        
//        _badgeView = [[JSBadgeView alloc] initWithParentView:self.badgeViewParent  alignment:JSBadgeViewAlignmentCenter];
//        
//        
//        _badgeView.badgeText = @"";
//    }
//    
//    return _badgeView;
//}

- (NSArray *) modifiers {
    if (!_modifiers) {
        PFQuery * query = [Modifier getModifiersForProductQuery:self.product];

//        _modifiers = [query findObjects];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _modifiers = objects;
            
            // Force reload modifiers and values
            self.modifiersAndValues = nil;
        }];
    }
    
    return _modifiers;
}

- (NSNumber *) subtotalPrice {
    if (!_subtotalPrice) {
        
        NSArray * modifiersValues = [self.modifiersAndValues allValues];
        
        double subtotal = [self.product.price doubleValue];
        
        for (ModifierValue * modifierValue in modifiersValues) {

            subtotal += [modifierValue[@"price"] doubleValue
                         ];
        }
        
        _subtotalPrice = [NSNumber numberWithDouble:subtotal];
    }
    
    return _subtotalPrice;
}

- (NSMutableDictionary *) modifiersAndValues {
    if (!_modifiersAndValues) {
        _modifiersAndValues = [NSMutableDictionary dictionary];
        for (Modifier * modifier in self.modifiers) {
            
            //NSLog(@"Modifier %@", modifier);
            ModifierValue * modifierValue = modifier[@"defaultValue"];
            //[modifierValue fetchIfNeeded];
            
            [self.modifiersAndValues setObject:modifierValue forKey:modifier.objectId];
        }

    }
    
    return _modifiersAndValues;
}


- (void) viewWillAppear:(BOOL)animated {
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    
//    [defaults setObject:nil forKey:self.product.objectId];
    
    self.productName.text = self.product.displayName;
    
//    self.productDescription.text = self.product.displayDescription;
//    
//    self.productIsAvailable.text = [UtilityHelper isAvailableToString:self.product.isAvailable];
//    
//    self.productIsAvailable.textColor = [UtilityHelper isAvailableToColor:self.product.isAvailable];
    
    self.productImage.image = self.product.image;
    
    //self.canModify = YES;
    
    self.currentPrice.text = [UtilityHelper numberToCurrency:self.subtotalPrice];
    
    //[self.modifiersAndValues object:@"" forKey:@"dummyfoobar"];
    
    //[self.modifiersAndValues objectForKey:@"dummyFoobar"];
    
    [self resetSubtotal];
    [self updateInterface];

    
}



//- (void)confirmAction:(id)sender{
//    NSLog(@"Add to Cart");
//    static int count = 1;
//    
//    self.badgeView.badgeText = [NSString stringWithFormat:@"%d", count];
//    
//    count ++;
//    
//    self.canModify = NO;
//    self.containerView.userInteractionEnabled = NO;
//    
//    [sender disableWithTitle:@"Agregado"];
//
//}

#pragma mark - Add to Cart Process
- (BOOL) areCurrentHashAndMemoryHashEqual {
    
    NSLog(@"Checking if Hash are Equal");
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString * currentHash = [self getHashForCurrentProductConfiguration];
    
    NSDictionary * savedHashDic = [defaults objectForKey:self.product.objectId];
    
    NSLog(@"Saved Hash Dic %@", savedHashDic);
    
    NSString * savedHash = [savedHashDic objectForKey:kJUMPITTInMemoryOrderHashKey];
    
    return [currentHash isEqualToString:savedHash];
}

- (void) saveCurrentProductConfigurationHashWithOrder: (Order *) order {
    
    NSLog(@"Saving Order to Memory");
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * currentHash = [self getHashForCurrentProductConfiguration];
    
    NSDictionary * memoryHash = [NSDictionary dictionaryWithObjects:@[currentHash, order.objectId] forKeys:@[kJUMPITTInMemoryOrderHashKey, kJUMPITTInMemoryOrderOrderKey]];
    
    [defaults setObject:memoryHash forKey:self.product.objectId];
    
    [defaults synchronize];
}

- (Order *) getSavedOrderForHashFromDB {
#pragma messsage " Mandar a clase Order "
    
    NSLog(@"Retrieving Order From DB");
    
    NSString * orderHash = [self getHashForCurrentProductConfiguration];
    
    PFQuery * query = [Order query];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query whereKey:@"hash" equalTo:orderHash];
    
    // add store constraint
    //[query whereKey:@"store" equalTo:self.product.store];
    
    [query whereKey:@"state" equalTo:kJUMPITTOrderStateWaitingPayment];
    
    [query whereKey:@"product" equalTo:self.product];
    
    Order * savedOrder = (Order *)[query getFirstObject];
    
    return savedOrder;
}

- (NSString *) getHashForCurrentProductConfiguration {
    
    NSLog(@"Creating Hash");
    
    NSMutableString * baseString = [self.product.objectId mutableCopy];
    
#pragma message " Arreglar para seleccion multple"
    
    //NSLog(@"%@", [self.modifiersAndValues allValues]);
    
    for (ModifierValue * modifierValue in [self.modifiersAndValues allValues]) {
        
//        [modifierValue fetchIfNeeded];
        
//        NSLog(@"ModifierValue %@", modifierValue);
        
        [baseString appendString:modifierValue.objectId];
    }
  
    NSLog(@"BASE STRING %@", baseString);
    
    NSString * md5Hash = [UtilityHelper getMD5Hash:baseString];
    
    NSLog(@"MD5 %@", md5Hash);
    
    return md5Hash;
}

//- (void) countItemsInStoreOrder: (StoreOrder *) storeOrder {
//    
//    NSLog(@"Counting Items In Cart");
//    
//    PFQuery * orders = [storeOrder.orders query];
//    
//    [orders findObjectsInBackgroundWithBlock:^(NSArray * orders, NSError *error) {
//            NSInteger totalItemsCount = 0;
//        
//            for (Order * order in orders) {
//                totalItemsCount += [order.quantity integerValue];
//            }
//        
//            [StoreOrder setTotalItemsInCurrentStoreOrder:totalItemsCount];
//    }];

//    NSInteger totalItemsCount = 0;
//    
//    for (Order * order in [orders findObjects]) {
//        totalItemsCount += [order.quantity integerValue];
//    }
//    
//    [StoreOrder setTotalItemsInCurrentStoreOrder:totalItemsCount];
//    
//    NSLog(@"Total Items in Cart %d", totalItemsCount);
//    
//    return [NSNumber numberWithInteger:totalItemsCount];
//}

- (StoreOrder *) createANewStoreOrder {
    
    NSLog(@"Creating a New Store Order");
    
    StoreOrder * storeOrder = [StoreOrder object];
    
    storeOrder.user = [PFUser currentUser];
    
    storeOrder.state = kJUMPITTOrderStateWaitingPayment;
    
    storeOrder.store = self.product.store;
    
    storeOrder.verificationCode = [UtilityHelper getRandomVerificationCode];
    
    storeOrder.isVerified = NO;
    
    // User Queue Number is Set
    // on the server
    
    // Orders will be added later
    
//    storeOrder.totalPrice = 0;
    
    [storeOrder save];
    
    return storeOrder;
}

- (void) addOrder: (Order *) order ToStoreOrder : (StoreOrder *) storeOrder {
    
    NSLog(@"Adding Order To Store Order");

//    Eval if necessary
//    [storeOrder fetch];
//    
//    [order fetch];


    //    [order save];

//    
//    double newTotalPrice = [storeOrder.totalPrice doubleValue] + [order.subTotalPrice doubleValue];
//    
//    storeOrder.totalPrice = [NSNumber numberWithDouble:newTotalPrice];
//    
    [storeOrder.orders addObject:order];
    
    // Update total price
    
    [storeOrder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFQuery * orders = [storeOrder.orders query];
        orders.cachePolicy = kPFCachePolicyCacheThenNetwork;
        orders.maxCacheAge = 60;

        [orders findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            double __block total = 0;
        
#pragma message "This calculations, better made them in codecloud on save"

            NSInteger __block orderCount = 0;

            
            for (Order * order in objects) {
                // Count items
                
                //[storeOrder incrementKey:@"orderCount"];
                
//                [order refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                
//                    NSNumber * subtotal =  object[@"subTotalPrice"];
                
                    orderCount += [order.quantity intValue];
                    
//                    total += [subtotal doubleValue];
                
                total += [order.subTotalPrice doubleValue];
                

                    
//                }];
                
                order.storeOrder = storeOrder;
                [order saveInBackground];
                
                
                [StoreOrder setTotalItemsInCurrentStoreOrder:orderCount];
                
                                
                                
                storeOrder.orderCount = [NSNumber numberWithInteger: orderCount];

                
            }
            
            
            storeOrder.totalPrice = [NSNumber numberWithDouble:total];
            
            [storeOrder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self saveLastStoreOrderInMemory:storeOrder];
                [self updateInterface];
            }];
            
        }];
    }];
}

- (Order *) createANewOrder {
    
    NSLog(@"Creating a New Order");
    
    Order * order = [Order object];
    
    order.user = [PFUser currentUser];
    
    order.state = kJUMPITTOrderStateWaitingPayment;
    
    order.store = self.product.store;
    
    order.product = self.product;
    
    order.subTotalPrice = self.subtotalPrice;
    
    order[@"unitPrice"] = self.subtotalPrice;
    
    order.hash = [self getHashForCurrentProductConfiguration];
    
    order.quantity = [NSNumber numberWithInt:1];
    
    //order.storeOrder = [self getLastStoreOrderInMemory];
    

    // Add the selected values to the order
    for (ModifierValue * modifierValue in [self.modifiersAndValues allValues]) {
    
        [order.selectedModifierValues addObject:modifierValue];
    }
    
    [order save];
    
    return order;
}

- (void) createANewOrderAndSaveItToMemory {
    NSLog(@"Creating and Saving Order to Memory");
    
    Order * order = [self createANewOrder];
    
    [self saveCurrentProductConfigurationHashWithOrder:order];
}

//- (BOOL) checkIfCanCreateANewStoreOrder {
//    
//    NSLog(@"Cheking if can create a new store order");
//    
//    PFQuery * query = [StoreOrder getCanCreateANewStoreOrderQuery];
//    
//    // In the main thread
//    NSInteger totalResults = [query countObjects];
//    
//    // If the query shows a result,
//    // we can't create a new store order
//    
//    NSLog(@"Total Webpay StoreOrders %d", totalResults);
//    
//    if (totalResults != 0) {
//        NSLog(@"Cannot create a new one, fatal error");
//        [SVProgressHUD dismiss];
//        
//        [MessageHelper showCannotCreateNewStoreOrderMessage];
//        
//        return NO;
//    }
//    
//    return YES;
//}

// Can be StoreOrder or Order
- (BOOL) checkIfCanBeModified : (PFObject *) orderObject {
    
    NSLog(@"Checking if object can be modified");
    
    // Update order object
    [orderObject refresh];
    
    // Just waiting payment state allows modification
    // from customer
    NSLog(@"State %@", orderObject[@"state"]);
    
    if (![orderObject[@"state"] isEqualToString:kJUMPITTOrderStateWaitingPayment]) {
        return NO;
    }
    
    return YES;
}

- (StoreOrder *) getLastStoreOrderInMemory {
    
    NSLog(@"Getting Last Store Order From Memory");
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * storeOrderDict = [NSDictionary dictionaryWithDictionary:[defaults objectForKey:kJUMPITTLastStoreOrderKey]];
    
    StoreOrder * storeOrder = [StoreOrder object];
     
    storeOrder.objectId = [storeOrderDict objectForKey:kJUMPITTStoreOrderKey];
    
//    [storeOrder fetch];
    
    return storeOrder;
}



- (Order *) getLastOrderInMemory {
    
    NSLog(@"Getting Last Order From Memory");
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * orderDic = [defaults objectForKey:self.product.objectId];
    
    Order * order = [Order object];
//    [order fetchIfNeeded];
    
    order.objectId = [orderDic objectForKey:kJUMPITTInMemoryOrderOrderKey];
    
    return order;
}

- (void) saveLastStoreOrderInMemory : (StoreOrder *) storeOrder {
    
    NSLog(@"Saving Last Store Order To Memory");
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
//    NSNumber *  totalItems = [self countItemsInStoreOrder:storeOrder];
//    
//    NSLog(@"Total Items: %@", totalItems);
    
    NSDictionary * memoryStoreOrder = [NSDictionary dictionaryWithObjects:@[storeOrder.objectId, [StoreOrder getTotalItemsInCurrentStoreOrder]] forKeys:@[kJUMPITTStoreOrderKey, kJUMPITTStoreOrderCountKey]];
    
    [defaults setObject:memoryStoreOrder forKey:kJUMPITTLastStoreOrderKey];
    
    [defaults synchronize];
    
    
    
}

- (void) createANewStoreOrderAndSaveItToMemory {
    
    NSLog(@"Creating a new Store Order an Save it to Memory");
    
    StoreOrder * storeOrder = [self createANewStoreOrder];
    
    [self saveLastStoreOrderInMemory:storeOrder];
}

- (void) lookForOrderInDB {
    NSLog(@"Searching Order in DB");
    // look in DB for similar configuration
    
    Order * savedOrder = [self getSavedOrderForHashFromDB];
    
    // We got a saved Order with the same hash
    if (savedOrder) {
        
        // Save it to the internal memory
        
        // Increment the quantity
        [self updateOrderQuantity:savedOrder];
        
        [self saveCurrentProductConfigurationHashWithOrder:savedOrder];
        
        // continue program
        
        // We got nothing, create a new one
    } else {
        
        [self createANewOrderAndSaveItToMemory];
                
    }
}

- (void) updateOrderQuantity : (Order *) order {
    [order incrementKey:@"quantity"];
    
    [order refreshInBackgroundWithBlock:^(PFObject * object, NSError *error) {
        Order * updatedOrder = (Order *) object;
        
        updatedOrder.subTotalPrice = [NSNumber numberWithDouble:[self.subtotalPrice doubleValue] * [updatedOrder.quantity doubleValue]];
        
        [order saveInBackground];
        
    }];
        
}



- (void) initAddToCartProcess {
        
//    if ([SVProgressHUD isVisible]) {
    
//    if(![self checkIfCanCreateANewStoreOrder]) return;

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];

    NSLog(@"Cheking if can create a new store order");
    
    PFQuery * query = [StoreOrder getCanCreateANewStoreOrderQuery];
    
    // In the main thread
    [query countObjectsInBackgroundWithBlock:^(int totalResults, NSError *error) {
        

    
    // If the query shows a result,
    // we can't create a new store order
    
    NSLog(@"Total Webpay StoreOrders %d", totalResults);
    
    BOOL canContinue = YES;

    if (totalResults != 0) {
        NSLog(@"Cannot create a new one, fatal error");
        [SVProgressHUD dismiss];
        
        [MessageHelper showCannotCreateNewStoreOrderMessage];
        
        canContinue = NO;

    }
    
    if (canContinue) {
    
    canContinue = NO;
        
    

    StoreOrder * lastStoreOrder = [self getLastStoreOrderInMemory];
    
    
    // First we check the cart
        
    NSLog(@"Init Last StoreOrder %@", lastStoreOrder);
    
        
    if (!lastStoreOrder) {
        // there is no last order saved in memory
        // Check if can create a new one
        
        NSLog(@"No Last Order Found, checking if can create one");
        
//        if([self checkIfCanCreateANewStoreOrder]) {
            // We can create a new one
            // so lets create it
            
            NSLog(@"Can Create a new Store Order");
            
            [self createANewStoreOrderAndSaveItToMemory];
            
            canContinue = YES;
            
//        }
        // we have a last order in memory
    } else {
        // Check if can be modified
        if([self checkIfCanBeModified:lastStoreOrder]) {
            
            NSLog(@"Last order can be modified");
            
            // If can be modified we can continue
            canContinue = YES;
            
        } else {
            // If cannot be modified, try to create a new one
            
            NSLog(@"Last Order Cannot Be Modified");
            
//            if ([self checkIfCanCreateANewStoreOrder]) {
            
                NSLog(@"Last order cannot be modified, trying creating a new one");
                
                // Create a new one
                [self createANewStoreOrderAndSaveItToMemory];
                
                canContinue = YES;
                
//            }
        }
    }
    
        
    
    // Now we work with the order
    if (canContinue) {
        
        NSLog(@"We can continue");
        
        // Calculate the hash of the current product
        // configuration
        
        // compares it with the one stored in memory
        // are they equal?
        if ([self areCurrentHashAndMemoryHashEqual]) {
            
            NSLog(@"Hasshes are equal");
            
            // yes they are
            
            // are there any orders with this hash?
            Order * currentOrder = [self getLastOrderInMemory];
            
            if (currentOrder) {
                
                NSLog(@"Theres is an order in memory");
                
                // yes
                // check if the order can be modified
                if ([self checkIfCanBeModified:currentOrder]) {
                    
                    NSLog(@"Order in memoery can be modified'");
                    
                    // yes we can continue
                    // if the order can be
                    // modified                    
                    
                    // Increments its quantity
                    
                    [self updateOrderQuantity:currentOrder];
                    
                } else {
                    // We cannot modify it, create a new one
                    
                    NSLog(@"Order in memoery cannot be modified, trying to create a new one");
                    [self createANewOrderAndSaveItToMemory];
                }
                
                // there is not a current order with hash
                
            } else {
                NSLog(@"Theres no Order in Memory");
                // we must search in db if there's a
                // saved one in database
                [self lookForOrderInDB];
                                
            }
            
        } else {
            NSLog(@"Hasshes are different");
        // they aren't equal hashes
        // look in DB for a similar configuration
            [self lookForOrderInDB];
        }
        
    
        //NSLog(@"Adding Order to Cart");
        
        // Now we add the order to the store
        Order * currentOrder = [self getLastOrderInMemory];
        
        StoreOrder * storeOrder = [self getLastStoreOrderInMemory];
        
        [self addOrder:currentOrder ToStoreOrder:storeOrder];
        
//        [self saveLastStoreOrderInMemory:storeOrder];
        
//        [self updateInterface];
        
    }
    
        [SVProgressHUD dismiss];
        
    } // end of main can continue
  
  }];// En of total results query
    
}

# pragma mark - View Methods
- (IBAction)addToCart:(id)sender {
    [self initAddToCartProcess];

}


- (IBAction)payCart:(id)sender {
    NSLog(@"PayCart");
    
    UIViewController * cart = [self.storyboard instantiateViewControllerWithIdentifier:@"CartController"];
    
//    cart.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:cart animated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"modifiers"]) {
        
        ModifierListViewController * modifiersController = segue.destinationViewController;
        
        modifiersController.product = self.product;
        // modifiersController.modifiers = self.modifiers;
        modifiersController.delegate = self;
        
    }
}



#pragma mark - Methods for Modifiers

- (void) resetSubtotal {
    
//    if (self.canModify) {
    
    
    self.subtotalPrice = nil;
    
//        self.productPrice.text = [UtilityHelper numberToCurrency:self.subtotalPrice];
    
//        self.navigationTitle.title = [UtilityHelper numberToCurrency:self.subtotalPrice];
        
    self.currentPrice.text = [UtilityHelper numberToCurrency:self.subtotalPrice];

    
        //[self.addCartButton removeFromSuperview];
    
        //  self.addCartButton = nil;
    
        //[self.view addSubview:self.addCartButton];

//    }
}

#pragma message "Unir Bar Button con Product List"

- (void) updateInterface {
    
//    NSNumber *  itemsInCart = [StoreOrder getTotalItemsInCurrentStoreOrder];
//    
//    NSLog(@"Items in Cart %@", itemsInCart);
//    
//    if (!itemsInCart) {
    
    
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
        NSDictionary * storeOrderDic = [defaults objectForKey:kJUMPITTLastStoreOrderKey];
    
        StoreOrder * storeOrder = [StoreOrder object];
        storeOrder.objectId = [storeOrderDic objectForKey:kJUMPITTStoreOrderKey];
    
        NSLog(@"$%@", storeOrder);
    
        [storeOrder refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            NSNumber * itemsInCart = object[@"orderCount"];
            //    }
            
            if (!itemsInCart) {
                itemsInCart = [NSNumber numberWithInteger:0];
            }
            
            NSString * buttonTitle = @"Ítem";
            
            if ([itemsInCart intValue] > 1) {
                
                buttonTitle = @"Items";
                
            }
            
            self.payButton.title = [NSString stringWithFormat:@"%@ %@", itemsInCart, buttonTitle];
            
            NSLog(@"%@", self.payButton.title);
            
            
            UIBarButtonItem * button = self.payButton;
            
            
            if ([itemsInCart intValue] <= 0) {
                NSLog(@"Bar Hide");
                button = nil;
            } else {
                NSLog(@"Bar Show");
            }
            
            
            [self.navigationItem setRightBarButtonItem:button animated:YES];
            
        }];
    
    
}

#pragma mark - Delegate of Modifier List Controller

- (void) modifierChanged:(Modifier *)modifier withValue:(ModifierValue *)value {

    [self.modifiersAndValues setObject:value forKey:modifier.objectId];
    
    NSLog(@"Modifier Changed %@", self.modifiersAndValues);
    
    [self resetSubtotal];
}

- (void) gotModifiers:(NSDictionary *) modifiers {
//
//    Modifier * modifier = [[Modifier alloc] init];
//    
//    for (NSString * modifierId in [modifiers allKeys]) {
//
//        modifier.objectId = modifierId;
//        [modifier fetchIfNeeded];
//        
//        [self.modifiers addObject:modifier];
//    }
//    
//    [self resetSubtotal];
}



@end
