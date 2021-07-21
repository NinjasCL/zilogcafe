//
//  PayCartViewController.h
//  ZilogCafe
//
//  Created by Camilo on 19-11-13.
//
//

#import <UIKit/UIKit.h>

#import "StoreOrder.h"

@protocol PayCartControllerDelegate;

@interface PayCartViewController : UIViewController

@property (nonatomic, strong) StoreOrder * storeOrder;

@property (nonatomic, strong) id <PayCartControllerDelegate> delegate;
@end

@protocol PayCartControllerDelegate <NSObject>

- (void) payCartSucceded;

- (void) payCartClosed;

- (void) payCartClosedAndSuccessfullyPaid;

@end