//
//  Set_ViewController.h
//  SensorThreadManager
//
//  Created by Set on 2012/12/15.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorManager.h"



@interface Set_ViewController : UIViewController<UIWebViewDelegate>{
    BOOL isSetWebView;
    dispatch_queue_t main_queue;
    UINavigationBar* addressBar;
    SensorManager* sManager;
    IBOutlet UIWebView *webView;
    UINavigationBar* nav;
}
@property (assign,nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) SensorManager* sManager;
@property (nonatomic,readwrite) BOOL isSetWebview;
@property (nonatomic,readonly) UINavigationBar* addressBar;
@property (nonatomic,retain) UIWindow* window;

-(void) getWebView;
-(void)webViewDidStartLoad:(UIWebView *)webView;
-(void)webViewDidFinishLoad:(UIWebView *)webView;
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
