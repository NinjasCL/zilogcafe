//
//  MessageHelper.h
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import <Foundation/Foundation.h>

@interface MessageHelper : NSObject
+ (void) showEmailNotValidMessage;
+ (void) showEmailRequiredMessage;

+ (void) showPasswordRequiredMessage;
+ (void) showPasswordNotValidMessage;

+ (void) showUserFullNameRequiredMessage;

+ (void) showEmailResetSendMessage;
+ (void) showEmailResetErrorMessage;

+ (void) showUserNameTaken;

+ (void) showErrorWithAccountSignUp;

+ (void) showWelcomeMessage;
+ (void) showSignInError;

+ (void) showCannotCreateNewStoreOrderMessage;
///**
// Generic Messages
// */
//+ (void) showLoadingMessage;
//
///**
// Login Messages
// */
//+ (void) showLoadingLoginMessage;
//
//+ (void) showLoginSuccesfulMessage;
//+ (void) showLoginErrorMessage;
//
//+ (void) showEmailNotValidMessage;
//+ (void) showEmailRequiredMessage;
//
//+ (void) showPasswordRequiredMessage;
//+ (void) showPasswordNotValidMessage;
//
//+ (void) showPasswordRecoveryErrorMessage;
//+ (void) showPasswordRecoverySuccessfulMessage;
//
///**
// Account Messages
// */
//+ (void) showNameNotValidErrorMessage;
//+ (void) showSurNameNotValidErrorMessage;
//
//+ (void) showAccountUpdateSuccesfulMessage;
//
//+ (void) showAccountUpdateErrorMessage;
@end
