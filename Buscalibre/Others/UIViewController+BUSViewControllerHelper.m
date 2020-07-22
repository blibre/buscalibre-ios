//
//  UIViewController+BUSViewControllerHelper.m
//  buscalibre
//
//  Created by Magnet SPA on 05-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "UIViewController+BUSViewControllerHelper.h"
#import "AFNetworking.h"
#import "UITextField+Max.h"

@implementation UIViewController (BUSViewControllerHelper)

# pragma mark - Alert controller

/**
 Shows an alert controller over the defined view controller
 
 @params title Defined title for alertView
 @params message Defined message for alertView
 @params viewController viewController where the alert will be showed
 @params yesMessage Message for yes option boton on alertView
 @params noMessage Message for no option boton on alertView
 @params yesHandler Function to completion after yes button action
 @params noHandler Function to completion after no button action
 */
- (void)showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                    inViewController:(UIViewController *)viewController
                          yesMessage:(NSString *)yesMessage
                           noMessage:(NSString *)noMessage
                          yesHandler:(void (^)(UIAlertAction *action))yesHandler
                           noHandler:(void (^)(UIAlertAction *action))noHandler {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:yesMessage
                                                 style:UIAlertActionStyleDefault
                                               handler:yesHandler];
    [alertController addAction:ok];
    
    if (noMessage) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:noMessage
                                                         style:UIAlertActionStyleCancel
                                                       handler:noHandler];
        
        [alertController addAction:cancel];
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

/**
 Shows an alert controller over the defined view controller
 
 @params title Defined title for alertView
 @params message Defined message for alertView
 @params viewController viewController where the alert will be showed
 */
- (void)showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                    inViewController:(UIViewController *)viewController
{
    [self showAlertControllerWithTitle:title
                               message:message
                      inViewController:viewController
                            yesMessage:@"Ok"
                             noMessage:nil
                            yesHandler:nil
                             noHandler:nil];
}


- (void)showAlertControllerWithTitleInput:(NSString *)title
                             message:(NSString *)message
                    inViewController:(UIViewController *)viewController
                          yesMessage:(NSString *)yesMessage
                           noMessage:(NSString *)noMessage
                          yesHandler:(void (^)(UIAlertAction *action))yesHandler
                           noHandler:(void (^)(UIAlertAction *action))noHandler
                           itemSearchArray:(NSArray *)itemSearchArray{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert
                                          
                                          ];
    
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:yesMessage
//                                                 style:UIAlertActionStyleDefault
//                                               handler:yesHandler];
//    [alertController addAction:ok];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:yesMessage style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * emailfield = textfields[0];
//        NSLog(@"email:%@",emailfield.text);
//        NSLog(@"site:%@",itemSearchArray[0]);
        
        // Send email
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *parameters = @{
                                     
                                     @"codigo": itemSearchArray[1],
                                     @"sitio": itemSearchArray[0],
                                     @"email": emailfield.text,
                                     
                                     };
        if(emailfield.text){
            [manager GET:@"https://www.buscalibre.cl/v2/app-mail"
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSLog(@"message:%@",responseObject[@"response"][@"message"]);
                     [self showAlertControllerWithTitle:responseObject[@"response"][@"message"]
                                                message:@""
                                       inViewController:viewController
                                             yesMessage:@"Ok"
                                              noMessage:nil
                                             yesHandler:nil
                                              noHandler:nil];
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                 }];
        }

        
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"email";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
    }];
    
    
    if (noMessage) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:noMessage
                                                         style:UIAlertActionStyleCancel
                                                       handler:noHandler];
        
        [alertController addAction:cancel];
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}


- (void)showAlertControllerWithTitleInput:(NSString *)title
                             message:(NSString *)message
                    inViewController:(UIViewController *)viewController
                     itemSearchArray:(NSArray *)itemSearchArray
{
    
    
    [self showAlertControllerWithTitleInput:title
                               message:message
                      inViewController:viewController
                            yesMessage:@"Enviar"
                             noMessage:nil
                            yesHandler:nil
                             noHandler:nil
                            itemSearchArray:itemSearchArray];
}

