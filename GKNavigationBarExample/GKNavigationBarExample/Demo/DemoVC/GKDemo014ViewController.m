//
//  GKDemo014ViewController.m
//  GKNavigationBarExample
//
//  Created by QuintGao on 2019/11/15.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDemo014ViewController.h"
#import <WebKit/WebKit.h>
#import "GKDemo001ViewController.h"

@interface GKDemo014ViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation GKDemo014ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationItem.title = @"WebView跳转";
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.gk_navigationBar.mas_bottom);
    }];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"014" ofType:@"txt"];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        NSLog(@"跳转");
        
        GKDemo001ViewController *demo001VC = [GKDemo001ViewController new];
        [self.navigationController pushViewController:demo001VC animated:YES];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - 懒加载
- (WKWebView *)webView {
    if (!_webView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];

        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;

        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        // 设置字体大小(最小的字体大小)
//        preference.minimumFontSize = 15;
        // 设置偏好设置对象
        wkWebConfig.preferences = preference;
        
        CGRect frame = CGRectMake(0, 0, GK_SCREEN_WIDTH, 0);
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:wkWebConfig];
        webView.scrollView.alwaysBounceVertical = NO;
        if (@available(iOS 11.0, *)) {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        webView.navigationDelegate = self;
        
        _webView = webView;
    }
    return _webView;
}

@end
