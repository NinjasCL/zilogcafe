//
//  ProductDetailsViewController.h
//  ZilogCafe
//
//  Created by Camilo on 06-10-13.
//
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "Modifier.h"
#import "ModifierValue.h"

#import "ModifierListViewController.h"


@interface ProductDetailsViewController : UIViewController <ModifierListViewControllerDelegate>

@property (strong, nonatomic) Product * product;

@property (strong, nonatomic) NSNumber * subtotalPrice;

/*! If this product can be modified */

@property (nonatomic, assign) BOOL canModify;

/*! Methods that modifiers alters the subtotal price */

- (void) resetSubtotal;


@end
