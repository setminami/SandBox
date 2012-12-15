//
//  Set_ViewController.m
//  SensorManager
//
//  Created by Set on 2012/12/13.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "Set_ViewController.h"
#import "SoundPickerViewController.h"
#import "AccelSensorViewController.h"


@interface Set_ViewController ()
@end

@implementation Set_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _SSPPArray = [[NSMutableArray alloc]initWithCapacity:NUMOFSENSORS];
	// Do any additional setup after loading the view, typically from a nib.
    
    _SSPPArray[0] = [[SoundPickerViewController alloc]init];
    _SSPPArray[1] = [[AccelSensorViewController alloc]init];
    
    //[_SSPPArray[0] getThread]= [[NSThread alloc] initWithTarget:self selector:@selector(_SSPPArray[0].awake) object:nil];
    for(int i = 0 ; i < _SSPPArray.count ; i++){
        if([_SSPPArray[i] canBeThread])[_SSPPArray[i] main];
    }
}

/*
-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        NSLog(@"Shaking　000");
    }
}
*/
@end
