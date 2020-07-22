//
//  BUSWebContentView.m
//  buscalibre
//
//  Created by Magnet SPA on 24-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#import "BUSWebContentView.h"

#import "BUSItemSearch.h"
#import "NSString+BUSStringHelper.h"

#define kCheckTimerSeconds 1.0

#define kAmazonQueryCanonicalSelectorString @"document.querySelector(\"link[rel='canonical']\").href"
#define kAmazonQueryFindItemToAddCart @"document.querySelector(\"#ftSelectAsin\").value"
#define kAmazonItemUrlSubstring @"/dp/"
#define kAmazonBaseUrl @"www.amazon.com"

//#define kEbayQueryDataItemId @"document.querySelector('#getData').getAttribute('data-itemId')"
//#define kEbayQueryDataItemId @"document.querySelector('[data-itemId]').getAttribute('data-itemId')"
#define kEbayQueryDataItemId @"document.querySelector('#appbnr_itm_id').getAttribute('value')"


#define kEbayQueryFindItemVariationId @"$('#variationId').val() === undefined ? null : $('#variationId').val()"
#define kEbayQueryFindItemVariationString @"$.map($('#msku_list select option:selected'), function(element) {return $(element).text().replace(/[ -]+/g, '-')}).join('_')"
#define kEbayBaseUrl @"m.ebay.com"
#define kEbayBaseUrlDomain @"ebay.com"

#define BLAmazonHideItems @"var hide = document.getElementById('nav-subnav-container');hide.style.display='none';var hide = document.getElementsByClassName('nav-right')[0];hide.style.display='none';var hide = document.getElementById('nav-logo');hide.style.paddingLeft='15px';var hide = document.getElementById('nav-ftr');hide.style.display='none';var hide = document.getElementsByClassName('csm-widget-type-sign-in-card')[0];hide.style.display='none';"

#define BLAmazonHideHamburger @"var hide = document.getElementById('nav-hamburger-menu');hide.style.display='none';"


#define BLAmazonHideAddress @"var hide = document.getElementById('contextualIngressPt');hide.style.display='none';var hide = document.getElementById('dpx-anywhere-sell-yours-here_feature_div');hide.style.display='none';var hide = document.getElementById('tradeInButton');hide.style.display='none';var hide = document.getElementById('olp_feature_div');hide.style.display='none';var hide = document.getElementsByClassName('writeReviewLink')[0];hide.style.display='none';var hide = document.getElementsByClassName('cr-vote')[0];hide.style.display='none';"


#define BLAmazonHideReviews @"var hide=document.getElementsByClassName('writeReviewLink')[0];hide.style.display='none';var divsToHide = document.getElementsByClassName('cr-vote');for(var i = 0; i < divsToHide.length; i++){divsToHide[i].style.visibility = 'hidden';divsToHide[i].style.display = 'none';}var hide = document.getElementById('askCommentsContainer-MxNG7LN9GY14NZ');hide.style.display='none';var hide = document.getElementById('visitor-view-nudge');hide.style.display='none';var hide = document.getElementById('profile-search-container');hide.style.display='none';var hide = document.getElementById('visitor-view-nudge');hide.style.display='none';var divsToHide = document.getElementsByClassName('writeReviewButton');for(var i = 0; i < divsToHide.length; i++){divsToHide[i].style.visibility = 'hidden';divsToHide[i].style.display = 'none';}"

#define BLAmazonHideReviewDetail @"var hide = document.getElementById('universal-glance-reviews-features');hide.style.display='none';"

#define BLAmazonHideReviewsHome @"var divsToHide = document.getElementsByClassName('writeReviewButton');for(var i = 0; i < divsToHide.length; i++){divsToHide[i].style.visibility = 'hidden';divsToHide[i].style.display = 'none';}var hide = document.getElementById('nav-gwbar');hide.style.display='none';var hide = document.getElementById('gwm-Deck-cf');hide.style.display='none';"

