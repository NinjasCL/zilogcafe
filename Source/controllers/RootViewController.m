//
//  RootViewController.m
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void) viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    PFUser * currentUser = [PFUser currentUser];
    
    if (currentUser) {
        NSLog(@"Current User %@", currentUser);
        [self performSegueWithIdentifier:@"mainController" sender:self];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


#pragma mark - Unwind Method
- (IBAction)unwindToRootViewController:(UIStoryboardSegue *)segue{
    
    NSLog(@"Cleaning");
    
    // Cleaning in mememory data
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:kJUMPITTLastStoreOrderKey];
    
    [defaults synchronize];
    
    [PFUser logOut];

}
@end
