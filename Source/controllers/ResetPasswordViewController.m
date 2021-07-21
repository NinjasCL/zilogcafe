//
//  ResetPasswordViewController.m
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import "ResetPasswordViewController.h"
#import "ValidationHelper.h"
#import "GPGuardPost.h"
#import "MessageHelper.h"

@interface ResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation ResetPasswordViewController

- (void) viewWillAppear:(BOOL)animated {
    self.email.text = self.userEmail;
    [self.email becomeFirstResponder];
}

- (void) viewDidLoad {
    self.email.delegate = self;
}

- (void)viewDidUnload {
    [self setEmail:nil];
    [super viewDidUnload];
}

#pragma mark - Validation

#pragma message "TODO: Unify Mailgun Validation"

- (void) validateFields {
    
    [SVProgressHUD show];
    
    [GPGuardPost validateAddress:self.email.text success:^(BOOL validity, NSString *suggestion) {
        
        [SVProgressHUD dismiss];
        
        if (!validity) {
            [MessageHelper showEmailNotValidMessage];
        } else {
            [PFUser requestPasswordResetForEmailInBackground:self.email.text block:^(BOOL succeeded, NSError *error) {
                
                [MessageHelper showEmailResetSendMessage];
                
//                if (!error) {
//                    [MessageHelper showEmailResetSendMessage];
//                } else {
//                    [MessageHelper showEmailResetErrorMessage];
//                }
            }];
            
        }
        
    } failure:^(NSError *error) {
        [MessageHelper showEmailResetErrorMessage];
    }];

}

#pragma mark - TextField Delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self resetPassword:nil];
    return YES;
}

#pragma mark - View Methods
- (IBAction)resetPassword:(id)sender {
    [self validateFields];
}


@end