#define BLAmazonHideLogin @"var elementExists = document.getElementById('BLAmazonAlertLogin');if(!elementExists){var el = document.createElement('div');el.setAttribute('id', 'BLAmazonAlertLogin');el.innerHTML = 'No es posible iniciar sesión en Amazon a través de <strong>BuscaLibre</strong>.';el.style.marginBottom='10px';el.style.backgroundColor='#fff';el.style.fontSize='large';el.style.color='#f60';el.style.border='2px solid #009750';el.style.padding='10px';el.style.textAlign='center';el.style.borderRadius='5px';var div = document.getElementById('outer-accordion-signin-signup-page');div.parentNode.insertBefore(el, div.nextSibling);div.style.display='none';}"

#define BLAmazonHideLogin2 @"var elementExists = document.getElementById('BLAmazonAlertLogin');if(!elementExists){var el = document.createElement('div');el.setAttribute('id', 'BLAmazonAlertLogin');el.innerHTML = 'No es posible iniciar sesión en Amazon a través de <strong>BuscaLibre</strong>.';el.style.marginBottom='10px';el.style.backgroundColor='#fff';el.style.fontSize='large';el.style.color='#f60';el.style.border='2px solid #009750';el.style.padding='10px';el.style.textAlign='center';el.style.borderRadius='5px';var div = document.getElementsByName('signIn')[0];div.parentNode.insertBefore(el, div.nextSibling);div.style.display='none';}"

#define BLAmazonHideDeals @"var hide = document.getElementById('gwm-grid-7-dealsCard');hide.style.display='none';var hide = document.getElementById('gwm-grid-8-dealsCard');hide.style.display='none';"

#define BLAmazonHideLists @"var hide = document.getElementById('addToWishlist');hide.style.display='none';"

#define BLAmazonHideCart @"var hide = document.getElementById('navbar-icon-cart');hide.style.display='none';"

#define BLAmazonHideClick @"var hide = document.getElementById('checkoutButtonId);hide.style.display='none';"
#define BLAmazonHideSample @"var hide = document.getElementById('sendSample');hide.style.display='none';"
#define BLAmazonHideGift @"var hide = document.getElementById('gift-button');hide.style.display='none';"

#define BLAmazonHideFooter @"var hide = document.getElementsByClassName('a-footer')[0];hide.style.display='none';"

#define BLAmazonHidePrime @"var hide = document.getElementById('detailILM_feature_div');hide.style.display='none';"

#define BLEbayHideItems @"var hide = document.getElementsByClassName('floatedRight')[0];hide.style.display='none';var hide = document.getElementById('gf-mweb');hide.style.display='none';var hide = document.getElementsByClassName('srp-river-footer')[0];hide.style.display='none';"

#define BLAmazonAlertMsg @"var elementExists = document.getElementById('BLAmazonAlert');if(!elementExists){var el = document.createElement('div');el.setAttribute('id', 'BLAmazonAlert');el.innerHTML = 'Para cotizar por <strong>BuscaLibre</strong> utiliza la barra naranja o verde que está en la parte inferior de tu pantalla.';el.style.marginBottom='10px';el.style.backgroundColor='#fff';el.style.fontSize='large';el.style.color='#f60';el.style.border='2px solid #009750';el.style.padding='10px';el.style.textAlign='center';el.style.borderRadius='5px';var div = document.getElementById('buybox');div.parentNode.insertBefore(el, div.nextSibling);div.style.display='none';}"

#define BLEbayAlertMsg @"var elementExists = document.getElementById('BLEbayAlert');if(!elementExists){var el = document.createElement('div');el.setAttribute('id', 'BLEbayAlert');el.innerHTML = 'Para cotizar por <strong>BuscaLibre</strong> utiliza la barra naranja o verde que está en la parte inferior de tu pantalla.';el.style.backgroundColor='#fff';el.style.fontSize='large';el.style.color='#f60';el.style.border='2px solid #009750';el.style.padding='10px';el.style.marginTop='10px';el.style.textAlign='center';el.style.borderRadius='5px';var div = document.getElementById('buyItNowBtn');div.parentNode.insertBefore(el, div.nextSibling);div.style.display='none';var addCart = document.getElementById('addToCartBtn');addCart.style.display='none';var favBtn = document.getElementById('watchSignedOutBtn');favBtn.style.display='none';}"

