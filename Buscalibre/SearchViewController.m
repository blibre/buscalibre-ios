//
//  SearchViewController.m
//  buscalibre
//
//  Created by Mauro on 9/6/18.
//  Copyright © 2018 buscalibre. All rights reserved.
//

#import "SearchViewController.h"

static NSString * const BaseURL = @"https://www.buscalibre.cl/libros/search?q=";
static NSString * const AnalyticsKeySearch = @"&utm_source=app_bl&utm_medium=app_bl&utm_campaign=app_search";

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchButton:(id)sender {
    NSString *enteredText = [_searchInput text];
    NSLog(@"search: %@", enteredText);
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",BaseURL, enteredText, AnalyticsKeySearch];

    NSString* urlTextEscaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlToOpen = [NSURL URLWithString: urlTextEscaped];
    
    [[UIApplication sharedApplication] openURL:urlToOpen];
}

- (IBAction)Volver:(id)sender {
[self dismissViewControllerAnimated:YES completion:nil];
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
