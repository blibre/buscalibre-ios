//
//  TableViewController.h
//  buscalibre
//
//  Created by Mauro on 18-04-18.
//  Copyright © 2018 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
//@property (nonatomic, assign) BOOL isSomethingEnabled;
@property (nonatomic, assign) NSString *listCategory;
@property (nonatomic, assign) NSString *listCategoryKey;
@property (nonatomic, assign) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) int currentIndexList;
- (NSString *)getShortTitle:(NSString *)title;
@end
