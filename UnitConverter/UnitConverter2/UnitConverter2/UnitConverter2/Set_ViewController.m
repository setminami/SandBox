//
//  Set_ViewController.m
//  UnitConverter2
//
//  Created by Set on 2012/12/10.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "Set_ViewController.h"

@interface Set_ViewController ()

@end

@implementation Set_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_resultLabel release];
    [_tempText release];

    [_tempText release];
    [super dealloc];
}

-(IBAction)convertTemp:(id)sender
{
    double farenheit = [_tempText.text doubleValue];
    double celsius = farenheit - 32 / 1.8;
    
    NSString* resultString = [[NSString alloc] initWithFormat:@"Celsius:%f",celsius];
    _resultLabel.text = resultString;
}

- (IBAction)hideKeyBoard:(id)sender {
    [sender resignFirstResponder];
}
@end
