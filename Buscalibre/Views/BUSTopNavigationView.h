//
//  BUSTopNavigationView.h
//  buscalibre
//
//  Created by Magnet SPA on 24-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BUSTopNavigationViewDelegate <NSObject>

@required
- (void)topNavigationViewWantsToGoBack;
- (void)topNavigationViewWantsToGoForward;
- (void)topNavigationViewWantsToGoHome;
- (void)topNavigationViewWantsToGoHelp;

@end

@interface BUSTopNavigationView : UIView

# pragma mark - Properties

@property (weak, nonatomic) id<BUSTopNavigationViewDelegate> delegate;

# pragma mark - IBOutlets

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UIButton *helpButton;

# pragma mark - Public methods

- (IBAction)backButtonAction:(id)sender;
- (IBAction)forwardButtonAction:(id)sender;
- (IBAction)storesButtonAction:(id)sender;
- (IBAction)helpButtonAction:(id)sender;

@end
