//
//  AccountManagerViewController.m
//  ZilogCafe
//
//  Created by Camilo on 05-10-13.
//
//

#import "AccountManagerViewController.h"

@interface AccountManagerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation AccountManagerViewController

- (void) viewDidAppear:(BOOL)animated {
    PFUser *user  = [PFUser currentUser];
    
    self.userName.text = user[@"fullName"];
}

- (IBAction)SignOut:(id)sender {
    //[PFUser logOut];
}

@end
