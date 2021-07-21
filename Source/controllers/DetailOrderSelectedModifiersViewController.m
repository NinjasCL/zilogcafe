//
//  DetailOrderSelectedModifiersViewController.m
//  ZilogCafe
//
//  Created by Camilo on 19-11-13.
//
//

#import "DetailOrderSelectedModifiersViewController.h"

#import "SelectedModifierValueCell.h"

#import "Modifier.h"

#import "ModifierValue.h"

#import "UtilityHelper.h"

@interface DetailOrderSelectedModifiersViewController ()
@property (nonatomic, strong) NSArray * modifierValues;

@end

@implementation DetailOrderSelectedModifiersViewController

- (NSArray *) modifierValues {
    if (!_modifierValues) {
        [SVProgressHUD show];
        PFRelation * selectedModifierValues =[self.order relationforKey:  @"selectedModifierValues"];
        
        PFQuery * selectedModifiersQuery = [ selectedModifierValues query];
        
        [selectedModifiersQuery includeKey:@"modifier"];
        
        [selectedModifiersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _modifierValues = objects;
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
        
    }
    
    return _modifierValues;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.modifierValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectedModifierValueCell";
    
    SelectedModifierValueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    ModifierValue * selectedValue = self.modifierValues[indexPath.row];
    Modifier * modifier = selectedValue[@"modifier"];
    
    // Configure the cell...
    cell.modifierName.text = modifier[@"displayName"];
    
    cell.modifierValueName.text = selectedValue[@"displayName"];
    
    cell.modifierValuePrice.text = [NSString stringWithFormat:@"+ %@", [UtilityHelper  numberToCurrency:selectedValue[@"price"]] ];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
