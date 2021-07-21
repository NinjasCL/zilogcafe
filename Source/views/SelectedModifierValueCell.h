//
//  SelectedModifierValueCell.h
//  ZilogCafe
//
//  Created by Camilo on 19-11-13.
//
//

#import <UIKit/UIKit.h>

@interface SelectedModifierValueCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *modifierName;

@property (weak, nonatomic) IBOutlet UILabel *modifierValueName;

@property (weak, nonatomic) IBOutlet UILabel *modifierValuePrice;

@end
