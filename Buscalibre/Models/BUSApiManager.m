//
//  BUSApiManager.m
//  buscalibre
//
//  Created by Magnet SPA on 30-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSApiManager.h"

#import "BUSApiConnector.h"

NSString * const BUSApiKeyErrorCode = @"error_code";
NSString * const BUSApiKeyError = @"error";
NSString * const BUSApiKeyWarningCode = @"warning_code";
NSString * const BUSApiKeyWarning = @"warning";
NSString * const BUSApiKeySuccess = @"success";
NSString * const BUSApiKeyResponse = @"response";

@implementation BUSApiManager

+ (id)sharedInstance {
    NSAssert(YES, @"This method should be implemented when subclassing");
    return nil;
}

- (id)init {
    self = [super init];
    if (self) {
        self.apiConnector = [[BUSApiConnector alloc] init];
    }
    return self;
}

#pragma mark - Compose Urls

- (NSString *)apiUrlStringWithRelativeUrl:(NSString*)relativeUrl {
    NSArray *urlArray = @[self.apiConnector.apiUrlString,
                          [self apiRelativeUrlString],
                          relativeUrl];
    
    return [urlArray componentsJoinedByString:@""];
}

# pragma mark - BUSApiConnectorProtocol

- (NSString *)apiRelativeUrlString {
    NSLog(NSLocalizedString(@"If the request isn't working you probably need to implement MNCLApiManagerProtocol on your manager",nil));
    return @"";
}

# pragma mark - Parser

- (void)parseApiRequestResponse:(NSDictionary *)requestResponse completionHandler:(BUSResponseCallback)completionHandler {
    if ([requestResponse isKindOfClass:[NSDictionary class]]) {
        
        BOOL success = [[requestResponse objectForKey:BUSApiKeySuccess] boolValue];
        
        if (success) {
            NSInteger warningCode = 0;
            NSString *warningMessage = @"";
            NSDictionary *response = nil;
            
            if ([requestResponse objectForKey:BUSApiKeyWarningCode]) {
                warningCode = [[requestResponse objectForKey:BUSApiKeyWarningCode] integerValue];
            }
            
            if ([requestResponse objectForKey:BUSApiKeyWarning]) {
                warningMessage = [requestResponse objectForKey:BUSApiKeyWarning];
            }
            
            if ([requestResponse objectForKey:BUSApiKeyResponse]) {
                response = [requestResponse objectForKey:BUSApiKeyResponse];
            }
            
            BUSApiResult apiResult = [self apiResultWithSuccess:success
                                                           code:warningCode
                                                        message:warningMessage];
            
            completionHandler(apiResult, response);
            
        } else {
            NSInteger errorCode = 0;
            NSString *errorMessage = @"";
            
            if ([requestResponse objectForKey:BUSApiKeyErrorCode]) {
                errorCode = [[requestResponse objectForKey:BUSApiKeyErrorCode] integerValue];
            }
            
            if ([requestResponse objectForKey:BUSApiKeyError]) {
                errorMessage = [requestResponse objectForKey:BUSApiKeyError];
            }
            
            BUSApiResult apiResult = [self apiResultWithSuccess:success
                                                           code:errorCode
                                                        message:errorMessage];
            
            completionHandler(apiResult, nil);
        }
    } else {
        NSInteger errorCode = 0;
        NSString *errorMessage = @"No object to parse";
        
        BUSApiResult apiResult = [self apiResultWithSuccess:NO
                                                       code:errorCode
                                                    message:errorMessage];
        
        completionHandler(apiResult, nil);
    }
}

- (BUSApiResult)apiResultWithSuccess:(BOOL)success code:(NSInteger)code message:(NSString *)message {
    int codeInt = (int)code;
    char *messageChar = [message UTF8String] ? (char *)[message UTF8String] : "";
    
    return BUSApiResultMake(success, codeInt, messageChar);
}

@end
