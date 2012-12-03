//
//  Set_MinamiMainViewController.h
//  Hello World
//
//  Created by Set on 2012/12/02.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "Set_MinamiFlipsideViewController.h"

@interface Set_MinamiMainViewController : UITableViewController <Set_MinamiFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
