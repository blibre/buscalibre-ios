//
//  UILabel+BUSLabelHelper.h
//  buscalibre
//
//  Created by Magnet SPA on 05-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BUSLabelHelper)

# pragma mark - Attributed Text

/**
 Set a htmlString as attributedText
 
 @params htmlString String with html
 */
- (void)setAttributedTextWithHtmlString:(NSString *)htmlString;

@end
