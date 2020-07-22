//
//  UIViewController+BUSViewControllerHelper.h
//  buscalibre
//
//  Created by Magnet SPA on 05-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(BUSViewControllerHelper) <UITextViewDelegate>


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
                           noHandler:(void (^)(UIAlertAction *action))noHandler;

/**
 Shows an alert controller over the defined view controller
 
 @params title Defined title for alertView
 @params message Defined message for alertView
 @params viewController viewController where the alert will be showed
 */
- (void)showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                    inViewController:(UIViewController *)viewController;


- (void)showAlertControllerWithTitleInput:(NSString *)title
                             message:(NSString *)message
                    inViewController:(UIViewController *)viewController
                          yesMessage:(NSString *)yesMessage
                           noMessage:(NSString *)noMessage
                          yesHandler:(void (^)(UIAlertAction *action))yesHandler
                           noHandler:(void (^)(UIAlertAction *action))noHandler
                               itemSearchArray:(NSArray *)itemSearchArray;

- (void)showAlertControllerWithTitleInput:(NSString *)title
                             message:(NSString *)message
                    inViewController:(UIViewController *)viewController
                          itemSearchArray:(NSArray *)itemSearchArray;

- (void)showAlertControllerWithTitleInputComment:(NSString *)title
                                  message:(NSString *)message
                         inViewController:(UIViewController *)viewController
                               yesMessage:(NSString *)yesMessage
                                noMessage:(NSString *)noMessage
                               yesHandler:(void (^)(UIAlertAction *action))yesHandler
                                noHandler:(void (^)(UIAlertAction *action))noHandler
                          itemSearchArray:(NSArray *)itemSearchArray;

- (void)showAlertControllerWithTitleInputComment:(NSString *)title
                                  message:(NSString *)message
                         inViewController:(UIViewController *)viewController
                          itemSearchArray:(NSArray *)itemSearchArray;

@end
