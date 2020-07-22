//
//  TableViewCell.h
//  buscalibre
//
//  Created by Mauro on 18-04-18.
//  Copyright © 2018 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *ItemLink;
@property (weak, nonatomic) IBOutlet UIImageView *ItemImages;
@property (weak, nonatomic) IBOutlet UILabel *ItemAutor;
@property (weak, nonatomic) IBOutlet UILabel *ItemEditorial;
@property (weak, nonatomic) IBOutlet UILabel *ItemDcto;
@property (weak, nonatomic) IBOutlet UILabel *ItemListPrice;
@property (weak, nonatomic) IBOutlet NSString *LinkText;
@property (weak, nonatomic) IBOutlet UIButton *ItemlTitleLink;
@end