#define BLEbay2AlertMsg @"var elementExists = document.getElementById('BLEbay2Alert');if(!elementExists){var el = document.createElement('div');el.setAttribute('id', 'BLEbay2Alert');el.innerHTML = 'Para cotizar por <strong>BuscaLibre</strong> utiliza la barra naranja o verde que está en la parte inferior de tu pantalla.';el.style.backgroundColor='#fff';el.style.fontSize='large';el.style.color='#f60';el.style.border='2px solid #009750';el.style.padding='10px';el.style.marginTop='10px';el.style.textAlign='center';el.style.borderRadius='5px';var div = document.getElementById('vi-bin-button');div.parentNode.insertBefore(el, div.nextSibling);div.style.display='none';var addCart = document.getElementById('addToCartBtn');addCart.style.display='none';var favBtn = document.getElementById('watchSignedOutBtn');favBtn.style.display='none';}"



static const NSString *kvoEstimatedProgressContext;
static NSString * const kvoEstimatedProgressKey = @"estimatedProgress";

@implementation BUSWebContentView

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
        
        [self initializeWebView];
    }
    
    return self;
}

# pragma mark - Properties override

/**
 Checks the BUSWebContentViewKind and sets the default base url to load
 */
- (void)setKind:(BUSWebContentViewKind)kind {
    if (_kind != kind) {
        _kind = kind;
        
        NSString *baseUrl;
        
        switch (_kind) {
            case BUSWebContentViewKindAmazon: {
                baseUrl = kAmazonBaseUrl;
                
                break;
            }
                
            case BUSWebContentViewKindEbay: {
                baseUrl = kEbayBaseUrl;
                
                break;
            }
                
            default:
                break;
        }
        
        if (![NSString stringIsNilOrEmpty:baseUrl]) {
            NSString *urlString = [NSString stringWithFormat:@"https://%@", baseUrl];
            self.loadUrl = [NSURL URLWithString:urlString];
        }
    }
}

/**
 Sets and load a specific url on webContentView
 */
- (void)setLoadUrl:(NSURL *)loadUrl {
    _loadUrl = loadUrl;
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:_loadUrl];
    //NSLog(@"urlRequest!%@",urlRequest);
    [self.webView loadRequest:urlRequest];
}

# pragma mark - Public methods

/**
 goBack on webContentView
 */
