//
//  QuantitySelectViewController.m
//  ZilogCafe
//
//  Created by Camilo on 23-10-13.
//
//

#import "QuantitySelectViewController.h"
#import "UtilityHelper.h"

@interface QuantitySelectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *quantityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productUnitPrice;
@property (weak, nonatomic) IBOutlet UILabel *orderSubtotal;


@property (strong, nonatomic) NSNumber * unitaryPrice;
@property (strong, nonatomic) NSNumber * subTotal;
@property (strong, nonatomic) NSNumber * total;
@property (strong, nonatomic) NSNumber * rawTotal;
@end

@implementation QuantitySelectViewController
@synthesize quantity = _quantity;


- (NSNumber *) rawTotal {
    if (!_rawTotal) {
        
        NSNumber * oldSubtotal = self.order[@"subTotalPrice"];
        
        double rawTotal = [self.total doubleValue] - [oldSubtotal doubleValue];
        
        _rawTotal = [NSNumber numberWithDouble:rawTotal];
    }
    
    return _rawTotal;
}

- (NSNumber *) subTotal {

    if (!_subTotal) {
        _subTotal = [NSNumber numberWithDouble:([self.unitaryPrice doubleValue] * [self.quantity integerValue])];
    }
    
    return _subTotal;
}


- (NSNumber *) total {
    if (!_total) {
        _total = self.storeOrder[@"totalPrice"];
    }
    
    return _total;
}

- (NSNumber *) unitaryPrice {
    if (!_unitaryPrice) {
        
//        double unitaryPrice = 0;
//        
//        NSNumber * subtotalPrice = self.order[@"subTotalPrice"];
//        NSNumber * quantity = self.order[@"quantity"];
//        
//        if ([quantity integerValue] <= 0) {
//            quantity = [NSNumber numberWithInt:1];
//        }
//        
//        unitaryPrice = [subtotalPrice doubleValue] / [quantity doubleValue];
        
//        _unitaryPrice = [NSNumber numberWithDouble:unitaryPrice];
        
        _unitaryPrice = self.order[@"unitPrice"];
    }
    
    return _unitaryPrice;
}

- (NSNumber *) quantity {
    if (!_quantity) {
        _quantity = [NSNumber numberWithInt:1];
    }
    
    return _quantity;
}


- (void) setQuantity:(NSNumber *)quantity {
    
    _quantity = quantity;
    
    if ([quantity integerValue] > 20) {
        
        _quantity = [NSNumber numberWithInt:20];
        
    } else if([quantity integerValue] < 1) {
        
        _quantity = [NSNumber numberWithInt:1];
        
    }
    
    self.subTotal = nil;
    
    [self updateView];
    
//    [self getNewTotalPrice];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
//    self.unitaryPrice = nil;
    
    self.quantityIndicator.text = [self.quantity stringValue];

    PFObject * product = self.order[@"product"];
    
    self.productName.text = product[@"displayName"];
    
    NSLog(@"%@", product);
    
    [self updateView];
}

- (void) updateView {
    self.productUnitPrice.text = [NSString stringWithFormat:@"Valor Unidad: %@", [UtilityHelper numberToCurrency:self.unitaryPrice]];
    
    self.orderSubtotal.text = [NSString stringWithFormat:@"Valor SubTotal : %@", [UtilityHelper numberToCurrency:self.subTotal]];
    
    self.quantityIndicator.text = [self.quantity stringValue];

}




- (IBAction)substractQuantity:(id)sender {
    
    int substract = [self.quantity integerValue];
    substract--;
    
    self.quantity = [NSNumber numberWithInt:substract];
    
//    [self.delegate quantityChange:self.quantity forCell:self.cell];

    
}

- (IBAction)addQuantity:(id)sender {
    int add = [self.quantity integerValue];
    add++;
    
    self.quantity = [NSNumber numberWithInt:add];
    
//    [self.delegate quantityChange:self.quantity forCell:self.cell];

}

- (IBAction)close:(id)sender {
//            [self.delegate selectedQuantity:self.quantity forCell:self.cell];
    [self dismissViewControllerAnimated:YES completion:^{
//            self.storeOrder[@"totalPrice"] = self.total;
//            [self.storeOrder saveInBackground];
//        
//            self.order[@"subTotalPrice"] = self.subTotal;
//            self.order[@"quantity"] = self.quantity;
//        
//            [self.order saveInBackground];
        
            [self.delegate selectedQuantity:self.quantity forCell:self.cell];
    }];

}


@end
