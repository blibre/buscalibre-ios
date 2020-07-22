//
//  BUSItemDetailsView.m
//  buscalibre
//
//  Created by Magnet SPA on 14-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSItemDetailsView.h"

#import "BUSItem.h"
#import "BUSItemManager.h"
#import "BUSItemSearch.h"
#import "BUSShipmentCollectionViewCell.h"
#import "NSString+BUSStringHelper.h"
#import "UIColor+BUSCustomColors.h"
#import "UIView+BUSViewHelper.h"

static NSString * const reuseIdentifier = @"shipmentCell";

#define kNumberOfItems 8
#define kInitialSentence @"Ingresa a un producto para cotizar"
#define kNotDifferentiatedSentence @"Selecciona talla, color u otro para cotizar"
#define kSearchingSentence @"Cotizando..."
#define kWatchPriceSentence @"Ver cotización"
#define kNoPriceSentence @"No hay item a cotizar"
#define kCautionSentence @"Aviso"
#define kPricingErrorSentence @"Problema al cotizar"
#define kWaitingSentence @"Cargando el contenido..."
#define kCode10TitleSentence @"No pudimos cotizar este producto automáticamente"
#define kCode10TextSentence @"ingresa tu mail y en menos de 48 horas hábiles te enviaremos una cotización"
#define kAnalyticsKeyAmazon @"&utm_source=app_bl&utm_medium=app_bl&utm_campaign=app_te_traemos_amazon"
#define kAnalyticsKeyEbay @"&utm_source=app_bl&utm_medium=app_bl&utm_campaign=app_te_traemos_ebay"


@implementation BUSItemDetailsView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Loads from xib file
        NSArray *viewsArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                            owner:self
                                                          options:nil];
        
        for (id object in viewsArray) {
            if ([object isKindOfClass:[UIView class]]) {
                self.contentView = object;
                break;
            }
        }
        
        // Fill all the space
        self.contentView.frame = self.bounds;
        
        // Resize on super view resize
        self.contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        // Add the content subview
        [self addSubview:self.contentView];
        
        // Add a rounded border to buyButton
        [self.buyButton addRoundedBorderWithCornerRadius:5.0];
        
        // Register BUSShipmentCollectionViewCell
        NSBundle *mainBundle = [NSBundle mainBundle];
        UINib *nibName = [UINib nibWithNibName:@"BUSShipmentCollectionViewCell"
                                        bundle:mainBundle];
        
        // Register cell nib for users channels collection view
        [self.collectionView registerNib:nibName
              forCellWithReuseIdentifier:reuseIdentifier];
        
        // Add UIPanGestureRecognizer to HeaderView
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveView:)];
        [self.headerView addGestureRecognizer:panRecognizer];
        
        // Add UITapGestureRecognizer HeaderView
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveView:)];
        [self.headerView addGestureRecognizer:tapRecognizer];
    }
    
    return self;
}

# pragma mark - Properties

/**
 Sets BUSItemDetailsViewSize viewSize
 and set the chevronImageView
 */
- (void)setViewSize:(BUSItemDetailsViewSize)viewSize {
    _viewSize = viewSize;
    
    switch (_viewSize) {
        case BUSItemDetailsViewSizeFull:
            [self.chevronImageView setImage:[UIImage imageNamed:@"Chevron-Down-White-40px"]];
            
            // When view is setted to show at this size
            // Check if there is a pending warningMessage to show
            // If there is it, then, show it as AlertView in the parent controller
            if (![NSString stringIsNilOrEmpty:self.warningMessage]) {
                if (self.delegate) {
                    [self.delegate itemDetailsViewWantsToShowAlertViewWithTitle:kCautionSentence
                        andMessage:self.warningMessage
                     ];
                }
                
                self.warningMessage = nil;
            }
            
            break;
            
        default:
            [self.chevronImageView setImage:[UIImage imageNamed:@"Chevron-Up-White-40px"]];
            break;
    }
}

