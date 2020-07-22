//
//  BUSItemSearch.m
//  buscalibre
//
//  Created by Magnet SPA on 11-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSItemSearch.h"

#import "NSString+BUSStringHelper.h"

@implementation BUSItemSearch

# pragma mark - Init

+ (instancetype)createWithSite:(NSString *)site code:(NSString *)code differentiator:(NSString *)differentiator {
    if ([NSString stringIsNilOrEmpty:code] ||
        [NSString stringIsNilOrEmpty:site]) {
        return nil;
    }
    
    BUSItemSearch *object = [[BUSItemSearch alloc] init];
    
    object.site = site;
    object.code = code;
    object.differentiator = differentiator;
    
    return object;
}

# pragma mark - Public methods

/**
 Compares BUSItemSearch with other one
 
 @params itemSearch BUSItemSearch to compare
 
 @return BOOL with condition after compare
 */
- (BOOL)isEqualToItemSearch:(BUSItemSearch *)itemSearch {
    
    BOOL sitesEqual = [self.site isEqualToString:itemSearch.site];
    BOOL codesEqual = [self.code isEqualToString:itemSearch.code];
    BOOL differentiatorsEqual = NO;
    
    if (self.differentiator && itemSearch.differentiator) {
        differentiatorsEqual  = [self.differentiator isEqualToString:itemSearch.differentiator];
        
    }  else if (!self.differentiator && !itemSearch.differentiator) {
        differentiatorsEqual = YES;
    }
    
    if (sitesEqual &&
        codesEqual &&
        differentiatorsEqual) {
        return YES;
    }
    
    return NO;
}

@end
