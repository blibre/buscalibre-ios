//
//  BUSApiManager.h
//  buscalibre
//
//  Created by Magnet SPA on 30-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BUSApiResult.h"

FOUNDATION_EXPORT NSString * _Nonnull const BUSApiKeyErrorCode;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiKeyError;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiKeyWarningCode;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiKeyWarning;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiKeySuccess;
FOUNDATION_EXPORT NSString * _Nonnull const BUSApiKeyResponse;

typedef void(^BUSResponseCallback)(BUSApiResult result, NSDictionary * _Nullable response);

@class BUSApiConnector;

@protocol BUSApiManagerProtocol <NSObject>

@required
+ (id _Nullable)sharedInstance;
- (NSString * _Nullable)apiRelativeUrlString;

@end

@interface BUSApiManager : NSObject <BUSApiManagerProtocol>

# pragma mark - Properties

@property (strong, nonatomic) BUSApiConnector * _Nullable apiConnector;

# pragma mark - Public methods

- (NSString * _Nullable)apiUrlStringWithRelativeUrl:(NSString * _Nullable)relativeUrl;

- (void)parseApiRequestResponse:(NSDictionary * _Nullable)response completionHandler:(BUSResponseCallback _Nullable)completionHandler;

- (BUSApiResult)apiResultWithSuccess:(BOOL)success code:(NSInteger)code message:(NSString * _Nullable)message;

@end
