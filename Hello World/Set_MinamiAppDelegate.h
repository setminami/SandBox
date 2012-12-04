//
//  Set_MinamiAppDelegate.h
//  Hello World
//
//  Created by Set on 2012/12/02.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@interface Set_MinamiAppDelegate : UIResponder <UIApplicationDelegate>{
    UIWindow *window;
    RootViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;

@end
