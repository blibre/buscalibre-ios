//
//  QuickstartViewController.h
//  buscalibre
//
//  Created by Mauro on 25-06-18.
//  Copyright © 2018 buscalibre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickstartPageViewController.h"

@interface QuickstartViewController : UIPageViewController <UIPageViewControllerDataSource>


- (UIViewController *) viewControllerAtIndex: (NSUInteger)index;

@end


