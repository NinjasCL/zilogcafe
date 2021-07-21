//
//  OrderCell.m
//  ZilogCafe
//
//  Created by Camilo on 22-10-13.
//
//

#import "OrderCell.h"

@implementation OrderCell


- (IBAction)changeQuantity:(id)sender {
    NSLog(@"Change Quantity Touched");
    [self.delegate presentQuantitySelectorControllerForCell:self];
}

@end
