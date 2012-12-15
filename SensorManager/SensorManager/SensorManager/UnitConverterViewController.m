//
//  UnitConverterViewController.m
//  UnitConverter
//
//  Created by Set on 2012/12/10.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "UnitConverterViewController.h"

@interface UnitConverterViewController ()

@end

@implementation UnitConverterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)convertTemp:(id)sender
{
    double farenheit = [_tempText.text doubleValue];
    double celsius = farenheit - 32 / 1.8;
    
    NSString* resultString = [[NSString alloc] initWithFormat:@"Celsius:%f",celsius];
    _resultLabel.text = resultString;
}

@end