- (void)showAlertControllerWithTitleInputComment:(NSString *)title
                                  message:(NSString *)message
                         inViewController:(UIViewController *)viewController
                               yesMessage:(NSString *)yesMessage
                                noMessage:(NSString *)noMessage
                               yesHandler:(void (^)(UIAlertAction *action))yesHandler
                                noHandler:(void (^)(UIAlertAction *action))noHandler
                          itemSearchArray:(NSArray *)itemSearchArray{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert
                                          
                                          ];
    
    //    UIAlertAction *ok = [UIAlertAction actionWithTitle:yesMessage
    //                                                 style:UIAlertActionStyleDefault
    //                                               handler:yesHandler];
    //    [alertController addAction:ok];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:yesMessage style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * emailfield = textfields[0];
        //UITextField * consultafield = textfields[1];
        NSString * consulta;
        
        for (UITextView *subview in alertController.view.subviews) {
            if ([subview isKindOfClass:[UITextView class]]) {
                //NSLog(@"consulta:%@",subview.text);
                consulta = subview.text;
    
            }
        }
        
        
        
        // Send email
        //NSString *comentario = [NSString stringWithFormat: @"%@ : %@", emailfield.text, consulta];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *parameters = @{
                                     
//                                  @"consulta": consulta,
//                                  @"email": emailfield.text,
                                    @"comentario": consulta,
                                    @"email": emailfield.text,
                                     
                                     };
        if(emailfield.text && consulta){
            
            [manager GET:@"https://www.buscalibre.cl/v2/app-comment"
                parameters:parameters
                progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     //NSLog(@"message:%@",responseObject[@"response"][@"message"]);
                    //NSLog(@"consulta:%@",consulta);
                    [self showAlertControllerWithTitle:@"Consulta enviada."
                                                message:@""
                                       inViewController:viewController
                                             yesMessage:@"Ok"
                                              noMessage:nil
                                             yesHandler:nil
                                              noHandler:nil];
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     //NSLog(@"consulta:%@",consulta);
                 }];
            
            
        }
        
        
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.0]}];
        
        textField.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.0];
        textField.maxLength = 50;
        

        
    }];
    
    alertController.view.autoresizesSubviews = YES;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.editable = YES;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.text = @"consulta";
    textView.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.0];
    textView.userInteractionEnabled = YES;
    textView.backgroundColor = [UIColor whiteColor];
    textView.scrollEnabled = YES;
    textView.layer.borderWidth = 0.0f;
    textView.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] CGColor];
    textView.layer.cornerRadius = 5;
    textView.delegate = self;
  

   
    NSLayoutConstraint *leadConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-17.0];
    NSLayoutConstraint *trailConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:17.0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-110.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:58.0];
    [alertController.view addSubview:textView];
    [NSLayoutConstraint activateConstraints:@[leadConstraint, trailConstraint, topConstraint, bottomConstraint]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        //textField.placeholder = @"relleno";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.borderColor = [[UIColor whiteColor] CGColor];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    
        //textField.placeholder = @"relleno";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.borderColor = [[UIColor whiteColor] CGColor];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        //textField.placeholder = @"relleno";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.borderColor = [[UIColor whiteColor] CGColor];
    }];
    
    
    if (noMessage) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:noMessage
                                                         style:UIAlertActionStyleCancel
                                                       handler:noHandler];
        
        [alertController addAction:cancel];
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}


- (void)showAlertControllerWithTitleInputComment:(NSString *)title
                                  message:(NSString *)message
                         inViewController:(UIViewController *)viewController
                          itemSearchArray:(NSArray *)itemSearchArray
{
    
    
    
    [self showAlertControllerWithTitleInputComment:title
                                    message:message
                           inViewController:viewController
                                 yesMessage:@"Enviar"
                                  noMessage:nil
                                 yesHandler:nil
                                  noHandler:nil
                            itemSearchArray:itemSearchArray];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
