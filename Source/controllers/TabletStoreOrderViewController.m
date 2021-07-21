//
//  TabletStoreOrderViewController.m
//  ZilogCafe
//
//  Created by Camilo on 17-10-13.
//
//

#import "TabletStoreOrderViewController.h"

#import "StoreOrder.h"
#import "Store.h"


//#import "PrinterHelper.h"

@interface TabletStoreOrderViewController ()

@property (nonatomic, strong)  NSArray * storeOrders;

@end

@implementation TabletStoreOrderViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self reloadData];
}

- (void) reloadData {
    
    [SVProgressHUD show];
    
    PFQuery * query = [StoreOrder query];
    [query includeKey:@"store"];
    
    [query whereKey:@"state" equalTo:kJUMPITTOrderStatePaidWaitingPrinting];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.storeOrders = objects;
        
//        for (StoreOrder * storeOrder in objects) {
//            Store * store = storeOrder[@"store"];
            
//            [store refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
//                storeOrder.orderNumber = store[@"currentQueueNumber"];
            
                
//                [storeOrder saveInBackground];
//            }];
            
#pragma message " El incremento del Order Number debe ser en code cloud before save"
            
//            [store incrementKey:@"currentQueueNumber"];

//        }
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];

    }];
    
}

- (IBAction)reloadDataButton:(id)sender {
    [self reloadData];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.storeOrders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoreOrderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    StoreOrder * storeOrder = self.storeOrders[indexPath.row];
    
    cell.textLabel.text = storeOrder.objectId;
    
    // Configure the cell...
    
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
    
    StoreOrder * storeOrder = self.storeOrders[indexPath.row];
    
    //[PrinterHelper printReceiptWithStoreOrder:storeOrder];
}

@end
