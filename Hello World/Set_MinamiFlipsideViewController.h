//
//  Set_MinamiFlipsideViewController.h
//  Hello World
//
//  Created by Set on 2012/12/02.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Set_MinamiFlipsideViewController;

@protocol Set_MinamiFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(Set_MinamiFlipsideViewController *)controller;
@end

@interface Set_MinamiFlipsideViewController : UIViewController

@property (weak, nonatomic) id <Set_MinamiFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
