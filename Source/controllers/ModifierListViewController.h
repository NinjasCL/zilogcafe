//
//  ModifierListViewController.h
//  ZilogCafe
//
//  Created by Camilo on 08-10-13.
//
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "Modifier.h"
#import "ModifierValue.h"

@protocol ModifierListViewControllerDelegate;

@interface ModifierListViewController : UITableViewController

@property (nonatomic, strong) Product * product;

@property (nonatomic, strong) NSArray * modifiers;

@property (nonatomic, strong) id <ModifierListViewControllerDelegate> delegate;
@end

@protocol ModifierListViewControllerDelegate <NSObject>

/*! Sends the selected modifier and his value to the delegate */
- (void) modifierChanged : (Modifier *) modifier withValue: (ModifierValue *) value;


/*! Sends the modifier list and values to the delegate */
- (void) gotModifiers : (NSDictionary *) modifiers;
@end
