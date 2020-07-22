//
//  QuickstartPageViewController.m
//  buscalibre
//
//  Created by Mauro on 25-06-18.
//  Copyright © 2018 buscalibre. All rights reserved.
//

#import "QuickstartPageViewController.h"
#import "QuickstartViewController.h"


@interface QuickstartPageViewController ()

@end


@implementation QuickstartPageViewController


- (IBAction)nextPage:(id)sender {
    
   [self toNextPage];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageImage.image = [UIImage imageNamed:_strImage];
    self.pageTitle.text = _strTitle;
    self.pageNumber.text = _strNumber;
    self.entendidoButon.hidden = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toNextPage{
    QuickstartViewController *quicksStart = (QuickstartViewController *)self.parentViewController;
    
    NSUInteger index = self.pageIndex;
    index++;
    
    if(index <= 2){
        
        
        QuickstartPageViewController *nextVC = (QuickstartPageViewController *)[quicksStart viewControllerAtIndex:index];
        
        NSArray *viewControllers = [NSArray arrayWithObject:nextVC];
        
        [quicksStart setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        //NSLog(@"index @%lu", index);
        
        nextVC.pageControl.currentPage = index;
        
        if(index == 2){
            nextVC.proximoButton.hidden = YES;
            nextVC.entendidoButon.hidden = NO;
            nextVC.saltarButton.hidden = YES;
        }
        
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    
//    NSLog(@"location x %f", location.x);
//    NSLog(@"location y %f", location.y);
//    NSLog(@"image x %f", self.pageImage.frame.origin.x);
//    NSLog(@"image with %f", self.pageImage.frame.size.width);
//    NSLog(@"image y %f", self.pageImage.frame.origin.y);
//    NSLog(@"image height %f", self.pageImage.frame.size.height);
//    NSLog(@"image sum height y %f", self.pageImage.frame.origin.y+self.pageImage.frame.origin.y);
    
    if (location.x >= self.pageImage.frame.origin.x && location.x <= self.pageImage.frame.size.width && location.y >= self.pageImage.frame.origin.y && location.y <= self.pageImage.frame.origin.y+self.pageImage.frame.size.height) {
        // your code here...
       
        NSUInteger index = self.pageIndex;
        if(index == 2){
            NSString * storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MainBrowser"];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            [self toNextPage];
        }
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
