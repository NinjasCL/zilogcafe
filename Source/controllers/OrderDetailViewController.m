//
//  OrderDetailViewController.m
//  ZilogCafe
//
//  Created by Camilo on 18-11-13.
//
//

#import "OrderDetailViewController.h"

#import "Product.h"

#import "DetailOrderSelectedModifiersViewController.h"

#import "UtilityHelper.h"

@interface OrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet PFImageView *productImage;

@property (weak, nonatomic) IBOutlet UILabel *productPrice;

@property (nonatomic, strong) Product * product;
@end

@implementation OrderDetailViewController

- (Product *) product {
    if (!_product) {
        _product = self.order[@"product"];
//        [_product fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//            _product = (Product *)object;
////            [self.view setNeedsDisplay];
//        }];
    }
    
    return _product;
}

- (void) viewWillAppear:(BOOL)animated {
    self.productName.text = self.product[@"displayName"];
    
    self.productPrice.text = [UtilityHelper numberToCurrency:self.product[@"price"]];
    
    self.productImage.file = self.product.displayImage;
    
    if ([self.productImage.file isDataAvailable]) {
        [self.productImage loadInBackground];
    }
    
    NSLog(@"%@", self.order);
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailOrderSelectedModifiersViewController * controller = segue.destinationViewController;
    
    controller.order = self.order;
}


@end