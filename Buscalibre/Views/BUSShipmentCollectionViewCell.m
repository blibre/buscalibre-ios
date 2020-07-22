//
//  BUSShipmentCollectionViewCell.m
//  buscalibre
//
//  Created by Magnet SPA on 01-09-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSShipmentCollectionViewCell.h"

#import "UIColor+BUSCustomColors.h"

@implementation BUSShipmentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [[UIColor alloc] busGreenColor].CGColor;
    
    [self clearContent];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self clearContent];
}

# pragma mark - Properties override

- (void)setSelected:(BOOL)selected {
    if (self.item) {
        [super setSelected:selected];
        
        CGFloat borderWidth = selected ? 2.0 : 0.0;
        
        self.layer.borderWidth = borderWidth;
    }
}

- (void)setItem:(BUSItem *)item {
    _item = item;
    
    if (_item) {
        self.priceLabel.text = item.price;
        
        NSInteger minDays = item.minDestinationDays;
        NSInteger maxDays = item.maxDestinationDays;
        
        self.arriveDateLabel.text = [NSString stringWithFormat:@"(%zd - %zd días)", minDays, maxDays];
        
        self.priceLabel.hidden = NO;
        self.arriveDateLabel.hidden = NO;
        
        self.notAvailableLabel.hidden = YES;
        
    } else {
        self.userInteractionEnabled = NO;
    }
}

# pragma mark - Private methods

- (void)clearContent {
    self.priceLabel.text = @"";
    self.priceLabel.hidden = YES;
    self.arriveDateLabel.text = @"";
    self.arriveDateLabel.hidden = YES;
    
    self.notAvailableLabel.hidden = NO;
    
    self.userInteractionEnabled = YES;
    self.layer.borderWidth = 0.0;
}

@end
