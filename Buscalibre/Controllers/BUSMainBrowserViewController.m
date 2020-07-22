//
//  BUSMainWebViewController.m
//  buscalibre
//
//  Created by Magnet SPA on 14-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSMainBrowserViewController.h"

#import "BUSItemSearch.h"
#import "NSString+BUSStringHelper.h"
#import "UIViewController+BUSViewControllerHelper.h"

@interface BUSMainBrowserViewController ()

@end

@implementation BUSMainBrowserViewController

@dynamic currentStoreKind;
@dynamic currentItemDetailsViewSize;
@dynamic currentItemDetailsStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set delegates and datasources
    self.topNavigationView.delegate = self;
    self.webContentView.delegate = self;
    self.itemDetailsView.delegate = self;
    
    // Add UITapGestureRecognizer on OverlayView
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayViewTouchUpsideAction:)];
    [self.overlayView addGestureRecognizer:tapRecognizer];
    self.overlayView.userInteractionEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Check if there is a currentStoreKind
    // if equal to None, then present the store selection view
    if (self.currentStoreKind == BUSWebContentViewKindNone) {
        [self presentStoreSelectionViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - Properties override

/**
 Setter for currentStoreKind
 Sets the storeKind directly in webContentView
 */
- (void)setCurrentStoreKind:(BUSWebContentViewKind)currentStoreKind {
    if (self.webContentView) {
        self.webContentView.kind = currentStoreKind;
    }
}

/**
 Getter for currentStoreKind
 Gets the storeKind directly from webContentView
 */
- (BUSWebContentViewKind)currentStoreKind {
    return self.webContentView.kind;
}

/**
 Setter for currentItemDetailViewSize
 Sets the viewSize directly in itemDetailsView
 */
- (void)setCurrentItemDetailsViewSize:(BUSItemDetailsViewSize)currentItemDetailsViewSize {
    if (self.itemDetailsView) {
        
        self.itemDetailsView.viewSize = currentItemDetailsViewSize;
        
        CGFloat itemDetailViewHeight = [self.itemDetailsView headerViewHeight];
        BOOL itemDetailViewHidden = NO;
        BOOL overlayViewHidden = YES;
        
        switch (currentItemDetailsViewSize) {
            case BUSItemDetailsViewSizeFull:
                
                itemDetailViewHeight = self.view.frame.size.height - [self getMinDistanceToTopForItemDetailsView];
                itemDetailViewHidden = NO;
                overlayViewHidden = NO;
                
                break;
                
            default:
                break;
        }
        
        self.itemDetailsViewHeightConstraint.constant = itemDetailViewHeight;
        
        void (^animations)(void) = ^{
            self.itemDetailsView.hidden = itemDetailViewHidden;
            self.overlayView.hidden = overlayViewHidden;
            
            [self.view layoutIfNeeded];
        };
        
        [UIView animateWithDuration:0.3
                         animations:animations];
        
    }
}

/**
 Getter for currentItemDetailViewSize
 Gets the viewSize directly from itemDetailsView
 */
- (BUSItemDetailsViewSize)currentItemDetailsViewSize {
    return self.itemDetailsView.viewSize;
}

/**
 Setter for currentItemDetailsStatus
 Sets the status directly in itemDetailsView
 */
- (void)setCurrentItemDetailsStatus:(BUSItemDetailsStatus)currentItemDetailsStatus {
    if (self.itemDetailsView) {
        self.itemDetailsView.status = currentItemDetailsStatus;
    }
}

/**
 Getter for currentItemDetailsStatus
 Gets the status directly from itemDetailsView
 */
- (BUSItemDetailsStatus)currentItemDetailsStatus {
    return self.itemDetailsView.status;
}

# pragma mark - Private methods

/**
 Returns the minimun distance to topView
 */
- (CGFloat)getMinDistanceToTopForItemDetailsView {
    return self.topNavigationView.frame.size.height + 30;
}

/**
 Presents the store selection view
 */
- (void)presentStoreSelectionViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    BUSStoreSelectionViewController *selectionView = (BUSStoreSelectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StoreSelectionSTB"];
    selectionView.delegate = self;
    
    [self presentViewController:selectionView
                       animated:YES
                     completion:nil];
}

/**
 Sets itemIdentifier on itemDetailsView
 */
- (void)loadItemDetailsViewWithItemSearch:(BUSItemSearch *)itemSearch {
    self.itemDetailsView.itemSearch = itemSearch;
}

/**
 Sets the currentItemDetailViewSize to sizeHeader when
 a touch over the overlayView in itemsDetails is received
 */
- (void)overlayViewTouchUpsideAction:(UITapGestureRecognizer *)sender {
    if (self.currentItemDetailsViewSize == BUSItemDetailsViewSizeFull) {
        self.currentItemDetailsViewSize = BUSItemDetailsViewSizeHeader;
    }
}

# pragma mark - BUSStoreSelectionViewControllerDelegate

- (void)storeSelectionViewWantsToLoadStoreKind:(BUSWebContentViewKind)storeKind {
    self.currentStoreKind = storeKind;
}

# pragma mark - BUSTopNavigationViewDelegate

- (void)topNavigationViewWantsToGoHome {
    [self presentStoreSelectionViewController];
    
}

- (void)topNavigationViewWantsToGoBack {
    [self.webContentView goBack];
}

- (void)topNavigationViewWantsToGoForward {
    [self.webContentView goForward];
}

- (void)topNavigationViewWantsToGoHelp {
    NSArray *itemSearchArray;
    itemSearchArray = [NSArray arrayWithObjects: @"site", @"code", nil];
    [self siteWantsToShowAlertViewWithTitleInput:@"¿Cómo podemos ayudarte?" andMessage:@"Ingresa tu email y déjanos tu consulta" itemSearchArray:itemSearchArray
     ];
    
    /*[self itemDetailsViewWantsToShowAlertViewWithTitle:@"Caution"
                                                         andMessage:@"Warning"
         ];*/
    
}

# pragma mark - BUSWebContentViewDelegate

- (void)webContentViewDidFoundItem {
    self.currentItemDetailsStatus = BUSItemDetailsStatusItemNotDifferentiated;
}

- (void)webContentViewDidFoundItemSearch:(BUSItemSearch *)itemSearch {
    
    if (![self.itemDetailsView.itemSearch isEqualToItemSearch:itemSearch]) {
        
        [self loadItemDetailsViewWithItemSearch:itemSearch];
    }
}

- (void)webContentViewDidNotFoundItem {
    self.currentItemDetailsStatus = BUSItemDetailsStatusNoItem;
    self.currentItemDetailsViewSize = BUSItemDetailsViewSizeHeader;
    self.itemDetailsView.itemSearch = nil;
}

- (void)webContentViewDidUpdateEstimatedProgress:(CGFloat)estimatedProgress {
    [self.progressView setProgress:estimatedProgress
                          animated:YES];
}

- (void)webContentViewIsLoadingContent:(BOOL)isLoadingContent {
    if (isLoadingContent) {
        self.currentItemDetailsStatus = BUSItemDetailsStatusIdle;
    } else {
        self.currentItemDetailsStatus = BUSItemDetailsStatusNoItem;
    }
    
    self.progressView.hidden = !isLoadingContent;
    self.progressView.progress = 0.0;
    
    self.topNavigationView.backButton.enabled = self.webContentView.webView.canGoBack;
    self.topNavigationView.forwardButton.enabled = self.webContentView.webView.canGoForward;
}

- (void)webContentViewWantsToShowAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    if ((![NSString stringIsNilOrEmpty:title] ||
        ![NSString stringIsNilOrEmpty:message]) && (![title isEqualToString:@"Error"]) ) {
        
        //NSLog(@"fallo");
        
        [self showAlertControllerWithTitle:title
                                   message:message
                          inViewController:self];
    }
}

# pragma mark - BUSItemDetailsViewDelegate

- (void)itemDetailsViewWantsToMoveWithGestureSender:(UIGestureRecognizer *)sender {
    // Checks if the sender is UITapGestureRecognizer
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        
        switch (self.currentItemDetailsViewSize) {
            case BUSItemDetailsViewSizeFull:
                self.currentItemDetailsViewSize = BUSItemDetailsViewSizeHeader;
                break;
                
            default:
                self.currentItemDetailsViewSize = BUSItemDetailsViewSizeFull;
                break;
        }
        
        // Checks if the sender is UIPanGestureRecognizer
    } else if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)sender;
        
        switch (panGesture.state) {
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged: {
                
                CGPoint locationInView = [panGesture locationInView:self.view];
                CGFloat topViewDistance = [self getMinDistanceToTopForItemDetailsView];
                
                if (locationInView.y >= topViewDistance) {
                    CGFloat viewHeight = self.view.frame.size.height;
                    self.itemDetailsViewHeightConstraint.constant = viewHeight - locationInView.y;
                }
                
                break;
            }
                
            case UIGestureRecognizerStateEnded: {
                CGPoint velocity = [panGesture velocityInView:self.view];
                
                if (velocity.y < 0.0) {
                    self.currentItemDetailsViewSize = BUSItemDetailsViewSizeFull;
                } else {
                    self.currentItemDetailsViewSize = BUSItemDetailsViewSizeHeader;
                }
                
                break;
            }
                
            default:
                self.currentItemDetailsViewSize = BUSItemDetailsViewSizeHeader;
                break;
        }
    }
}

- (void)itemDetailsViewWantsToShowAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    if (![NSString stringIsNilOrEmpty:title] ||
        ![NSString stringIsNilOrEmpty:message]) {
        
        [self showAlertControllerWithTitle:title
                                   message:message
                          inViewController:self   ];
    }
}

- (void)itemDetailsViewWantsToShowAlertViewWithTitleInput:(NSString *)title andMessage:(NSString *)message itemSearchArray:(NSArray *)itemSearchArray{
    if (![NSString stringIsNilOrEmpty:title] ||
        ![NSString stringIsNilOrEmpty:message]) {
        
        [self showAlertControllerWithTitleInput:title
                                   message:message
                          inViewController:self
                                itemSearchArray:itemSearchArray
         ];
    }
}

- (void)siteWantsToShowAlertViewWithTitleInput:(NSString *)title andMessage:(NSString *)message itemSearchArray:(NSArray *)itemSearchArray{
    if (![NSString stringIsNilOrEmpty:title] ||
        ![NSString stringIsNilOrEmpty:message]) {
        
        [self showAlertControllerWithTitleInputComment:title
                                        message:message
                               inViewController:self
                                itemSearchArray:itemSearchArray
         ];
    }
}

@end
