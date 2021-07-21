//
//  CurrentCartViewController.m
//  ZilogCafe
//
//  Created by Camilo on 15-10-13.
//
//

#import "CurrentCartViewController.h"
#import "Order.h"
#import "ModifierValue.h"
#import "OrderCell.h"

#import "UtilityHelper.h"
#import "QuantitySelectViewController.h"

#import "OrderDetailViewController.h"

#import "PayCartViewController.h"

//static BOOL _paymentDone = NO;

@interface CurrentCartViewController () <QuantitySelectViewControllerDelegate, OrderCellDelegate, PayCartControllerDelegate>

@property (nonatomic, strong) NSMutableArray * orders;

@property (nonatomic, strong) StoreOrder * currentStoreOrder;

@property (nonatomic, strong) NSMutableArray * cells;

@property (nonatomic, strong) NSMutableDictionary * selectedValuesForOrder;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (nonatomic, strong) QuantitySelectViewController * quantitySelectorController;

@property (nonatomic) NSInteger row;

@property (nonatomic, strong) Order * selectedOrder;

@property (nonatomic, strong) NSNumber * totalPrice;

//@property (nonatomic)  BOOL paymentDone;

@end

@implementation CurrentCartViewController

//- (BOOL) paymentDone {
//    if (!_paymentDone) {
//        _paymentDone = NO;
//    }
//    
//    return _paymentDone;
//}

- (NSNumber *) totalPrice {
    if (!_totalPrice) {
        _totalPrice = self.currentStoreOrder.totalPrice;
    }
    
    return _totalPrice;
}

- (QuantitySelectViewController *) quantitySelectorController {
    if (!_quantitySelectorController) {
        _quantitySelectorController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuantitySelectController"];
        
        _quantitySelectorController.delegate = self;
    }
    
    return _quantitySelectorController;
}

- (NSMutableDictionary *) selectedValuesForOrder {
    if (!_selectedValuesForOrder) {
        _selectedValuesForOrder = [NSMutableDictionary dictionary];
    }
    
    return _selectedValuesForOrder;
}

- (NSInteger) row {
    if(!_row) {
        _row = 0;
    }
    
    return _row;
}


- (NSMutableArray *) orders {
    if (!_orders) {
        _orders = [NSMutableArray array];
    }
    
    return _orders;
}

- (NSMutableArray *) cells {
    if (!_cells) {
        _cells = [NSMutableArray arrayWithObjects:@"Title", nil];
    }
    
    return _cells;
}

#pragma mark - PayCart Delegate
- (void) payCartSucceded {
}

- (void) payCartClosed {

}

- (void) payCartClosedAndSuccessfullyPaid {
    NSLog(@"Closing Cart Recived");
    [self close:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    if (self.storeOrder) {
//        self.navigationItem.title = [NSString stringWithFormat:@"#%@", self.storeOrder.orderNumber];
        
        self.navigationItem.title = @"Pedido";
        
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
        
        self.navigationItem.rightBarButtonItem = nil;
        
        // Register for notifications
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderState:) name:kJUMPITTOrderStateChangedNotification object:nil];
        
    } else {
            
        self.navigationController.navigationItem.rightBarButtonItem = self.editButtonItem;
        
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) updateOrderState:(NSNotification *) notification {
    if (self.storeOrder) {
        
        [self.storeOrder refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            self.storeOrder = (StoreOrder *) object;
            [self.tableView reloadData];
        }];
       
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellType = self.cells[indexPath.row];
    
    if(![cellType isEqualToString:@"Order"] || self.storeOrder) return NO;
    
    return YES;
    
}