/**
 Sets BUSItemDetailsStatus status
 and set header message and action
 */
- (void)setStatus:(BUSItemDetailsStatus)status {
    _status = status;
    
    switch (_status) {
        case BUSItemDetailsStatusItemQuoted:
            
            [self allowShowDetails:YES
                 withHeaderMessage:kWatchPriceSentence];
            
            break;
            
        case BUSItemDetailsStatusQuotingItem:
            
            [self allowShowDetails:NO
                 withHeaderMessage:kSearchingSentence];
            
            break;
            
        case BUSItemDetailsStatusItemNotDifferentiated:
            
            [self allowShowDetails:NO
                 withHeaderMessage:kNotDifferentiatedSentence];
            
            break;
            
        case BUSItemDetailsStatusItemError:
            
            [self allowShowDetails:NO
                 withHeaderMessage:kPricingErrorSentence];
            
            break;
            
        case BUSItemDetailsStatusIdle:
            
            [self allowShowDetails:NO
                 withHeaderMessage:kWaitingSentence];
            
            [self showLoadingActivityIndicatorOnHeader:YES];
            
            
            break;
            
        default:
            
            [self cleanDetails];
            
            [self showLoadingActivityIndicatorOnHeader:NO];
            
            break;
    }
}

/**
 Sets BUSItemSearch itemSearch
 If it exists and is not equal to the previous one requested
 Then, request it to the BUSItemManager
 */
- (void)setItemSearch:(BUSItemSearch *)itemSearch {
    NSLog(@"setItemSearch");
    if (itemSearch) {
        if (![itemSearch isEqualToItemSearch:_itemSearch]) {
            
            self.status = BUSItemDetailsStatusQuotingItem;
            
            [self showLoadingActivityIndicatorOnHeader:YES];
            
            
            [[BUSItemManager sharedInstance] requestItemDetailsForItemSearch:itemSearch
                    completionHandler:^(BUSApiResult result, id  _Nullable response) {
                                                               
                        [self showLoadingActivityIndicatorOnHeader:NO];
                                                               
                        // In case that the user changed to other state
                       if (self.status == BUSItemDetailsStatusQuotingItem) {
                          NSString *message;
                           
                          if (result.message) {
                            message = [NSString stringWithUTF8String:result.message];
                            }
                           
                            if (result.success)
                            {
                                
                                
                                self.itemShippingDetails = response;
                                                                       
                                self.status = BUSItemDetailsStatusItemQuoted;
                                
                                
                                                                       
                                if (![NSString stringIsNilOrEmpty:message]) {
                                    self.warningMessage = message;
                                }
                                                                       
                           } else {
                                self.status = BUSItemDetailsStatusItemError;
                                if (self.delegate && message)
                                {
                                    NSArray *itemSearchArray;
                                    itemSearchArray = [NSArray arrayWithObjects: itemSearch.site, itemSearch.code, nil];
                                    if(result.code == 10){
//                                        NSLog(@"site:%@",itemSearch.site);
//                                        NSLog(@"code:%@",itemSearch.code);
                                        
                                        [self.delegate itemDetailsViewWantsToShowAlertViewWithTitleInput:kCode10TitleSentence andMessage:kCode10TextSentence itemSearchArray:itemSearchArray
                                         ];

                                        
                                    }else{
                                        [self.delegate itemDetailsViewWantsToShowAlertViewWithTitle:kPricingErrorSentence
                                                                                         andMessage:message
];
                                    }
                                    

                                }
                            }
                }
                                                               
                }];
            
        }
    }
    
    _itemSearch = itemSearch;
}

/**
 Sets NSMutableArray itemShippingDetails
 Stores the requested items shipping details (BUSItem)
 */
