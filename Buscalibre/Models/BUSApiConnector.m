//
//  BUSApiConnector.m
//  buscalibre
//
//  Created by Magnet SPA on 30-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSApiConnector.h"

@implementation BUSApiConnector

# pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        // Check if the base url of the api is defined on the plist.
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        
        if ([infoDict objectForKey:@"serverUrlString"]) {
            self.serverUrlString = [infoDict objectForKey:@"serverUrlString"];
            
        } else {
            self.serverUrlString = @"";
            NSLog(NSLocalizedString(@"You need to add \"serverUrlString\" string to plist.",nil));
        }
        
        if ([infoDict objectForKey:@"apiRelativeUrlString"]) {
            NSString *apiRelativeUrl = [infoDict objectForKey:@"apiRelativeUrlString"];
            self.apiUrlString = [self.serverUrlString stringByAppendingString:apiRelativeUrl];
            
        } else {
            self.apiUrlString = @"";
            NSLog(NSLocalizedString(@"You need to add \"apiRelativeUrlString\" string to plist.",nil));
        }
    }
    
    return self;
}

@end
