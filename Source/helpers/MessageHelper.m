//
//  MessageHelper.m
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import "MessageHelper.h"

@implementation MessageHelper
+ (void) showEmailNotValidMessage {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email no válido" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

+ (void) showEmailRequiredMessage {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Ingrese un Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

+ (void) showPasswordRequiredMessage {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Ingrese una Contraseña" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];

}

+ (void) showPasswordNotValidMessage {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Contraseña no válida" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
}


+ (void) showUserFullNameRequiredMessage {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Ingrese Nombre Completo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
}

+ (void) showEmailResetSendMessage {
    [SVProgressHUD showSuccessWithStatus:@"Email de reinicio enviado"];
}

+ (void) showEmailResetErrorMessage {
    [SVProgressHUD showErrorWithStatus:@"Error al enviar el reinicio de contraseña"];
}

+ (void) showUserNameTaken {
    [SVProgressHUD showErrorWithStatus:@"Usuario ya existe"];
}

+ (void) showErrorWithAccountSignUp {
    [SVProgressHUD showErrorWithStatus:@"Error al crear Cuenta"];
}

+ (void) showWelcomeMessage {
    [SVProgressHUD showSuccessWithStatus:@"Bienvenido"];
}

+ (void) showSignInError {
    [SVProgressHUD showErrorWithStatus:@"No se ha Logrado Ingresar"];
}

+ (void) showCannotCreateNewStoreOrderMessage {
    [SVProgressHUD showErrorWithStatus:@"Existe un Carro en espera de ser pagado. Por favor espere un momento antes de crear uno nuevo"];
}
@end
