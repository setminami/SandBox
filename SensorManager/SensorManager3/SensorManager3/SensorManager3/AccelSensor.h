//
//  AccelSensorViewController.h
//  SensorManager
//
//  Created by Set on 2012/12/13.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractSensors.h"


@interface AccelSensor : AbstractSensors{
    
}


-(BOOL)canBeThread;
-(void) awake;

-(void) main;
-(void) start;

-(void) stop;

@end
