//
//  BUSTopNavigationView.m
//  buscalibre
//
//  Created by Magnet SPA on 24-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSTopNavigationView.h"

#define urlBL @"https://www.buscalibre.cl/v2/carro"
#define kAnalyticsKeyCart @"?utm_source=app_bl&utm_medium=app_bl&utm_campaign=app_cart"

@implementation BUSTopNavigationView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Loads from xib file
        NSArray *viewsArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                            owner:self
                                                          options:nil];
        
        for (id object in viewsArray) {
            if ([object isKindOfClass:[UIView class]]) {
                self.contentView = object;
                break;
            }
        }
        
        // Fill all the space
        self.contentView.frame = self.bounds;
        
        // Resize on super view resize
        self.contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        // Add the content subview
        [self addSubview:self.contentView];
    }
    
    return self;
}

# pragma mark - Public methods

- (IBAction)backButtonAction:(id)sender {
    if (self.delegate) {
        [self.delegate topNavigationViewWantsToGoBack];
    }
}

- (IBAction)forwardButtonAction:(id)sender {
    if (self.delegate) {
        [self.delegate topNavigationViewWantsToGoForward];
    }
}

- (IBAction)storesButtonAction:(id)sender {
    if (self.delegate) {
        [self.delegate topNavigationViewWantsToGoHome];
    }
}

- (IBAction)helpButtonAction:(id)sender {
    if (self.delegate) {
        [self.delegate topNavigationViewWantsToGoHelp];
    }
}
- (IBAction)cartButtonAction:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",urlBL, kAnalyticsKeyCart];
    NSURL *urlToOpen = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:urlToOpen];
}



@end
