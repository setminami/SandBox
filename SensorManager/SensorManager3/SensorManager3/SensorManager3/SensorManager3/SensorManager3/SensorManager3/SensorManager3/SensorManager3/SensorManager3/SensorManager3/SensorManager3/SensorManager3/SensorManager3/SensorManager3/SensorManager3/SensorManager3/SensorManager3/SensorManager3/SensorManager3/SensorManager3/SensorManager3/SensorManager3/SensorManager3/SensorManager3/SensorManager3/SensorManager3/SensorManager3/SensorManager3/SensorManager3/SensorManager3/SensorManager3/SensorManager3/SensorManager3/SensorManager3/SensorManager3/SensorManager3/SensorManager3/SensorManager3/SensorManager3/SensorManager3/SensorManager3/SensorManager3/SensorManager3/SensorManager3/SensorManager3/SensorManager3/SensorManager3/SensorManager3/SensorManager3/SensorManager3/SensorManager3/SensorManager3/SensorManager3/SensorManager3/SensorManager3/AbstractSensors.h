//
//  AbstractSensors.h
//  SensorThreadManager
//
//  Created by Set on 2012/12/16.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Set_SensorPickersProtocol.h"

@interface AbstractSensors : NSObject<Set_SensorPickersProtocol>{
    
}
@property NSOperationQueue *opQueue;

-(void)start:(id)withInitOptions;
-(void)start;
-(void)stop;
-(void)awake;

-(void)main;

-(BOOL)canBeThread;
-(void)breakWorking;



@end
