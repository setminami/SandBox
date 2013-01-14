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
    UIWebView* webView;
    SensorManager* sManager;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) SensorManager* sManager;
@end
