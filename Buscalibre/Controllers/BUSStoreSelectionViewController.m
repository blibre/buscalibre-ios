//
//  BUSStoreSelectionViewController.m
//  buscalibre
//
//  Created by Magnet SPA on 14-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSStoreSelectionViewController.h"

@interface BUSStoreSelectionViewController ()

@end

@implementation BUSStoreSelectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+420);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showVendidos"] || [segue.identifier isEqualToString:@"showNovedades"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        TableViewController *controller = (TableViewController *)navController.topViewController;
        controller.listCategory = segue.identifier;
    }
}

- (IBAction)amazonStoreButtonAction:(id)sender {
    if (self.delegate) {
        [self.delegate storeSelectionViewWantsToLoadStoreKind:BUSWebContentViewKindAmazon];
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)ebayStoreButtonAction:(id)sender {
    if (self.delegate) {
        [self.delegate storeSelectionViewWantsToLoadStoreKind:BUSWebContentViewKindEbay];
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)showCodereaderPressed:(id)sender {

}
@end
