//
//  SelectedModifierValueCell.m
//  ZilogCafe
//
//  Created by Camilo on 19-11-13.
//
//

#import "SelectedModifierValueCell.h"

@implementation SelectedModifierValueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