- (void)setItemShippingDetails:(NSMutableArray *)itemShippingDetails {
    _itemShippingDetails = itemShippingDetails;
    
    [self.collectionView reloadData];
    
    if (_itemShippingDetails) {
        if (_itemShippingDetails.count > 0) {
            self.detailsContainerView.hidden = NO;
            
            [self selectCellInCollectionViewWithBiggestPriority];
        } else {
            self.detailsContainerView.hidden = YES;
        }
    } else {
        self.detailsContainerView.hidden = YES;
    }
}

/**
 Sets BUSItem selectedItem
 Stores the selected item from the collectionView.
 */
- (void)setSelectedItem:(BUSItem *)selectedItem {
    _selectedItem = selectedItem;
    
    if (_selectedItem) {
        self.buyButton.enabled = YES;
        
    } else {
        self.buyButton.enabled = NO;
    }
}

# pragma mark - Public methods

/**
 Returns the current headerView height
 
 @return CGFloat height size
 */
- (CGFloat)headerViewHeight {
    return self.headerViewHeightConstraint.constant;
}

/**
 Buy Button action
 */
- (IBAction)buyButtonAction:(id)sender {
    if (self.selectedItem &&
        self.itemSearch) {
        
        [self loadingCartItemUrl:YES];
        
        // Request cart url for a selected item with the itemSearch
        // Then, redirect to buscalibre cart in Safari
        [[BUSItemManager sharedInstance] requestCartUrlForItem:self.selectedItem
                                                    itemSearch:self.itemSearch
                                             completionHandler:^(BUSApiResult result, id response) {
                                                 if (result.success) {
                                                     if ([response isKindOfClass:[NSString class]]) {
                                                         
                                                         NSString *urlString;
                                                         urlString = [NSString stringWithFormat:@"%@%@",response, kAnalyticsKeyAmazon];
                                                         
                                                         if ([self.itemSearch.site isEqualToString:@"ebay"]) {
                                                             urlString = [NSString stringWithFormat:@"%@%@",response, kAnalyticsKeyEbay];
                                                         }
                                                        
                                                         NSURL *urlToOpen = [NSURL URLWithString:urlString];
                                                         
                                                         [[UIApplication sharedApplication] openURL:urlToOpen];
                                                     }
                                                     
                                                 } else {
                                                     NSString *alertTitle = @"Error";
                                                     NSString *message = @"Error";
                                                     
                                                     if (result.message) {
                                                         message = [NSString stringWithUTF8String:result.message];
                                                     }
                                                     
                                                     if (self.delegate) {
                                                         [self.delegate itemDetailsViewWantsToShowAlertViewWithTitle:alertTitle
                                                                                                          andMessage:message
                                                          
                                                          ];
                                                     }
                                                 }
                                                 
                                                 [self loadingCartItemUrl:NO];
                                             }];
    }
}

# pragma mark - Private methods

/**
 Cleans the view
 */
- (void)cleanDetails {
    self.itemShippingDetails = nil;
    self.warningMessage = nil;
    self.selectedItem = nil;
    
    [self allowShowDetails:NO
         withHeaderMessage:kInitialSentence];
}

/**
 Gestures selector methods
 When a moveView selector is called with a sender
 Sends it to the parent controller
 */
- (void)moveView:(UIGestureRecognizer *)sender {
    if (self.delegate) {
        [self.delegate itemDetailsViewWantsToMoveWithGestureSender:sender];
    }
}

/**
 Selects a cell in the collection view by priority
 Transport priority -> Airplane > Ship
 condition priority -> New, NewPrime, Used, Refurbished
 */
- (void)selectCellInCollectionViewWithBiggestPriority {
    if (self.itemShippingDetails &&
        self.itemShippingDetails.count > 0) {
        // Get a item by priority
        BUSItem *item = [self getItemByPriorityFromItems:self.itemShippingDetails];
        
        // Set the item as selectedItem
        self.selectedItem = item;
        
        // Get the row for the item
        NSInteger row = [self getRowIntegerForItem:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row
                                                    inSection:0];
        
        // Sets the row as selected in the collection view
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self.collectionView selectItemAtIndexPath:indexPath
                                          animated:YES
                                    scrollPosition:UICollectionViewScrollPositionNone];
    }
}

