//
//  UIView+BUSViewHelper.h
//  buscalibre
//
//  Created by Magnet SPA on 06-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BUSViewHelper)

/**
 Add rounder border with a defined border width, corner radius and color border
 
 @params borderWidth  Defined border width float
 @params cornerRadius Defined corner radius float
 @params color        Defined border color
 */
- (void)addRoundedBorder:(CGFloat)borderWidth withCornerRadius:(CGFloat)cornerRadius andColor:(UIColor *)color;

/**
 Add rounder border with a defined border width and corner radius
 
 @params borderWidth  Defined border width float
 @params cornerRadius Defined corner radius float
 */
- (void)addRoundedBorder:(CGFloat)borderWidth withCornerRadius:(CGFloat)cornerRadius;

/**
 Add rounder border with a defined corner radius
 
 @params cornerRadius Defined corner radius float
 */
- (void)addRoundedBorderWithCornerRadius:(CGFloat)cornerRadius;

@end
