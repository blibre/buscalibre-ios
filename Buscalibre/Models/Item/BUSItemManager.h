//
//  BUSItemManager.h
//  buscalibre
//
//  Created by Magnet SPA on 30-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSApiManager.h"

FOUNDATION_EXPORT NSString * _Nonnull const BUSApiItemKeyNew;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiItemKeyNewPrime;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiItemKeyRefurbished;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiItemKeyUsed;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiItemKeyAirplane;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiItemKeyShip;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiItemKeyUri;

@class BUSItem;
@class BUSItemSearch;

typedef void(^BUSItemManagerResponseCallback)(BUSApiResult result, id _Nullable response);

@interface BUSItemManager : BUSApiManager

# pragma mark - Public methods

/**
 Requests item details by a given BUSItemSearch
 
 @params itemSearch Specific item search
 @params completionHandler As request is complete returns a BUSItemManagerResponseCallback
 */
- (void)requestItemDetailsForItemSearch:(BUSItemSearch * _Nonnull)itemSearch
                      completionHandler:(BUSItemManagerResponseCallback _Nonnull)completionHandler ;

/**
 Requests cart url from a specific item and itemSearch
 
 @params item Specific item
 @params itemSearch Specific item search
 @params completionHandler As request is complete returns a BUSItemManagerResponseCallback
 */
- (void)requestCartUrlForItem:(BUSItem * _Nonnull)item
                   itemSearch:(BUSItemSearch * _Nonnull)itemSearch
            completionHandler:(BUSItemManagerResponseCallback _Nonnull)completionHandler;

@end