/**
 Returns a BUSItem for a specific row
 */
- (BUSItem *)getItemForIndexPathRowInt:(NSInteger)indexPathRow {
    BUSItem *item = nil;
    
    // Columns
    // (Airplane - Ship)
    NSInteger transport = (indexPathRow % 2);
    
    // rows
    // (New - New prime - Refurbished - Used)
    NSInteger condition;
    
    NSInteger rowAux = indexPathRow - transport;
    condition = rowAux / 2;
    
    transport += 1;
    condition += 1;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"condition == %d && transport == %d", condition, transport];
    NSArray *filteredArray = [self.itemShippingDetails filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0) {
        item = filteredArray.firstObject;
    }
    
    return item;
}

/**
 Returns a row NSInteger for item
 */
- (NSInteger)getRowIntegerForItem:(BUSItem *)item {
    if (item) {
        return (item.condition - 1) * 2 + (item.transport - 1);
    }
    
    return 0;
}

/**
 Returns a BUSItem by transport and condition priority
 Transport priority -> Airplane > Ship
 condition priority -> New, NewPrime, Used, Refurbished
 */
- (BUSItem *)getItemByPriorityFromItems:(NSArray *)itemsArray {
    BUSItem *item = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.transport == %@.@min.transport", itemsArray];
    NSArray *filteredArray = [itemsArray filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0) {
        if (filteredArray.count == 1) {
            item = filteredArray.firstObject;
            
        } else {
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"condition" ascending:YES];
            NSArray *sortDescriptorArray = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray = [filteredArray sortedArrayUsingDescriptors:sortDescriptorArray];
            
            item = sortedArray.firstObject;
        }
    }
    
    return item;
}

/**
 Allow to show details view adding a headerMessage
 */
- (void)allowShowDetails:(BOOL)allow withHeaderMessage:(NSString *)headerMessage {
    if (headerMessage) {
        self.headerMessageLabel.text = headerMessage;
    }
    
    self.chevronImageView.hidden = !allow;
    self.headerView.userInteractionEnabled = allow;
    
    if (allow) {
        self.headerView.backgroundColor = [[UIColor alloc] busGreenColor];
    } else {
        self.headerView.backgroundColor = [[UIColor alloc] busPrimaryColor];
    }
}

/**
 Shows/Hides an activity indicator view over the header view
 */
- (void)showLoadingActivityIndicatorOnHeader:(BOOL)loading {
    self.headerActivityContainerWidthConstraint.active = loading;
    
    if (loading) {
        [self.headerActivityIndicatorView startAnimating];
    } else {
        [self.headerActivityIndicatorView stopAnimating];
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self layoutIfNeeded];
                     }];
}


/**
 Shows/Hides an activity indicator view over the buy button
 when is requesting a cart url
 */
- (void)loadingCartItemUrl:(BOOL)loading {
    self.buyButton.selected = loading;
    
    if (loading) {
        [self.buyButtonActivityIndicatorView startAnimating];
        
    } else {
        [self.buyButtonActivityIndicatorView stopAnimating];
    }
}

# pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // If there are itemShippingDetails
    // Then, show the 8 options
    if (self.itemShippingDetails.count > 0) {
        return kNumberOfItems;
    }
    
    // If there are not itemShippingDetails
    // Then, nothing to show
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BUSShipmentCollectionViewCell *cell = (BUSShipmentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                                                     forIndexPath:indexPath];
    
    cell.item = [self getItemForIndexPathRowInt:indexPath.row];
    
    return cell;
}

# pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat widthSize = self.collectionView.frame.size.width/2;
    CGFloat heightSize = self.collectionView.frame.size.height/4;
    
    return CGSizeMake(widthSize, heightSize);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedItem = [self getItemForIndexPathRowInt:indexPath.row];
}


@end
