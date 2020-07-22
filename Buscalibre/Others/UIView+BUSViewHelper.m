//
//  UIView+BUSViewHelper.m
//  buscalibre
//
//  Created by Magnet SPA on 06-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "UIView+BUSViewHelper.h"

@implementation UIView (BUSViewHelper)

/**
 Add rounder border with a defined border width, corner radius and color border
 
 @params borderWidth  Defined border width float
 @params cornerRadius Defined corner radius float
 @params color        Defined border color
 */
- (void)addRoundedBorder:(CGFloat)borderWidth withCornerRadius:(CGFloat)cornerRadius andColor:(UIColor *)color {
    if (color) {
        self.layer.borderColor = color.CGColor;
    }
    
    self.layer.borderWidth = borderWidth;
    
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

/**
 Add rounder border with a defined border width and corner radius
 
 @params borderWidth  Defined border width float
 @params cornerRadius Defined corner radius float
 */
- (void)addRoundedBorder:(CGFloat)borderWidth withCornerRadius:(CGFloat)cornerRadius {
    [self addRoundedBorder:borderWidth
          withCornerRadius:cornerRadius
                  andColor:nil];
}

/**
 Add rounder border with a defined corner radius
 
 @params cornerRadius Defined corner radius float
 */
- (void)addRoundedBorderWithCornerRadius:(CGFloat)cornerRadius {
    [self addRoundedBorder:0.0
          withCornerRadius:cornerRadius
                  andColor:nil];
}
@end
