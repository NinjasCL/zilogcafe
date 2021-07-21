//
//  CurrentCartViewController.h
//  ZilogCafe
//
//  Created by Camilo on 15-10-13.
//
//

#import <UIKit/UIKit.h>
#import "StoreOrder.h"

@interface CurrentCartViewController : UITableViewController
@property (nonatomic, strong) StoreOrder * storeOrder;
@end
