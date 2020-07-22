//
//  UILabel+BUSLabelHelper.m
//  buscalibre
//
//  Created by Magnet SPA on 05-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "UILabel+BUSLabelHelper.h"

@implementation UILabel (BUSLabelHelper)

# pragma mark - Attributed Text

/**
 Set a htmlString as attributedText
 
 @params htmlString String with html
 */
- (void)setAttributedTextWithHtmlString:(NSString *)htmlString {
    NSError *error = nil;
    
    NSDictionary *options = @{
                              NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
                              };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    self.attributedText = [[NSAttributedString alloc] initWithData:data
                                                           options:options
                                                documentAttributes:nil
                                                             error:&error];
    
    if (error) {
        NSLog(@"Error setting attributed text: %@", error.localizedDescription);
    }
}

@end
