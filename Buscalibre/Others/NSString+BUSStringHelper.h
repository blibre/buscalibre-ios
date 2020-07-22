//
//  BUSStringHelper.h
//  buscalibre
//
//  Created by Magnet SPA on 25-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BUSStringHelper)

# pragma mark - Checks

/**
 Returns a BOOL value checking if the regular expression pattern exists on a given text
 
 @params pattern regular expression to use for checking
 @params text string to check
 
 @return BOOL condition
 */
+ (BOOL)isRegularExpressionPattern:(NSString *)pattern onText:(NSString *)text;

/**
 Returns a BOOL value checking if a NSString is nil or empty
 
 @params string string to check
 
 @return BOOL condition
 */
+ (BOOL)stringIsNilOrEmpty:(NSString *)string;


# pragma mark - Substrings

/**
 Returns a string found over the search regular expression pattern on text
 
 @params pattern Regular expression to use for checking
 @params text text to check
 
 @return NSString found
 */
+ (NSString *)searchWordWithRegularExpressionPattern:(NSString *)pattern inText:(NSString *)text;

/**
 Returns the string after Search a substring expression
 
 @params substring substring for division
 @params string string to check
 
 @return NSString found
 */
+ (NSString *)getStringAfterSubstring:(NSString *)substring inString:(NSString *)string;

@end
