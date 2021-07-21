//
//  OrderCell.h
//  ZilogCafe
//
//  Created by Camilo on 22-10-13.
//
//

#import <UIKit/UIKit.h>

@class OrderCell;

@protocol OrderCellDelegate <NSObject>

- (void) presentQuantitySelectorControllerForCell: (OrderCell *) cell;

@end

@interface OrderCell : UITableViewCell

@property (strong, nonatomic) id <OrderCellDelegate> delegate;

@property (strong, nonatomic) PFObject * order;

@property (weak, nonatomic) IBOutlet UILabel *productDisplayName;

@property (weak, nonatomic) IBOutlet UILabel *orderSelectedModifiers;

@property (weak, nonatomic) IBOutlet UILabel *orderSubtotalPrice;

@property (weak, nonatomic) IBOutlet UILabel *orderQuantity;

@property (strong, nonatomic) NSIndexPath * indexPath;

@property (nonatomic) NSInteger row;

@end
