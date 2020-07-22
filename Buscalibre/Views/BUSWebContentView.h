//
//  BUSWebContentView.h
//  buscalibre
//
//  Created by Magnet SPA on 24-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

/** ENUM with defined kinds of webView */
typedef NS_ENUM(NSUInteger, BUSWebContentViewKind) {
    BUSWebContentViewKindNone,
    BUSWebContentViewKindAmazon,
    BUSWebContentViewKindEbay
};

@class BUSItemSearch;

@protocol BUSWebContentViewDelegate <NSObject>

@required

/** To report that the current page is a item page */
- (void)webContentViewDidFoundItem;

/** To report a specific choosen item with differentiator choosen */
- (void)webContentViewDidFoundItemSearch:(BUSItemSearch *)itemSearch;

/** To report that a the current page is not a item page */
- (void)webContentViewDidNotFoundItem;

/** To report the estimated progress when is loading a page */
- (void)webContentViewDidUpdateEstimatedProgress:(CGFloat)estimatedProgress;

/** To report that the webView is loading or not a page */
- (void)webContentViewIsLoadingContent:(BOOL)isLoadingContent;

/** To report that the view wants to show a alert view */
- (void)webContentViewWantsToShowAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;


@end

@interface BUSWebContentView : UIView <WKNavigationDelegate, WKUIDelegate>

# pragma mark - Properties

@property (nonatomic) BUSWebContentViewKind kind;

@property (weak, nonatomic) id<BUSWebContentViewDelegate> delegate;

@property (strong, nonatomic) WKWebView *webView;

@property (weak, nonatomic) NSURL *loadUrl;

@property (strong, nonatomic) NSTimer *checkTimer;

@property (nonatomic, assign) BOOL foundItem;


# pragma mark - IBOutlet

@property (strong, nonatomic) IBOutlet UIView *contentView;


# pragma mark - Public methods

/**
 goBack on webContentView
 */
- (void)goBack;

/**
 goForward on webContentView
 */
- (void)goForward;

/**
 Returns the currentKind in string
 
 @return NSString kind string
 */
- (NSString *)currentWebContentKindString;



@end
