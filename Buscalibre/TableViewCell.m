//
//  TableViewCell.m
//  buscalibre
//
//  Created by Mauro on 18-04-18.
//  Copyright © 2018 Magnet. All rights reserved.
//

#import "TableViewCell.h"

#define kAnalyticsKeyLibros @"?utm_source=app_bl&utm_medium=app_bl&utm_campaign=app_libros"



@implementation TableViewCell
- (IBAction)Link:(id)sender {
    //NSLog(@"link!%@",self.ItemTitle.text);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.LinkText, kAnalyticsKeyLibros];
    NSURL *urlToOpen = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:urlToOpen];
}
- (IBAction)LinkTitle:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.LinkText, kAnalyticsKeyLibros];
    NSURL *urlToOpen = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:urlToOpen];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
