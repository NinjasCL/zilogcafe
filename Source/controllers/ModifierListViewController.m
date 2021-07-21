//
//  ModifierListViewController.m
//  ZilogCafe
//
//  Created by Camilo on 08-10-13.
//
//

#import "ModifierListViewController.h"
#import "ProductDetailsViewController.h"

#import "Modifier.h"
#import "ModifierValue.h"
#import "ModifierValueCell.h"

#import "SingleSelectionShortCell.h"

#import "UtilityHelper.h"
#import "ColorHelper.h"

@interface ModifierListViewController ()
@property (nonatomic, strong) Modifier * selectedModifier;
@property (nonatomic, strong) ModifierValue * selectedModifierValue;

// all the values from the modifier
@property (nonatomic, strong) NSMutableDictionary * valuesForModifier;

// all the values for rows
@property (nonatomic, strong) NSMutableDictionary * valueForRow;

// all selected values for modifier
@property (nonatomic, strong) NSMutableDictionary * selectedValuesForModifier;

@end

@implementation ModifierListViewController

- (NSMutableDictionary *) valuesForModifier {
    if (!_valuesForModifier) {
        _valuesForModifier = [NSMutableDictionary dictionary];
    }
    
    return _valuesForModifier;
}

- (NSMutableDictionary *) valueForRow {
    if (!_valueForRow) {
        _valueForRow = [NSMutableDictionary dictionary];
    }
    
    return _valueForRow;
}

- (NSMutableDictionary *) selectedValuesForModifier {
    if (!_selectedValuesForModifier) {
        _selectedValuesForModifier = [NSMutableDictionary dictionary];
    }
    
    return _selectedValuesForModifier;
}


- (void) viewWillAppear:(BOOL)animated {
    
    [self.tableView setHidden:YES];
    
//    [self setTableColors];
    
    [SVProgressHUD show];
        
#pragma message " Todo: Tirar Query a la Clase"
    PFQuery * modifiersQuery = [Modifier getModifiersForProductQuery:self.product];

    [modifiersQuery orderByAscending:@"priority"];
    [modifiersQuery addAscendingOrder:@"displayName"];
    
    
    [modifiersQuery findObjectsInBackgroundWithBlock:^(NSArray * modifiers, NSError *error) {
        
        for (Modifier * modifier in modifiers) {
            
            PFRelation * modifierValues = [modifier relationforKey:@"values"];
            
            PFQuery * modifierValuesQuery = [modifierValues query];
            [modifierValuesQuery orderByAscending:@"priority"];
            [modifierValuesQuery addAscendingOrder:@"displayName"];

            NSArray * values = [modifierValuesQuery findObjects];
     
            // NSLog(@"Valores %@", values);
            
            [self.valuesForModifier setObject:values forKey:modifier.objectId];

        }
        
        self.modifiers = modifiers;
        
        
        // [self.delegate gotModifiers:self.valuesForModifier];
        
        [self.tableView reloadData];
        
        //[self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]  withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView setHidden:NO];
        
        [SVProgressHUD dismiss];
    }];
    
}

#pragma mark - Coloring

