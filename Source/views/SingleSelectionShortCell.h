//
//  SingleSelectionShortCell.h
//  ZilogCafe
//
//  Created by Camilo on 10-10-13.
//
//

#import <UIKit/UIKit.h>
#import "SelectionCell.h"

@interface SingleSelectionShortCell : SelectionCell
@property (weak, nonatomic) IBOutlet UILabel *modifierValueName;
@property (weak, nonatomic) IBOutlet UILabel *modifierValuePrice;

@property (weak, nonatomic) IBOutlet UILabel *checkmark;

@end
