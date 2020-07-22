//
//  ISBNViewController.m
//  buscalibre
//
//  Created by Mauro on 10-08-18.
//  Copyright © 2018 buscalibre. All rights reserved.
//

#import "ISBNViewController.h"
#import "MTBBarcodeScanner.h"

static NSString * const BaseURL = @"https://www.buscalibre.cl/libros/search?q=";
static NSString * const AnalyticsKeyIsbn = @"&utm_source=app_bl&utm_medium=app_bl&utm_campaign=app_scanner";


@interface ISBNViewController ()

@end

@implementation ISBNViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Buscar por ISBN";
    
    UIActivityIndicatorView * activityindicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.parentViewController.view.frame.size.width/2 - 10, self.parentViewController.view.frame.size.height/2 - 30, 20, 20)];
    [activityindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityindicator setColor:[UIColor orangeColor]];
    [self.view addSubview:activityindicator];
    [activityindicator startAnimating];
    self.indicator = activityindicator;
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated{
    MTBBarcodeScanner *scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.view];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            self.indicator.hidden = YES;
            [self.indicator stopAnimating];
            
            NSError *error = nil;
            [scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                NSLog(@"Found code: %@", code.stringValue);
                self.codigo.text = code.stringValue;
                
                // Open URL
                NSString *urlString = [NSString stringWithFormat:@"%@%@%@",BaseURL, code.stringValue,AnalyticsKeyIsbn];
                NSURL *urlToOpen = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:urlToOpen];
                
                // Stop Scan
                [scanner stopScanning];
                
                // Volver
                [self dismissViewControllerAnimated:YES completion:nil];
                
                
            } error:&error];
            
        } else {
            // The user denied access to the camera
            NSLog(@"denied %@", scanner);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)Volver:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
