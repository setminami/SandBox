//
//  AccelSensorViewController.m
//  SensorManager
//
//  Created by Set on 2012/12/13.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "AccelSensorViewController.h"


@interface AccelSensorViewController (){
    NSOperationQueue *opQueue;
}

@end

@implementation AccelSensorViewController


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
    
    _SCMM = [SharedCMManager sharedManager];
    _SCMM.getSCMM.accelerometerUpdateInterval = 0.1;
    //if (_SCMM.getSCMM.accelerometerAvailable)
    //{
        // どちらか一方を使用する
        // プル型
        //[motionManager startAccelerometerUpdates];
        // プッシュ型
        [_SCMM.getSCMM startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                // 加速度データの処理
                                                NSLog(@"Move!");
                                            }];
    //}
    
}

-(void) main{
    opQueue = [[NSOperationQueue alloc]init];
    [opQueue addOperation:[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(awake) object:nil]];
}

-(void) start{
    
}

-(void) stop{
   [_SCMM.getSCMM stopAccelerometerUpdates];
}

-(void) motionSensorCallback:accelerometerData:error {
    NSLog(@"Moving!");
}


@end
