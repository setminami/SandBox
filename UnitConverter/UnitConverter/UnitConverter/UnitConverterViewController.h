//
//  UnitConverterViewController.h
//  UnitConverter
//
//  Created by Set on 2012/12/10.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitConverterViewController : UIViewController

@property (strong ,nonatomic) IBOutlet UILabel* resultLabel;
@property (strong ,nonatomic) IBOutlet UITextField* tempText;

-(IBAction)convertTemp:(id)sender;
@end