- (void)goBack {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

/**
 goForward on webContentView
 */
- (void)goForward {
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

/**
 Returns the currentKind in string
 
 @return NSString kind string
 */
- (NSString *)currentWebContentKindString {
    switch (self.kind) {
        case BUSWebContentViewKindAmazon:
            return @"amazon";
            
        case BUSWebContentViewKindEbay:
            return @"ebay";
            
        default:
            break;
    }
    
    return nil;
}

# pragma mark - WebView Initializer

/**
 Initialize and add WKWebView
 */
- (void)initializeWebView {
    // Initialize WKWebView
    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.contentView.bounds
                                      configuration:webConfiguration];
    
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    [self.contentView addSubview:self.webView];
    
    [self.webView addObserver:self
                   forKeyPath:kvoEstimatedProgressKey
                      options:NSKeyValueObservingOptionNew
                      context:&kvoEstimatedProgressContext];
    
}

# pragma mark - Amazon methods

/**
 Check via javascript if a canonical link exists on the WebView content in Amazon page
 */
- (void)findAmazonItemOnWebView:(WKWebView *)webView completionHandler:(void (^)(BOOL isItemPage))completionHandler {
    
    NSLog(@"evaluate amazon item");
    
    [self checkWebView:webView
        withJavascript:kAmazonQueryCanonicalSelectorString
     completionHandler:^(id result, NSError *error) {
         
         if (result && !error) {
             
             if ([result isKindOfClass:[NSString class]]) {
                 
                 NSString *stringResult = (NSString *)result;
                 
                 if ([stringResult containsString:kAmazonItemUrlSubstring]) {
                     
                     
                     completionHandler(YES);
                     
                 } else {
                     completionHandler(NO);
                 }
             }
         }
     }];
}

/**
 Check via javascript if the webView has a cart item in Amazon page
 */
- (void)findAmazonItemToAddCartOnWebView:(WKWebView *)webView completionHandler:(void (^)(NSString *itemCode))completionHandler {
    [self checkWebView:self.webView
        withJavascript:kAmazonQueryFindItemToAddCart
     completionHandler:^(id result, NSError *error) {
         
         if (result && !error) {
             if ([result isKindOfClass:[NSString class]]){
                 //NSLog(@"result!%@",result);
                 completionHandler(result);
                 
                 return;
             }
         }
         
         completionHandler(nil);
     }];
}

# pragma mark - Ebay methods

/**
 Check via javascript if the webView has a dataItemId in Ebay page
 */
- (void)findEbayItemOnWebView:(WKWebView *)webView completionHandler:(void (^)(NSString *itemCode))completionHandler {
    [self checkWebView:webView
        withJavascript:kEbayQueryDataItemId
     completionHandler:^(id result, NSError *error) {
         
         if (result && !error) {
             if ([result isKindOfClass:[NSString class]]) {
                 
                 completionHandler(result);
                 
                 return;
             }
         }
         
         completionHandler(nil);
     }];
}

/**
 Check via javascript if the webView has a SkuId in Ebay page
 */
- (void)findEbayItemVariationIdOnWebView:(WKWebView *)webView completionHandler:(void (^)(BOOL hasVariations, BOOL hasSelectedVariations))completionHandler {
    [self checkWebView:webView
        withJavascript:kEbayQueryFindItemVariationId
     completionHandler:^(id result, NSError *error) {
         if (result && !error) {
             
             if ([result isKindOfClass:[NSString class]]) {
                 NSString *resultString = (NSString *)result;
                 BOOL hasSelectedVariations = resultString.length > 0;
                 
                 completionHandler(YES, hasSelectedVariations);
             } else {
                 completionHandler(NO, NO);
             }
             
         } else {
             completionHandler(NO, NO);
         }
     }];
}

# pragma mark - Other methods

/**
 Returns a site string from a specific kind enum
 
 @return NSString Site string
 */
- (NSString *)getSiteFromKindEnum:(BUSWebContentViewKind)kind {
    switch (kind) {
        case BUSWebContentViewKindAmazon:
            return @"amazon";
            
        case BUSWebContentViewKindEbay:
            return @"ebay";
            
        default:
            break;
    }
    
    return nil;
}

/**
 To report that the WebView is on a item page
 */
- (void)itemFound {
    if (self.delegate) {
    
        [self.delegate webContentViewDidFoundItem];
    }
    
    [self addCheckTimer];
}

/**
 To report that the WebView is not on a item page
 */
- (void)itemNotFound {
    if (self.delegate) {
        [self.delegate webContentViewDidNotFoundItem];
    }
    
    [self removeCheckTimer];
}

/**
 Adds a NSTimer to check if in the WebContent a item is ready in cart
 */
- (void)addCheckTimer {
    if (self.checkTimer) {
        [self.checkTimer invalidate];
        self.checkTimer = nil;
    }
    
    self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:kCheckTimerSeconds
                                                       target:self
                                                     selector:@selector(checkWebViewChangesAndLookItemCart:)
                                                     userInfo:nil
                                                      repeats:YES];
    
    [self.checkTimer fire];
}

