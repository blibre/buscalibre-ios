//
//  QuickstartPageViewController.h
//  buscalibre
//
//  Created by Mauro on 25-06-18.
//  Copyright © 2018 buscalibre. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QuickstartPageViewControllerDelegate <NSObject>
@required
- (UIViewController *) viewControllerAtIndex: (NSUInteger)index;
- (void)setViewControllers:(nullable NSArray<UIViewController *> *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion;
@end

@interface QuickstartPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UILabel *pageNumber;
@property (weak, nonatomic) IBOutlet UIImageView *pageImage;
@property NSString *strImage;
@property NSString *strTitle;
@property NSString *strNumber;
@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIButton *saltarButton;
@property (weak, nonatomic) IBOutlet UIButton *entendidoButon;
@property (weak, nonatomic) IBOutlet UIButton *proximoButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) id<QuickstartPageViewControllerDelegate> delegate;

@end




