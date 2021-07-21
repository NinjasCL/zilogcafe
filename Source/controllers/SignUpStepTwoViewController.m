//
//  SignUpStepTwoViewController.m
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import "SignUpStepTwoViewController.h"
#import "ValidationHelper.h"
#import "TermsAndPoliciesViewController.h"
#import "GPGuardPost.h"
#import "MessageHelper.h"

@interface SignUpStepTwoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation SignUpStepTwoViewController

- (void) viewWillAppear:(BOOL)animated {
    [self.email becomeFirstResponder];

}

- (void) viewWillDisappear:(BOOL)animated {
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void) viewDidLoad {
    self.email.delegate = self;
    self.password.delegate = self;
    
}

#pragma mark - Validation

- (void) performSignUp {
    [SVProgressHUD show];
    
    // Validate Email
    [GPGuardPost validateAddress:self.email.text success:^(BOOL validity, NSString *suggestion) {
        
        [SVProgressHUD dismiss];

        if (!validity) {
            [MessageHelper showEmailNotValidMessage];
        } else {
            
            // Validate Password

            if ([ValidationHelper validatePassword:self.password.text]) {
                
                // Perform SignUp
                PFUser *user = [PFUser user];
                user.username = self.email.text;
                user.password = self.password.text;
                user.email = self.email.text;
                user[@"fullName"] = self.userFullName;
                
                [SVProgressHUD show];
                
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    [SVProgressHUD dismiss];
                    
                    if (!error) {
                        // Hooray! Let them use the app now.
                        
                        // Bienvenido
                        [MessageHelper showWelcomeMessage];
                        
                        [self performSegueWithIdentifier:@"mainController" sender:self];
                        
                    } else {
                        //NSString *errorString = [error userInfo][@"error"];
                        
                        if (error.code == kPFErrorUsernameTaken) {
                            [MessageHelper showUserNameTaken];
                        } else {
                            [MessageHelper showErrorWithAccountSignUp];
                        }

                        // Error
                        //NSLog(@"Error %@", errorString);
                    }
                }];
                
            }
        }
        
    } failure:^(NSError *error) {
        [MessageHelper showEmailResetErrorMessage];
    }];
}


#pragma mark - Controller Selection
- (void) presentTermsOfServiceController:(BOOL) answer {
   
    TermsAndPoliciesViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"termsAndPolicies"];
    
    controller.shouldOpenTermsOfService = [NSNumber numberWithBool:answer];
    
    
    [self presentViewController:controller animated:YES completion:nil];

}

#pragma mark - View Methods
- (IBAction)signUp:(id)sender {
    [self performSignUp];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (IBAction)showTermsOfService:(id)sender {
    [self presentTermsOfServiceController:YES];
}

- (IBAction)showPrivacyPolicies:(id)sender {
    [self presentTermsOfServiceController:NO];
}

#pragma mark - TextField Delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if ([self.email isFirstResponder]) {
        
        [self.password becomeFirstResponder];
        
    } else if([self.password isFirstResponder]) {
        
        [self signUp:nil];
    }
    
    return NO;
}




@end
