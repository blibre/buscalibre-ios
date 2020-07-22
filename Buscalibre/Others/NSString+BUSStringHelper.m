//
//  BUSStringHelper.m
//  buscalibre
//
//  Created by Magnet SPA on 25-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "NSString+BUSStringHelper.h"

@implementation NSString (BUSStringHelper)

# pragma mark - Checks

/**
 Returns a BOOL value checking if the regular expression pattern exists on a given text
 
 @params pattern regular expression to use for checking
 @params text string to check
 
 @return BOOL condition
 */
+ (BOOL)isRegularExpressionPattern:(NSString *)pattern onText:(NSString *)text {
    NSString *stringFromSearch = [self searchWordWithRegularExpressionPattern:pattern inText:text];
    
    return ![self stringIsNilOrEmpty:stringFromSearch];
}

/**
 Returns a BOOL value checking if a NSString is nil or empty
 
 @params string string to check
 
 @return BOOL condition
 */
+ (BOOL)stringIsNilOrEmpty:(NSString *)string {
    if (string) {
        if ([string length] > 0) {
            return NO;
        }
    }
    
    return YES;
}

# pragma mark - Substrings

/**
 Returns a string found over the search regular expression pattern on text
 
 @params pattern Regular expression to use for checking
 @params text text to check
 
 @return NSString found
 */
+ (NSString *)searchWordWithRegularExpressionPattern:(NSString *)pattern inText:(NSString *)text {
    NSString *stringPatternOnText = nil;
    
    if ([self stringIsNilOrEmpty:text]) {
        return stringPatternOnText;
    }
    
    NSError  *error  = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:0
                                  error:&error];
    
    if (error) {
        return stringPatternOnText;
    }
    
    NSRange range = [regex rangeOfFirstMatchInString:text
                                             options:0
                                               range:NSMakeRange(0, [text length])];
    
    if (range.length != 0 && !error) {
        stringPatternOnText = [text substringWithRange:range];
    }
    
    return stringPatternOnText;
}

/**
 Returns the string after Search a substring expression
 
 @params substring substring for division
 @params string string to check
 
 @return NSString found
 */
+ (NSString *)getStringAfterSubstring:(NSString *)substring inString:(NSString *)string {
    if ([self stringIsNilOrEmpty:substring] || [self stringIsNilOrEmpty:string]) {
        return nil;
    }
    
    NSArray *separatedStringsArray = [string componentsSeparatedByString:substring];
    
    return [separatedStringsArray lastObject];
}

@end
