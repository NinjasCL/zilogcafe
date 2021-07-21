//
//  StoreOrderListViewController.m
//  ZilogCafe
//
//  Created by Camilo on 16-11-13.
//
//

#import "StoreOrderListViewController.h"

#import "StoreOrder.h"

#import "UtilityHelper.h"

#import "CurrentCartViewController.h"

@interface StoreOrderListViewController ()
@property (nonatomic, strong) NSArray * storeOrderList;
@property (nonatomic, strong) StoreOrder * selectedStoreOrder;
@end

@implementation StoreOrderListViewController

- (NSString *) listType {
    if (!_listType) {
        _listType = @"printerOrders";
    }
    
    return _listType;
}

- (NSArray *) storeOrderList {
    if (!_storeOrderList) {
        _storeOrderList = @[];
    }
    
    return _storeOrderList;
}

- (void) viewWillAppear:(BOOL)animated {
    [self loadStoreOrders];
}

- (void) loadStoreOrders {
    
    [SVProgressHUD show];
    
    NSLog(@"Loading %@", self.listType);
    
    if ([self.listType isEqualToString:@"waitingOrders"]) {
        PFQuery * waitingQuery = [StoreOrder getPrintedWaitingStoreOrders];
        
        [waitingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.storeOrderList = objects;
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
        
    } else if ([self.listType isEqualToString:@"readyOrders"]) {
        PFQuery * readyQuery = [StoreOrder getWaitingCustomerStoreOrders];
        
        [readyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.storeOrderList = objects;
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
        
    } else if([self.listType isEqualToString:@"printerOrders"]) {
        PFQuery * printerQuery = [StoreOrder getWaitingPrinterOrders];
        
        [printerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.storeOrderList = objects;
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
    
    } else {
        
        PFQuery * historicalQuery = [StoreOrder getHistorialStoreOrders];
        
        [historicalQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.storeOrderList = objects;
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }];

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.storeOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoreOrderCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    StoreOrder * storeOrder = self.storeOrderList[indexPath.row];
    
    NSNumber * orderNum = storeOrder[@"orderNumner"];
    NSString * cellText;
    
    cellText = [NSString stringWithFormat:@"%@", [UtilityHelper stringFromDate:storeOrder.updatedAt]];
    
    if (orderNum) {
        
        cellText = [NSString stringWithFormat:@"#%@ %@", storeOrder[@"orderNumber"], [UtilityHelper stringFromDate:storeOrder.updatedAt]];
    } 
    
    cell.textLabel.text = cellText;
    
    cell.detailTextLabel.text = [UtilityHelper stringFromState:storeOrder[@"state"]];
    
    // Configure the cell...
    
    return cell;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CurrentCartViewController * controller = segue.destinationViewController;
    
    controller.storeOrder = self.selectedStoreOrder;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedStoreOrder = self.storeOrderList[indexPath.row];
    
    [self performSegueWithIdentifier:@"detailStoreOrder" sender:self];
}

@end