/**
 Removes the NSTimer that checks if in the WebContent a item is ready in cart
 */
- (void)removeCheckTimer {
    if (self.checkTimer) {
        [self.checkTimer invalidate];
        self.checkTimer = nil;
    }
}

/**
 Methods called by the checkTimer
 Checks if the item is ready to add to cart
 */
- (void)checkWebViewChangesAndLookItemCart:(NSTimer *)timer {
    switch (self.kind) {
        case BUSWebContentViewKindAmazon: {

//            NSString *inject = @"var h1s = document.querySelectorAll('h1'); for (var i = 0; i < h1s.length; i++) { h1s[i].innerHTML = window.location.href };";
            
            
            [self findAmazonItemToAddCartOnWebView:self.webView
                                 completionHandler:^(NSString *itemCode) {
                                     if (![NSString stringIsNilOrEmpty:itemCode]) {
                                         // Amazon items doesn't have differentiators
                                         [self itemFoundWithCode:itemCode
                                               andDifferentiator:nil];
                                     }
                                 }];
            
            break;
        }
            
        case BUSWebContentViewKindEbay: {
            
            [self findEbayItemOnWebView:self.webView
                      completionHandler:^(NSString *itemCode) {
                          
                          [self findEbayItemVariationIdOnWebView:self.webView
                                               completionHandler:^(BOOL hasVariations, BOOL hasSelectedVariations) {
                                                   // Otherwise, if resulta is a NSNull class
                                                   // Means that there is not differentiator to find
                                                   // And the item is ready to request item details
                                                   
                                                   if (hasVariations) {
                                                       
                                                       if (hasSelectedVariations) {
                                                           [self checkWebView:self.webView
                                                               withJavascript:kEbayQueryFindItemVariationString
                                                            completionHandler:^(id result, NSError *error) {
                                                                
                                                                if ([result isKindOfClass:[NSString class]]) {
                                                                    NSString *resultString = (NSString *)result;
                                        
                                                                    [self itemFoundWithCode:itemCode
                                                                          andDifferentiator:resultString];
                                                                }
                                                                
                                                            }];
                                                       }

                                                   } else {
                                                       //NSLog(@"itemFoundWithCode %@", itemCode);
                                                       [self itemFoundWithCode:itemCode
                                                             andDifferentiator:nil];
                                                   }
                                                   
                                               }];
                      }];
            
            break;
        }
            
        default:
            break;
    }
}

/**
 To report that the WebView found a item
 */
- (void)itemFoundWithCode:(NSString *)code andDifferentiator:(NSString *)differentiator {
    NSString *site = [self getSiteFromKindEnum:self.kind];
    
    BUSItemSearch *itemSearch = [BUSItemSearch createWithSite:site
                                                         code:code
                                               differentiator:differentiator];
    

    if (self.delegate) {
        [self.delegate webContentViewDidFoundItemSearch:itemSearch];
    }
}

/**
 Checks trought a given JavaScript code the WebView content
 */
- (void)checkWebView:(WKWebView *)webView withJavascript:(NSString *)javascript completionHandler:(void (^)(id result, NSError *error))completionHandler {
    //NSLog(@"javascript %@", javascript);
    [webView evaluateJavaScript:javascript
              completionHandler:^(id result, NSError *error) {
                  if (completionHandler) {
                      //NSLog(@"result %@", result);
                      completionHandler(result, error);
                      
                  }
              }];
    

}

# pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // To clean a item search
    self.foundItem = FALSE;
    [self itemNotFound];
    
    if (self.delegate) {
        [self.delegate webContentViewIsLoadingContent:YES];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"se cargó la página");
    switch (self.kind) {
        case BUSWebContentViewKindAmazon: {
//            [self findAmazonItemOnWebView:webView
//                        completionHandler:^(BOOL isItemPage) {
//                            if (isItemPage) {
//                                [self itemFound];
//
//                            }
//                        }];
            
            [self.webView evaluateJavaScript:BLAmazonAlertMsg completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideHamburger completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideItems completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideAddress completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideReviewsHome completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideReviews completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideLogin completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideDeals completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideLogin2 completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideLists completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideReviewDetail completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideFooter completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideCart completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideSample completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideGift completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHideClick completionHandler:nil];
            [self.webView evaluateJavaScript:BLAmazonHidePrime completionHandler:nil];
            
            break;
            
        }
            
        case BUSWebContentViewKindEbay: {
            
//            [self findEbayItemOnWebView:webView
//                      completionHandler:^(NSString *itemCode) {
//
//                          //NSLog(@"webView title!%@",webView.title);
//
//                          if (![NSString stringIsNilOrEmpty:itemCode]) {
//                              [self itemFound];
//                          }
//                      }];
//
            [self.webView evaluateJavaScript:BLEbayHideItems completionHandler:nil];
            [self.webView evaluateJavaScript:BLEbayAlertMsg completionHandler:nil];
            [self.webView evaluateJavaScript:BLEbay2AlertMsg completionHandler:nil];
            break;
        }
            
        default:
            break;
    }
    
    
    if (self.delegate && !self.foundItem) {
        [self.delegate webContentViewIsLoadingContent:NO];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.delegate) {
        [self.delegate webContentViewIsLoadingContent:NO];
        
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        if (self.delegate) {
            [self.delegate webContentViewIsLoadingContent:NO];
            
            [self.delegate webContentViewWantsToShowAlertViewWithTitle:@"Error"
                                                            andMessage:error.localizedDescription];
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        
        NSURL *url = navigationAction.request.URL;
        NSString *host = url.host;
        
        if (![host hasSuffix:kAmazonBaseUrl] &&
            ![host hasSuffix:kEbayBaseUrlDomain]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            
            NSString *title = @"No se puede abandonar la tienda";
            NSString *message = [NSString stringWithFormat:@"El enlace al que intentaste acceder está fuera de la página de la tienda %@", webView.URL.host];
            
            [self.delegate webContentViewWantsToShowAlertViewWithTitle:title
                                                            andMessage:message];
            
            return;
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kvoEstimatedProgressKey]){
        if (object == self.webView){
            
            
            if(!self.foundItem)
            {
                
                NSLog(@"observeValueForKeyPath webview");
                
                
                switch (self.kind) {
                    case BUSWebContentViewKindAmazon: {
                        [self findAmazonItemOnWebView:self.webView
                                    completionHandler:^(BOOL isItemPage) {
                                        if (isItemPage) {
                                            self.foundItem = TRUE;
                                            NSLog(@"amazon item found");
                                            [self itemFound];
                                            if (self.delegate) {
                                                [self.delegate webContentViewIsLoadingContent:NO];
                                            }
                                            
                                        }
                                    }];
                        
                     break;
                    }
                        
                    case BUSWebContentViewKindEbay: {
                        
                        [self findEbayItemOnWebView:self.webView
                                  completionHandler:^(NSString *itemCode) {
                                      if (![NSString stringIsNilOrEmpty:itemCode]) {
                                          self.foundItem = TRUE;
                                          NSLog(@"ebay item found");
                                          [self itemFound];
                                          if (self.delegate) {
                                              [self.delegate webContentViewIsLoadingContent:NO];
                                          }
                                      }
                                  }];
                        
                        break;
                    }
                        
                    default:
                        break;
                }
                

            }
            
            
            if (context == &kvoEstimatedProgressContext){
                if (self.delegate) {
                    NSString *new = [change objectForKey:@"new"];
                    CGFloat estimatedProgress = [new floatValue];
                    
                    [self.delegate webContentViewDidUpdateEstimatedProgress:estimatedProgress];
                }
            }
        }
    }
}

@end
