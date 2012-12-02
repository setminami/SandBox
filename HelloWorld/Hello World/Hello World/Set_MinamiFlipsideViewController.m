//
//  Set_MinamiFlipsideViewController.m
//  Hello World
//
//  Created by Set on 2012/12/02.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "Set_MinamiFlipsideViewController.h"

@interface Set_MinamiFlipsideViewController ()

@end

@implementation Set_MinamiFlipsideViewController

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

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

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
