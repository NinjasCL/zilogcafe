//
//  SignInViewController.m
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import "SignInViewController.h"
#import "ResetPasswordViewController.h"
#import "ValidationHelper.h"
#import "MessageHelper.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation SignInViewController

- (void) viewWillAppear:(BOOL)animated {
    [self.email becomeFirstResponder];
}


- (void) viewDidLoad {
    self.email.delegate = self;
    self.password.delegate = self;
}

- (void)viewDidUnload {
    [self setEmail:nil];
    [self setPassword:nil];
    [super viewDidUnload];
}

#pragma mark - Validation
- (BOOL) validateFields {
    
    BOOL canContinue = NO;
    
    canContinue = [ValidationHelper validateEmail:self.email.text];
    
    if(canContinue) canContinue = [ValidationHelper validatePassword:self.password.text];
    
    return canContinue;
}

#pragma mark - View Methods
- (IBAction)signIn:(id)sender {

    if([self validateFields]) {
        [SVProgressHUD show];
        
        [PFUser logInWithUsernameInBackground:self.email.text  password:self.password.text
                                        block:^(PFUser *user, NSError *error) {
                                            
                                            [SVProgressHUD dismiss];
                                            
                                            if (user) {
                                                // Do stuff after successful login.
                            
                                                [MessageHelper showWelcomeMessage];
                                                
                                                [self performSegueWithIdentifier:@"mainController" sender:self];
                                                
                                            } else {
                                                // The login failed. Check error to see why.
                                                
                                                [MessageHelper showSignInError];
                                                
                                            }
                                        }];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"resetPassword"]) {
        ResetPasswordViewController * reset = segue.destinationViewController;
        reset.userEmail = self.email.text;
    }
} 


#pragma mark - TextField Delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if ([self.email isFirstResponder]) {
    
        [self.password becomeFirstResponder];
    
    } else if([self.password isFirstResponder]) {
        
        [self signIn:nil];
    }
    
    return NO;
}
@end
