//
//  BUSItemSearch.h
//  buscalibre
//
//  Created by Magnet SPA on 11-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BUSItemSearch : NSObject

# pragma mark - Properties

@property (strong, nonatomic) NSString * _Nonnull code;
@property (strong, nonatomic) NSString * _Nonnull site;
@property (strong, nonatomic) NSString * _Nullable differentiator;

# pragma mark - Init

+ (instancetype _Nullable)createWithSite:(NSString * _Nonnull)site
                                    code:(NSString * _Nonnull)code
                          differentiator:(NSString * _Nullable)differentiator;

# pragma mark - Public methods

/**
 Compares BUSItemSearch with other one
 
 @params itemSearch BUSItemSearch to compare
 
 @return BOOL with condition after compare
 */
- (BOOL)isEqualToItemSearch:(BUSItemSearch * _Nonnull)itemSearch;

@end
