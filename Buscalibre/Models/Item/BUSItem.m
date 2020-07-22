//
//  BUSItem.m
//  buscalibre
//
//  Created by Magnet SPA on 30-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSItem.h"

#import "BUSApiManager.h"
#import "BUSItemManager.h"
#import "NSString+BUSStringHelper.h"

NSString * const BUSItemKeyPrice = @"precio";
NSString * const BUSItemKeyAvailable = @"disponible";
NSString * const BUSItemKeyArriveDate = @"fecha_recepcion";
NSString * const BUSItemKeyMinDestinationDays = @"tiempo_en_destino_minimo";
NSString * const BUSItemKeyMaxDestinationDays = @"tiempo_en_destino_maximo";

@implementation BUSItem

# pragma mark - Init

+ (instancetype)createItemWithDictionary:(NSDictionary *)dictionary conditionString:(NSString *)conditionString transportString:(NSString *)transportString {
    if (!dictionary ||
        [NSString stringIsNilOrEmpty:conditionString] ||
        [NSString stringIsNilOrEmpty:transportString]) {
        return nil;
    }
    
    BUSItemConditionType condition = [self getItemConditionTypeForConditionString:conditionString];
    BUSItemTransportType transport = [self getItemTransportTypeForTransportString:transportString];
    
    if (!condition || !transport) {
        return nil;
    }
    
    BUSItem *item = [[BUSItem alloc] init];
    
    item.price = [dictionary objectForKey:BUSItemKeyPrice];
    item.available = [[dictionary objectForKey:BUSItemKeyAvailable] boolValue];
    item.arriveDate = [dictionary objectForKey:BUSItemKeyArriveDate];
    item.minDestinationDays = [[dictionary objectForKey:BUSItemKeyMinDestinationDays] integerValue];
    item.maxDestinationDays = [[dictionary objectForKey:BUSItemKeyMaxDestinationDays] integerValue];
    item.condition = condition;
    item.transport = transport;
    
    return item;
}

# pragma mark - Public methods

/**
 Returns a string for for a given itemConditionType
 
 @return NSString For conditionType
 */
- (NSString *)getStringConditionType {
    switch (self.condition) {
        case BUSItemConditionTypeNew:
            return BUSApiItemKeyNew;
            
        case BUSItemConditionTypeNewPrime:
            return BUSApiItemKeyNewPrime;
            
        case BUSItemConditionTypeUsed:
            return BUSApiItemKeyUsed;
            
        case BUSItemConditionTypeRefurbished:
            return BUSApiItemKeyRefurbished;
            
        default:
            return nil;
    }
}

/**
 Returns a string for for a given itemTransportType
 
 @return NSString For transportType
 */
- (NSString *)getStringTransportType {
    switch (self.transport) {
        case BUSItemTransportTypeAirplane:
            return BUSApiItemKeyAirplane;
            
        case BUSItemTransportTypeShip:
            return BUSApiItemKeyShip;
            
        default:
            return nil;
    }
}

# pragma mark - Private methods

/**
 Returns the itemConditionType for a given type string
 
 @params typeString Condition string to compare
 
 @return BUSItemConditionType for string
 */
+ (BUSItemConditionType)getItemConditionTypeForConditionString:(NSString *)typeString {
    if (![NSString stringIsNilOrEmpty:typeString]) {
        
        if ([typeString isEqualToString:BUSApiItemKeyNew]) {
            return BUSItemConditionTypeNew;
            
        } else if ([typeString isEqualToString:BUSApiItemKeyNewPrime]) {
            return BUSItemConditionTypeNewPrime;
            
        } else if ([typeString isEqualToString:BUSApiItemKeyRefurbished]) {
            return BUSItemConditionTypeRefurbished;
            
        } else if ([typeString isEqualToString:BUSApiItemKeyUsed]) {
            return BUSItemConditionTypeUsed;
        }
    }
    
    return 0;
}

/**
 Returns the itemTransportType for a given type string
 
 @params typeString Transport string to compare
 
 @return BUSItemTransportType for string
 */
+ (BUSItemTransportType)getItemTransportTypeForTransportString:(NSString *)typeString {
    if (![NSString stringIsNilOrEmpty:typeString]) {
        
        if ([typeString isEqualToString:BUSApiItemKeyAirplane]) {
            return BUSItemTransportTypeAirplane;
            
        } else if ([typeString isEqualToString:BUSApiItemKeyShip]) {
            return BUSItemTransportTypeShip;
        }
    }
    
    return 0;
}

@end
