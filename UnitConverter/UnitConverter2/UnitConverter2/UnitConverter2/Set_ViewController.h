//
//  Set_ViewController.h
//  UnitConverter2
//
//  Created by Set on 2012/12/10.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Set_ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UITextField *tempText;

@property (retain, nonatomic) IBOutlet UIView *tempView;
- (IBAction)hideKeyBoard:(id)sender;

@end