- (void) loadWithStoreOrder : (StoreOrder *) storeOrder {
    
    self.currentStoreOrder = storeOrder;
    
    PFQuery * ordersQuery = [self.currentStoreOrder.orders query];
    
    [ordersQuery includeKey:@"product"];
    
    [SVProgressHUD show];
    
    [ordersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.orders = [objects mutableCopy];
        
        for(int i = 0; i < objects.count; i++) {
            [self.cells addObject:@"Order"];
        }
        
        [self.cells addObject:@"Total"];
        
        if (self.storeOrder) {
            [self.cells addObject:@"OrderState"];
            [self.cells addObject:@"VerifyCode"];
        } else {
            [self.cells addObject:@"Pay"];
        }
        
        
        for (PFObject * order in objects) {
            PFRelation * selectedModifierValuesRelation = [order relationforKey:@"selectedModifierValues"];
            
#pragma message "Tirar a Clase ModifierValues"
            PFQuery * selectedModifierValuesQuery = [selectedModifierValuesRelation query];
            [selectedModifierValuesQuery includeKey:@"modifier"];
            [selectedModifierValuesQuery orderByAscending:@"priority"];
            [selectedModifierValuesQuery addAscendingOrder:@"displayName"];
            
            [selectedModifierValuesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                [self.selectedValuesForOrder setObject:objects forKey:order.objectId];
                
                [self calculateTotal];
                
                [self.tableView reloadData];
                
                [SVProgressHUD dismiss];
    
            }];
            
    }
        
        if (objects.count == 0) {
            [SVProgressHUD dismiss];
        }
        
    }];
    
    [self calculateTotal];
    
}

- (void) viewDidLoad {
    
    
    if (!self.storeOrder) {
        
    
    PFQuery * storeOrderQuery = [StoreOrder getCurrentEditableStoreOrder];
    
    [SVProgressHUD show];

    [storeOrderQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        [self loadWithStoreOrder:(StoreOrder *)object];
        
        if (error) {
            [SVProgressHUD dismiss];
        }
        
    }];
    
    } else {
        [self loadWithStoreOrder:self.storeOrder];
        
    }
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Closed Cart Controller");
    }];
}

- (IBAction)editMode:(id)sender {
    if ([self.tableView isEditing]) {
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [self.tableView setEditing:NO animated:YES];
        
        self.editButton.title = @"Editar";

    }
    
    else
    
    {
        // Turn on edit mode
        
        [self.tableView setEditing:YES animated:YES];
        
        self.editButton.title = @"Listo";

    }
}

//- (void) updateTable {
//    if (self.orders.count) {
//        self [tableView reloadData];
//    }
//    // Update Total
//    
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.cells.count;
}

#pragma mark - Delete Row

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete order
        int index = indexPath.row - 1;
        
        Order * order = self.orders[index];
        
        [order deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.cells removeObjectAtIndex:indexPath.row];
            
            [self.orders removeObjectAtIndex:index];
            
            if ([self.orders count] == 0) {
                // Remove Total and Pay Button
                
                [self.cells removeLastObject];
                [self.cells removeLastObject];
                
            }
            
#pragma warn "Mucho Cuidado SobreCarga Mejorar Forma de Eliminar Celdas"
            
            [self calculateTotal];
            
            [tableView reloadData];
            
            [SVProgressHUD dismiss];
            
//            [self.tableView reloadRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
            
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

            

                
                
//                [tableView deleteRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
                
//            } else {
                // Update Table
                

                
                // Update Total
//                [self calculateTotal];
//            }
            
//         [tableView reloadRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic ];
         

        }];
        

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * titleCellIdentifier = @"titleCell";
    
    static NSString * orderCellIdentifier = @"orderCell";
    
    static NSString * totalCellIdentifier = @"totalCell";
    
    static NSString * payCellIdentifier = @"payCell";
    
    static NSString * verificationCellIdentifier = @"verifyCell";
    
    static NSString * stateCellIdentifier = @"stateCell";
    
    NSString * cellType = self.cells[indexPath.row];
    
    if ([cellType isEqualToString:@"Title"]) {
        NSLog(@"Creating Title Cell");
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier forIndexPath:indexPath];
        
        return cell;

    } else if([cellType isEqualToString:@"Order"]) {
        NSLog(@"Creating Order Cell");
        
        OrderCell * cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier forIndexPath:indexPath];
        
        int index = indexPath.row - 1;
        
        Order * order = self.orders[index];
        
        
        PFObject * product = order[@"product"];
        
        cell.productDisplayName.text = product[@"displayName"];
        
        cell.orderSubtotalPrice.text = [UtilityHelper numberToCurrency:order[@"subTotalPrice"]];
        
        cell.orderQuantity.text = [order[@"quantity"] stringValue];
        
        cell.delegate = self;
        
        cell.order = order;
        
        cell.row = index;
        
        // Set the modifierValues
        NSArray * values = [self.selectedValuesForOrder objectForKey:order.objectId];
        
        NSMutableString * selectedValues = [NSMutableString string];
        
        for (int i = 0; i < values.count; i++) {
            
            PFObject * value = values[i];
            // First Object
            if (i == 0) {
                [selectedValues appendString:[NSString stringWithFormat:@"%@ ", value[@"displayName"]]];
            
//            // Last Object
//            } else if(i == (values.count - 1)) {
//            
//                [selectedValues appendString:[NSString stringWithFormat:@"%@", value[@"displayName"]]];
            // The Others
            } else {
                [selectedValues appendString:[NSString stringWithFormat:@"+ %@", value[@"displayName"]]];
                
            }

        }
        
        cell.orderSelectedModifiers.text = selectedValues;
        
        cell.indexPath = indexPath;
        
        self.row++;
        
        return cell;
        
    } else if([cellType isEqualToString:@"Total"]) {
        NSLog(@"Creating Total Cell");
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:totalCellIdentifier forIndexPath:indexPath];
              
