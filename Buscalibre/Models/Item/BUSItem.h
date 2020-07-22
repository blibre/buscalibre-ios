//
//  BUSItem.h
//  buscalibre
//
//  Created by Magnet SPA on 30-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BUSItemConditionType.h"
#import "BUSItemTransportType.h"

FOUNDATION_EXPORT NSString * _Nonnull const BUSItemKeyPrice;
FOUNDATION_EXPORT NSString * _Nonnull const BUSItemKeyAvailable;
FOUNDATION_EXPORT NSString * _Nonnull const BUSItemKeyArriveDate;
FOUNDATION_EXPORT NSString * _Nonnull const BUSItemKeyMinDestinationDays;
FOUNDATION_EXPORT NSString * _Nonnull const BUSItemKeyMaxDestinationDays;

@interface BUSItem : NSObject

# pragma mark - Properties

@property (strong, nonatomic) NSString * _Nullable price;
@property (nonatomic) BOOL available;
@property (strong, nonatomic) NSString * _Nullable arriveDate;
@property (nonatomic) NSInteger minDestinationDays;
@property (nonatomic) NSInteger maxDestinationDays;
@property (nonatomic) BUSItemConditionType condition;
@property (nonatomic) BUSItemTransportType transport;

# pragma mark - Init

+ (instancetype _Nullable)createItemWithDictionary:(NSDictionary * _Nonnull)dictionary
                                   conditionString:(NSString * _Nonnull)conditionString
                                   transportString:(NSString * _Nonnull)transportString;

# pragma mark - Public methods

/**
 Returns a string for for a given itemConditionType
 
 @return NSString For conditionType
 */
- (NSString * _Nullable)getStringConditionType;

/**
 Returns a string for for a given itemTransportType
 
 @return NSString For transportType
 */
- (NSString * _Nullable)getStringTransportType;

@end
