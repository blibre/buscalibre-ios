//
//  UIColor+BUSCustomColors.h
//  buscalibre
//
//  Created by Magnet SPA on 04-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BUSPrimaryColor [UIColor colorWithRed:255.0/255.0 green:101.0/255.0  blue:4.0/255.0  alpha:1.0]
#define BUSGreenColor   [UIColor colorWithRed:0.0/255.0 green:145.0/255.0  blue:80.0/255.0  alpha:1.0]

@interface UIColor (BUSCustomColors)

- (instancetype)busPrimaryColor;
- (instancetype)busGreenColor;

@end
