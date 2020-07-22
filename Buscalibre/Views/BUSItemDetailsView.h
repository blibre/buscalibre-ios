//
//  BUSItemDetailsView.h
//  buscalibre
//
//  Created by Magnet SPA on 14-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>

/** ENUM with defined sizes of itemDetailsView */
typedef NS_ENUM(NSUInteger, BUSItemDetailsViewSize) {
    BUSItemDetailsViewSizeHeader,
    BUSItemDetailsViewSizeFull
};

/** ENUM with ItemDetails status */
typedef NS_ENUM(NSUInteger, BUSItemDetailsStatus) {
    BUSItemDetailsStatusIdle,
    BUSItemDetailsStatusNoItem,
    BUSItemDetailsStatusItemNotDifferentiated,
    BUSItemDetailsStatusQuotingItem,
    BUSItemDetailsStatusItemQuoted,
    BUSItemDetailsStatusItemError
};

@class BUSItem;
@class BUSItemSearch;

@protocol BUSItemDetailsViewDelegate <NSObject>

@required

/** To report that a UIGestureRecognizer was detected over the overlayView */
- (void)itemDetailsViewWantsToMoveWithGestureSender:(UIGestureRecognizer *)sender;

/** To report that the view wants to show a alert view */
- (void)itemDetailsViewWantsToShowAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)itemDetailsViewWantsToShowAlertViewWithTitleInput:(NSString *)title andMessage:(NSString *)message itemSearchArray:(NSArray *)itemSearchArray;

@end

@interface BUSItemDetailsView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

# pragma mark - Properties

@property (weak, nonatomic) id<BUSItemDetailsViewDelegate> delegate;

/** viewSize for the view, BUSItemDetailsViewSizeHeader by default */
@property (nonatomic) BUSItemDetailsViewSize viewSize;

/** Status of the view, BUSItemDetailsStatusNoItem bu default */
@property (nonatomic) BUSItemDetailsStatus status;

/** The itemSearch to request */
@property (strong, nonatomic) BUSItemSearch *itemSearch;

/** Stores the itemDetails from the request */
@property (strong, nonatomic) NSMutableArray *itemShippingDetails;

/** Stores if there is a warning message for the item */
@property (strong, nonatomic) NSString *warningMessage;

/** Stores the collectionView selected item */
@property (weak, nonatomic) BUSItem *selectedItem;

# pragma mark - IBOutlets

@property (strong, nonatomic) IBOutlet UIView *contentView;

/** Header */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIView *activityContainerView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerActivityContainerWidthConstraint;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *headerActivityIndicatorView;

@property (strong, nonatomic) IBOutlet UILabel *headerMessageLabel;

@property (strong, nonatomic) IBOutlet UIImageView *chevronImageView;

/** Body */
@property (strong, nonatomic) IBOutlet UIView *detailsContainerView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIButton *buyButton;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *buyButtonActivityIndicatorView;

# pragma mark - Public methods

/**
 Returns the current headerView height
 
 @return CGFloat height size
 */
- (CGFloat)headerViewHeight;

/** 
 Buy Button action
 */
- (IBAction)buyButtonAction:(id)sender;

@end
