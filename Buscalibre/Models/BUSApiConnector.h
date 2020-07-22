//
//  BUSApiConnector.h
//  buscalibre
//
//  Created by Magnet SPA on 30-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BUSApiConnector : NSObject

# pragma mark - Properties

@property (nonatomic, strong) NSString *apiUrlString;
@property (nonatomic, strong) NSString *serverUrlString;

@end