//        NSNumber * totalPrice = self.currentStoreOrder.totalPrice;
        
        NSLog(@"%@", self.currentStoreOrder);
        
        cell.textLabel.text = [NSString stringWithFormat:@"Total : %@",[UtilityHelper numberToCurrency:self.totalPrice] ];
               
        
        return cell;
        
    } else if([cellType isEqualToString:@"Pay"] && !self.storeOrder) {
        NSLog(@"Creating Pay Cell");
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:payCellIdentifier forIndexPath:indexPath];
        
        return cell;
        
    } else if([cellType isEqualToString:@"VerifyCode"] && self.storeOrder) {
        NSLog(@"Creating Verify Code Cell");

        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:verificationCellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Código: %@", self.storeOrder[@"verificationCode"]];
        
        cell.userInteractionEnabled = NO;

        
        return cell;
        
    } else if([cellType isEqualToString:@"OrderState"] && self.storeOrder) {
        NSLog(@"Creating Order State Cell");

        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stateCellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = [UtilityHelper stringFromState:self.storeOrder[@"state"]];
        
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    
      
    // Return Empty Cell
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OrderDetailViewController * controller = segue.destinationViewController;
    
    controller.order = self.selectedOrder;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected Row %d", indexPath.row);

    NSString * cellType = self.cells[indexPath.row];
    
    if ([cellType isEqualToString:@"Order"]) {
        int index = indexPath.row - 1;
        
        Order * order = self.orders[index];
        
        self.selectedOrder = order;
        
        [self performSegueWithIdentifier:@"detailOrder" sender:self];
        
    } else if ([cellType isEqualToString:@"Pay"]) {
        NSLog(@"Pay Clicked");
        PayCartViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PayCartController"];
        
        controller.delegate = self;
        
        controller.storeOrder = self.currentStoreOrder;
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - OrderCell Delegate
- (void) presentQuantitySelectorControllerForCell:(OrderCell *)cell {
    
    if (self.storeOrder)  return;
    
    self.quantitySelectorController.order = cell.order;
    self.quantitySelectorController.quantity = cell.order[@"quantity"];
    self.quantitySelectorController.cell = cell;
    self.quantitySelectorController.storeOrder = self.currentStoreOrder;
    
//    self.quantitySelectorController.quantityIndicator.text = [self.quantitySelectorController.quantity stringValue];
    
    
//    self.quantitySelectorController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    
    [self presentViewController:self.quantitySelectorController animated:YES completion:nil];
    
//    [self presentTransparentModalViewController:self.quantitySelectorController animated:YES  withAlpha:0.90];
    
    
}

#pragma mark - Quantity Selector Delegate

- (void) quantityChange:(NSNumber *)quantity forCell:(OrderCell *)cell {
    // Update The Row
    
//    int index = cell.indexPath.row - 1;
    
//    PFObject * order = self.orders[cell.row];
//        
//    NSNumber * orderSubtotal = order[@"subTotalPrice"];
//    NSNumber * orderQuantity = order[@"quantity"];
//    
//    
//    if ([orderQuantity integerValue] <= 0) {
//        orderQuantity = [NSNumber numberWithInt:1];
//    }
//    
//    double unitaryPrice = [orderSubtotal doubleValue] / [orderQuantity doubleValue];
//    
//    double subtotalPrice = ([quantity integerValue] * unitaryPrice);
//
//    // Calculando el Total
//    double newTotalPrice = [self.currentStoreOrder.totalPrice doubleValue];
//    
//    newTotalPrice = newTotalPrice - [orderSubtotal doubleValue];
//    
//    
//    order[@"subTotalPrice"] = [NSNumber numberWithDouble:subtotalPrice];
//    order[@"quantity"] = quantity;
//    
//    
//    newTotalPrice = newTotalPrice + subtotalPrice;
//    
//    
//    [order saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//         self.orders[cell.row] = order;
//        
//        self.currentStoreOrder.totalPrice = [NSNumber numberWithDouble:newTotalPrice];
//        
//        [self.currentStoreOrder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
//            
//        }];
//        
//
//        
//    }];
    
//    OrderCell * tableCell = (OrderCell *) [self.tableView cellForRowAtIndexPath:cell.indexPath];
//
//    tableCell.orderQuantity.text = [quantity stringValue];
//    
//    tableCell.orderSubtotalPrice.text = [UtilityHelper numberToCurrency:[NSNumber numberWithDouble:subtotalPrice]];

    
//    NSLog(@"Quantity Change %@, %f",quantity, subtotalPrice );
}

- (void) calculateTotal {
    double newTotal = 0;
    
    NSNumber * orderPrice;
    
    [SVProgressHUD show];
    
    for (Order * order in self.orders) {
        
        orderPrice = order[@"subTotalPrice"];
        
        newTotal += [orderPrice doubleValue];
        
    }
    
    NSNumber * newTotalPrice = [NSNumber numberWithDouble:newTotal];
    
    self.totalPrice = newTotalPrice;
    
    NSLog(@"%f", newTotal);
    
    self.currentStoreOrder.totalPrice = newTotalPrice;
    
    [self.currentStoreOrder saveEventually];
    
//    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
    
//    [SVProgressHUD dismiss];
    
}


- (void) calculateSubTotalForOrder : (PFObject *) order withQuantity : (NSNumber *) quantity {
//        [order incrementKey:@"quantity" byAmount:quantity];
    
    double subtotal = 0;
    
    double orderUnitPrice = [order[@"unitPrice"] doubleValue];
    
    subtotal = orderUnitPrice * [quantity doubleValue];
    
    order[@"subTotalPrice"] = [NSNumber numberWithDouble:subtotal];
    
    order[@"quantity"] = quantity;
    
    [SVProgressHUD show];
    
    [order saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self calculateTotal];
        
        [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [SVProgressHUD dismiss];
    }];
    
}

- (void) selectedQuantity:(NSNumber *)quantity forCell:(OrderCell *)cell {
    
    [self calculateSubTotalForOrder:cell.order withQuantity:quantity];
    
    // Update The Row
    // Modify the Order
    // Dismiss
    
    //    OrderCell * tableCell = (OrderCell *) [self.tableView cellForRowAtIndexPath:cell.indexPath];
//    
//    tableCell.orderQuantity.text = [quantity stringValue];
//        
//    [self dismissTransparentModalViewControllerAnimated:YES];
    
}

#pragma mark - Transparent Modal View
- (void) presentTransparentModalViewController: (UIViewController *) aViewController
                                     animated: (BOOL) isAnimated
                                    withAlpha: (CGFloat) anAlpha{
    
//    self.quantitySelectorController = (QuantitySelectViewController *)aViewController;
    
    UIView *view = aViewController.view;
    
    view.opaque = NO;
    view.alpha = anAlpha;
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *each = obj;
        each.opaque = NO;
        each.alpha = anAlpha;
    }];
    
    if (isAnimated) {
        //Animated
        CGRect mainrect = [[UIScreen mainScreen] bounds];
        CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);
        
        
        [self.navigationController.view addSubview:view];
        view.frame = newRect;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             view.frame = mainrect;
                         } completion:^(BOOL finished) {
                             //nop
//                             [self.quantitySelectorController loadInitialQuantity];
                         }];
        
    }else{
        view.frame = [[UIScreen mainScreen] bounds];
        [self.navigationController.view addSubview:view];
    }
    
    
    
    
    
    
}

- (void) dismissTransparentModalViewControllerAnimated:(BOOL) animated{
    
    if (animated) {
        CGRect mainrect = [[UIScreen mainScreen] bounds];
        CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.quantitySelectorController.view.frame = newRect;
                         } completion:^(BOOL finished) {
                             [self.quantitySelectorController.view removeFromSuperview];
                             self.quantitySelectorController = nil;
                         }];
    }
    
    
}

@end
