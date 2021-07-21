//
//  QuantitySelectViewController.h
//  ZilogCafe
//
//  Created by Camilo on 23-10-13.
//
//

#import <UIKit/UIKit.h>

#import "OrderCell.h"

@protocol QuantitySelectViewControllerDelegate <NSObject>

@required

- (void) selectedQuantity: (NSNumber *) quantity forCell : (OrderCell *) cell;

@optional

- (void) quantityChange: (NSNumber *) quantity forCell: (OrderCell *) cell;

- (void) selectedQuantity: (NSNumber *) quantity forOrder : (PFObject *) order;

@end

@interface QuantitySelectViewController : UIViewController
@property (nonatomic, strong) PFObject * storeOrder;
@property (nonatomic, strong) PFObject * order;
@property (nonatomic, strong) NSNumber * quantity;
@property (nonatomic, strong) OrderCell * cell;



@property (nonatomic, strong) id <QuantitySelectViewControllerDelegate> delegate;


@end
