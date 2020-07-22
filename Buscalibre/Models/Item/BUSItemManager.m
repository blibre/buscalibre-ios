//
//  BUSItemManager.m
//  buscalibre
//
//  Created by Magnet SPA on 30-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSItemManager.h"

#import <AFNetworking.h>
#import "NSString+BUSStringHelper.h"
#import "BUSItem.h"
#import "BUSItemSearch.h"

NSString * const BUSApiItemKeyNew = @"new";
NSString * const BUSApiItemKeyNewPrime = @"new prime";
NSString * const BUSApiItemKeyRefurbished = @"refurbished";
NSString * const BUSApiItemKeyUsed = @"used";
NSString * const BUSApiItemKeyAirplane = @"avion";
NSString * const BUSApiItemKeyShip = @"barco";
NSString * const BUSApiItemKeyUri = @"uri";

#define kCodeString @"codigo"
#define kSiteString @"sitio"
#define kDifferentiatorString @"diff"
#define kShippingString @"envio"
#define kConditionString @"condition"

#define kNoItemToSearch @"No item or itemSearch for request"

@implementation BUSItemManager

# pragma mark - sharedInstance

+ (id)sharedInstance {
    static BUSItemManager *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

# pragma mark - Methods override

- (NSString *)apiRelativeUrlString {
    return @"app";
}

# pragma mark - Public methods

/**
 Requests item details by a given BUSItemSearch
 
 @params itemSearch Specific item search
 @params completionHandler As request is complete returns a BUSItemManagerResponseCallback
 */
- (void)requestItemDetailsForItemSearch:(BUSItemSearch *)itemSearch completionHandler:(BUSItemManagerResponseCallback)completionHandler {
    if (!itemSearch) {
        BUSApiResult errorResult = [self apiResultWithSuccess:NO
                                                         code:0
                                                      message:kNoItemToSearch];
        
        completionHandler(errorResult, nil);
        
        return;
    }
    
    NSString *urlString = [self apiUrlStringWithRelativeUrl:@"-price"];
    
    

    NSMutableDictionary *parameters = [self getParametersFromItemSearch:itemSearch];
    
    NSLog(@"urlString %@", urlString);
    NSLog(@"parameters %@", parameters);
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

             [self parseItemDetailsApiRequestResponse:responseObject
                                    completionHandler:completionHandler];
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             BUSApiResult errorApiResult = [self apiResultWithSuccess:NO
                                                                 code:error.code
                                                              message:error.localizedDescription];
             
             completionHandler(errorApiResult, nil);
         }];
}

/**
 Requests cart url from a specific item and itemSearch
 
 @params item Specific item
 @params itemSearch Specific item search
 @params completionHandler As request is complete returns a BUSItemManagerResponseCallback
 */
- (void)requestCartUrlForItem:(BUSItem *)item itemSearch:(BUSItemSearch *)itemSearch completionHandler:(BUSItemManagerResponseCallback)completionHandler {
    if (!item || !itemSearch) {
        BUSApiResult errorResult = [self apiResultWithSuccess:NO
                                                         code:0
                                                      message:kNoItemToSearch];
        
        completionHandler(errorResult, nil);
        
        return;
    }
    
    NSString *urlString = [self apiUrlStringWithRelativeUrl:@"-cart"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addEntriesFromDictionary:[self getParametersFromItemSearch:itemSearch
                                                                   andItem:item]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self parseCartUrlApiRequestResponse:responseObject
                                completionHandler:completionHandler];
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             BUSApiResult errorApiResult = [self apiResultWithSuccess:NO
                                                                 code:error.code
                                                              message:error.localizedDescription];
             
             completionHandler(errorApiResult, nil);
         }];
    
    
}

# pragma mark - Private methods

/**
 Returns an array with all the condition keys
 
 @return NSArray Array with condition key strings
 */
- (NSArray<NSString *> *)conditionKeys {
    return @[
             BUSApiItemKeyNew,
             BUSApiItemKeyNewPrime,
             BUSApiItemKeyRefurbished,
             BUSApiItemKeyUsed
             ];
}

/**
 Returns an array with all the transport keys
 
 @return NSArray Array with transport key strings
 */
- (NSArray<NSString *> *)transportKeys {
    return @[
             BUSApiItemKeyAirplane,
             BUSApiItemKeyShip
             ];
}

- (NSMutableDictionary *)getParametersFromItemSearch:(BUSItemSearch *)itemSearch andItem:(BUSItem *)item {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    // Check if there is a itemSearch
    // If is there is not a itemSearch, return the empty object
    if (itemSearch) {
        [parameters setValue:itemSearch.site
                      forKey:kSiteString];
        [parameters setValue:itemSearch.code
                      forKey:kCodeString];
        
        if (![NSString stringIsNilOrEmpty:itemSearch.differentiator]) {
            [parameters setValue:itemSearch.differentiator
                          forKey:kDifferentiatorString];
        }
    } else {
        return parameters;
    }
    
    if (item) {
        [parameters setValue:[item getStringTransportType]
                      forKey:kShippingString];
        
        if ([itemSearch.site isEqualToString:@"amazon"]) {
            [parameters setValue:[item getStringConditionType]
                          forKey:kConditionString];
        }
    }
    
    return parameters;
}

- (NSMutableDictionary *)getParametersFromItemSearch:(BUSItemSearch *)itemSearch {
    return [self getParametersFromItemSearch:itemSearch
                                     andItem:nil];
}

/**
 Parse the JSON for the ItemDetails request
 */
- (void)parseItemDetailsApiRequestResponse:(NSDictionary *)response
                         completionHandler:(BUSItemManagerResponseCallback)completionHandler {
    
    [self parseApiRequestResponse:response
                completionHandler:^(BUSApiResult result, NSDictionary * _Nullable response) {
                    
                    if (result.success) {
                        NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
                        
                        for (NSString *conditionKey in [self conditionKeys]) {
                            if ([response objectForKey:conditionKey]) {
                                
                                NSDictionary *conditionDictionary = [response objectForKey:conditionKey];
                                
                                for (NSString *transportKey in [self transportKeys]) {
                                    if ([conditionDictionary objectForKey:transportKey]) {
                                        
                                        NSDictionary *itemDictionary = [conditionDictionary objectForKey:transportKey];
                                        
                                        BUSItem *item = [BUSItem createItemWithDictionary:itemDictionary
                                                                          conditionString:conditionKey
                                                                          transportString:transportKey];
                                        
                                        if (item) {
                                            [itemsArray addObject:item];
                                        }
                                    }
                                }
                            }
                        }
                        
                        completionHandler(result, itemsArray);
                        
                    } else {
                        completionHandler(result, nil);
                    }
                }];
}

/**
 Parse the JSON for the cart url request
 */
- (void)parseCartUrlApiRequestResponse:(NSDictionary *)response
                     completionHandler:(BUSItemManagerResponseCallback)completionHandler {
    
    [self parseApiRequestResponse:response
                completionHandler:^(BUSApiResult result, NSDictionary * _Nullable response) {
                    
                    if (result.success) {
                        NSString *cartUrlString = [response objectForKey:BUSApiItemKeyUri];
                        
                        completionHandler(result, cartUrlString);
                        
                    } else {
                        completionHandler(result, nil);
                    }
                }];
}

@end
