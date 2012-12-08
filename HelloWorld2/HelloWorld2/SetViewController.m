//
//  SetViewController.m
//  HelloWorld2
//
//  Created by Set on 2012/12/08.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SoundPickerViewController* SPVC = [[SoundPickerViewController alloc]init];
    [SPVC awakeFromNib];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
