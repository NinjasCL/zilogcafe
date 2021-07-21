//
//  ProductListViewController.m
//  ZilogCafe
//
//  Created by Camilo on 05-10-13.
//
//

#import "ProductListViewController.h"
#import "ProductDetailsViewController.h"

#import "ProductCell.h"

#import "Product.h"
#import "CoreImage.h"

#import "UtilityHelper.h"
#import "ColorHelper.h"

#import "Store.h"


@interface ProductListViewController ()
@property (nonatomic, strong) NSMutableArray * products;

@property (nonatomic, strong) Product * selectedProduct;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *payButton;

@end

@implementation ProductListViewController

- (NSMutableArray *) products {
    if (!_products) {
        _products = [NSMutableArray array];
    }
    
    return _products;
}

#pragma mark - View LifeCycle
- (void) viewDidLoad {
    PFQuery * query = [Product getProductsQuery];
    
    
    [SVProgressHUD show];
    
    self.products = nil;
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            NSLog(@"Products Found");
            
            [self.products addObjectsFromArray:objects];
            
            // Cache the images
            for (Product * product in objects) {
                [product.displayImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    product.image = [UIImage imageNamed:@"default-product.jpg"];
                    
                    if (!error) {
                        product.image = [UIImage imageWithData:data];
                    }
                }];
            }
            
            [SVProgressHUD dismiss];
            
            [self.tableView reloadData];
        }
    }];
        
}

- (void) viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self updateInterface];
    
    NSLog(@"Appear Product List");

    //[self.tableView setBackgroundColor:[ColorHelper wetAsphalt]];
    
    //[self.tableView setSeparatorColor:[ColorHelper peterRiver]];
}

- (void) viewWillAppear:(BOOL)animated {
}

- (void) updateInterface {
        
        //    NSNumber *  itemsInCart = [StoreOrder getTotalItemsInCurrentStoreOrder];
        //
        //    NSLog(@"Items in Cart %@", itemsInCart);
        //
        //    if (!itemsInCart) {
        
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary * storeOrderDic = [defaults objectForKey:kJUMPITTLastStoreOrderKey];
        
        NSNumber * itemsInCart = [storeOrderDic objectForKey:kJUMPITTStoreOrderCountKey];
        
        //    }
        
        NSString * buttonTitle = @"Ítem";
        
        if ([itemsInCart intValue] > 1) {
            
            buttonTitle = @"Ítems";
            
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
        
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCell";
    
    ProductCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Product * product = [self.products objectAtIndex:indexPath.row];
        
    cell.productName.text = product.displayName;
    cell.productPrice.text = [UtilityHelper numberToCurrency:product.price];
    
    cell.productIsAvailable.text = [UtilityHelper isAvailableToString:product.isAvailable];
    
#pragma message "TODO: Check if UIImageView works too"
    
    cell.productImage.file = product.displayImage;
    
    if ([cell.productImage.file isDataAvailable]) {
        [cell.productImage loadInBackground];
    }
    
    cell.productIsAvailable.textColor =  [UtilityHelper isAvailableToColor:product.isAvailable];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedProduct = self.products[indexPath.row];
    
    [self performSegueWithIdentifier:@"productDetails" sender:self];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    ProductDetailsViewController * details = segue.destinationViewController;
    
    details.product = self.selectedProduct;
}

- (IBAction)showCart:(id)sender {
    UIViewController * cart = [self.storyboard instantiateViewControllerWithIdentifier:@"CartController"];
    
//    cart.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:cart animated:YES completion:nil];
}


@end
