//
//  ISBNViewController.h
//  buscalibre
//
//  Created by Mauro on 10-08-18.
//  Copyright © 2018 buscalibre. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ISBNViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *codigo;
@property (nonatomic, assign) UIActivityIndicatorView *indicator;

@end
