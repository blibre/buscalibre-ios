//
//  BUSMainWebViewController.h
//  buscalibre
//
//  Created by Magnet SPA on 14-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BUSItemDetailsView.h"
#import "BUSStoreSelectionViewController.h"
#import "BUSTopNavigationView.h"
#import "BUSWebContentView.h"

@class BUSItemDetailsView;

@interface BUSMainBrowserViewController : UIViewController <BUSStoreSelectionViewControllerDelegate,
BUSTopNavigationViewDelegate, BUSWebContentViewDelegate, BUSItemDetailsViewDelegate>

# pragma mark - Properties

/** Current WebContentView kind */
@property (nonatomic) BUSWebContentViewKind currentStoreKind;

/** Current ItemDetailsView size */
@property (nonatomic) BUSItemDetailsViewSize currentItemDetailsViewSize;

/** Current ItemDetailsView status */
@property (nonatomic) BUSItemDetailsStatus currentItemDetailsStatus;

# pragma mark - IBOulets

@property (strong, nonatomic) IBOutlet UIView *overlayView;

@property (strong, nonatomic) IBOutlet BUSTopNavigationView *topNavigationView;

@property (strong, nonatomic) IBOutlet BUSWebContentView *webContentView;

@property (strong, nonatomic) IBOutlet BUSItemDetailsView *itemDetailsView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *itemDetailsViewHeightConstraint;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@end
