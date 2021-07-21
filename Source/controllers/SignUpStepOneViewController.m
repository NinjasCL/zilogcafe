//
//  SignUpStepOneViewController.m
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import "SignUpStepOneViewController.h"
#import "SignUpStepTwoViewController.h"
#import "ValidationHelper.h"

@interface SignUpStepOneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userFullName;

@end

@implementation SignUpStepOneViewController

- (void) viewDidLoad {
    self.userFullName.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [self.userFullName becomeFirstResponder];
}

#pragma message  "TODO: Crear Selector de Imagen de Perfil"

#pragma mark - Validation
- (BOOL) validateFields {
    return [ValidationHelper validateUserFullName:self.userFullName.text];
}

#pragma mark - TextField Delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self nextStep:nil];
    return NO;
}

#pragma mark - View Methods
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SignUpStepTwoViewController * stepTwo = segue.destinationViewController;
    stepTwo.userFullName = self.userFullName.text;
}

- (IBAction)nextStep:(id)sender {
    if([self validateFields])
        [self performSegueWithIdentifier:@"signUpStepTwo" sender:self];
}

@end
