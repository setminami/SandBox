//
//  AccelSensorViewController.m
//  SensorManager
//
//  Created by Set on 2012/12/13.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "AccelSensor.h"


@interface AccelSensor (){
    NSOperationQueue *opQueue;
}

@end

@implementation AccelSensor


-(BOOL)canBeThread{
    return YES;
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        NSLog(@"Shaking 001");
    }
}

-(void)awake{
    NSLog(@"MotionSensor awake!");
    

    
}

-(void) main{
    opQueue = [[NSOperationQueue alloc]init];
    [opQueue addOperation:[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(awake) object:nil]];
}

-(void) start{
    
}

-(void) stop{
 
}

-(void) motionSensorCallback:accelerometerData:error {
    NSLog(@"Moving!");
}


@end
