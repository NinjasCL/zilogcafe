//
//  ModifierValueCell.h
//  ZilogCafe
//
//  Created by Camilo on 10-10-13.
//
//

#import <UIKit/UIKit.h>
#import "ModifierValue.h"

@protocol ModifierValueCellChild;

@interface ModifierValueCell : UITableViewCell
@property (nonatomic, strong) ModifierValue * modifierValue;


@end

@protocol ModifierValueCellChild <NSObject>

- (id) initWithModifier: (ModifierValue *) modifierValue;

@end