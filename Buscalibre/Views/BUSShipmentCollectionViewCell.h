//
//  BUSShipmentCollectionViewCell.h
//  buscalibre
//
//  Created by Magnet SPA on 01-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BUSItem.h"

@interface BUSShipmentCollectionViewCell : UICollectionViewCell

# pragma mark - Properties

@property (weak, nonatomic) BUSItem *item;

# pragma mark - IBOulets

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UILabel *arriveDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *notAvailableLabel;

@end
