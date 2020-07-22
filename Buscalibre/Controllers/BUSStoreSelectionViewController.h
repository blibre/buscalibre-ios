//
//  BUSStoreSelectionViewController.h
//  buscalibre
//
//  Created by Magnet SPA on 14-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BUSWebContentView.h"
#import "MyUINavigationController.h"
#import "TableViewController.h"

@protocol BUSStoreSelectionViewControllerDelegate <NSObject>

@required

/**
 Sets the currentStoreKind when a store is selected in StoreSelectionViewController
 */
- (void)storeSelectionViewWantsToLoadStoreKind:(BUSWebContentViewKind)storeKind;

@end

@interface BUSStoreSelectionViewController : UIViewController

# pragma mark - Properties

@property (weak, nonatomic) id<BUSStoreSelectionViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)showCodereaderPressed:(id)sender;


# pragma mark - Public methods

- (IBAction)amazonStoreButtonAction:(id)sender;
- (IBAction)ebayStoreButtonAction:(id)sender;



@end
