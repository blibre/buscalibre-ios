//
//  QuickstartViewController.m
//  buscalibre
//
//  Created by Mauro on 25-06-18.
//  Copyright © 2018 buscalibre. All rights reserved.
//

#import "QuickstartViewController.h"
#import "QuickstartPageViewController.h"

@interface QuickstartViewController ()
{
    NSArray *images;
    NSArray *titles;
}
@end

@implementation QuickstartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    images = @[@"paso1", @"paso2", @"paso3"];
    titles = @[@"Elige la tienda donde quieres cotizar", @"Busca el producto que quieras traer", @"Espera que Buscalibre calcule el precio de tu producto"];
    
    self.dataSource = self;
    
    QuickstartPageViewController *initialVC = (QuickstartPageViewController *)[self viewControllerAtIndex:0];
    
    //NSLog(@"self Did Load %@", self);
    //NSLog(@"InitialVC Did Load %@", initialVC);
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialVC];
    
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// helper method
- (UIViewController *) viewControllerAtIndex: (NSUInteger)index{
    QuickstartPageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickstartPageViewController"];
    viewController.strImage = images[index];
    viewController.strTitle = titles[index];
    NSString *text = [NSString stringWithFormat:@"%@",  @(index+1)];
    viewController.strNumber = text;
    viewController.pageIndex = index;
    
    
    return viewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((QuickstartPageViewController *) viewController).pageIndex;
    
    if(index == 0 || index == NSNotFound){
        return nil;
    }
    ((QuickstartPageViewController *) viewController).pageControl.currentPage = index;
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((QuickstartPageViewController *) viewController).pageIndex;
    
    if(index == NSNotFound){
        return nil;
    }
    
    ((QuickstartPageViewController *) viewController).pageControl.currentPage = index;
    
    index++;
    
    
    
    ((QuickstartPageViewController *) viewController).saltarButton.hidden = NO;
    ((QuickstartPageViewController *) viewController).proximoButton.hidden = NO;
    ((QuickstartPageViewController *) viewController).entendidoButon.hidden = YES;
    if(index == images.count){
        ((QuickstartPageViewController *) viewController).saltarButton.hidden = YES;
        ((QuickstartPageViewController *) viewController).proximoButton.hidden = YES;
        ((QuickstartPageViewController *) viewController).entendidoButon.hidden = NO;
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}


@end
