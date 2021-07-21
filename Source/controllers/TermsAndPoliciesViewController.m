//
//  TermsAndPoliciesViewController.m
//  ZilogCafe
//
//  Created by Camilo on 04-10-13.
//
//

#import "TermsAndPoliciesViewController.h"

@interface TermsAndPoliciesViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *barTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsAndPoliciesViewController

- (void) viewWillAppear:(BOOL)animated {
    // Set web page terms of service
    self.barTitle.title = @"Términos de Servicio";

    NSString * htmlFile = @"terms";
    
    if(![self.shouldOpenTermsOfService boolValue]) {
        // set web page policies
        self.barTitle.title = @"Políticas de Seguridad";
        htmlFile = @"policies";
    }
    
#pragma message "TODO: Cargar via Web a una URL"
    NSURL * url = [[NSBundle mainBundle] URLForResource:htmlFile withExtension:@"html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