- (void) setTableColors {
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    [self.tableView setOpaque:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    // Text Color
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
//    [header.textLabel setTextColor:[ColorHelper silver]];
    
//    [header.textLabel setShadowColor:[ColorHelper wetAsphalt] ];
    
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Every Modifier is a Section
    return self.modifiers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Each section will have different amount of rows
    // Depends on the Modifier Control Type
    // And its values
        
    Modifier * modifier = self.modifiers[section];
    
    NSString * controlType = modifier[@"controlType"];
    
    NSArray * values = [self.valuesForModifier objectForKey:modifier.objectId];
    
    NSInteger totalRows = 1;

#pragma message " Crear Algoritmo"
    
    if ([controlType isEqualToString:kJUMPITTModifierControlTypeSingleSelectionShort]) {
        
            totalRows = [values count];
    }
    
    // We assign a default Value for each row in section
    
    NSString * identifier;
    
#pragma message "No Probado"
    for (int row = 0; row < totalRows; row++) {
        identifier  = [NSString stringWithFormat:@"%d%d", section, row];

        NSLog(@"Identifier %@", identifier);
        
        [self.valueForRow setObject:values[row] forKey:identifier];
    }
    
    
    // Set the default
    if (!self.selectedModifierValue) {
        
        ModifierValue * defaultValue = modifier[@"defaultValue"];
        [defaultValue fetchIfNeeded];
    
    
        [self.selectedValuesForModifier setObject: defaultValue forKey:modifier.objectId];
    }
    
    return totalRows;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Table view Style
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Each cell depends of the modifier Control Type
    
    NSString * identifier = [self getIndentifierForIndexPath:indexPath];
    
    Modifier * modifier = self.modifiers[indexPath.section];

    ModifierValue * value = [self.valueForRow objectForKey:identifier];
    //[value fetchIfNeeded];
    
    //ModifierValue * value = self.ro

    static NSString * CellIdentifier = @"ModifierCell";
    
    SingleSelectionShortCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([modifier[@"controlType"] isEqualToString:kJUMPITTModifierControlTypeSingleSelectionShort]) {

        
        cell.modifierValue = value;
        
        
        cell.modifierValueName.text = value[@"displayName"];
        
        cell.modifierValuePrice.text = [NSString stringWithFormat:@"+ %@", [UtilityHelper numberToCurrency:value[@"price"] ]];
        
        
        // Just one checkmark permited if the control
        // is single selection list short
        

        
        ModifierValue * selectedValue = [self.selectedValuesForModifier objectForKey:modifier.objectId];
        
        if ([selectedValue.objectId isEqualToString:value.objectId]) {
            
            
            //NSLog(@"Selected %@", selectedValue);
            
            NSLog(@"S %@ V %@",selectedValue.objectId, value.objectId );
            
            cell.isSelected = YES;
            cell.checkmark.text = @"✔";
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            // [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:NO];
        } else {
            NSLog(@"Not Equal");
            cell.isSelected = NO;
            cell.checkmark.text = @"";
            //cell.accessoryType = UITableViewCellAccessoryNone;
        }
        

        // [self checkIfModifierIsSelected:value];
        
        // Configure the cell...
    }    

    
    return cell;
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // The title for every section is the name of the modifier
    
    Modifier * modifier = self.modifiers[section];
    
    return modifier[@"displayName"];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Every Modifier belongs to a specific section
    // So we set the selected modifier every time
    // user select a row within a section
    
    Modifier * modifier = self.modifiers[indexPath.section];
    
    self.selectedModifier = modifier;
    
    NSString * controlType = modifier[@"controlType"];
    
    //NSString * identifier = [self getIndentifierForIndexPath:indexPath];
    
    ModifierValueCell * cell = (ModifierValueCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Control Type SingleSelectionListShort
    if ([controlType isEqualToString:kJUMPITTModifierControlTypeSingleSelectionShort]) {

#pragma message "Agregar respons to para prevenir fallas "

        
        [self.selectedValuesForModifier setObject:cell.modifierValue forKey:modifier.objectId];
    
        
        self.selectedModifierValue = cell.modifierValue;
        
        //NSLog(@"New Selected %@", [self.selectedValuesForModifier objectForKey:modifier.objectId]);
        
        [self sendValuesToDelegate];
        
        //[self checkIfModifierIsSelected:cell.modifierValue];
        //[self.tableView reloadSections:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Put a CheckMark
        
        //[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
        //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    
    //[self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Modifier * modifier = self.modifiers[indexPath.section];

    NSString * controlType = modifier[@"controlType"];
    
    // just one checkmark for single selection
    if (controlType == kJUMPITTModifierControlTypeSingleSelectionLong) {
    
        //[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        
    }
}

#pragma mark - Delegate

- (void) sendValuesToDelegate {
    // When we have the selected modifier and the selected value
    // send them to the delegate
    
    [self.delegate modifierChanged:self.selectedModifier withValue:self.selectedModifierValue];
}


#pragma mark - Utility
- (NSString *) getIndentifierForIndexPath : (NSIndexPath *) indexPath {
    return [NSString stringWithFormat:@"%d%d", indexPath.section, indexPath.row];
}

@end
