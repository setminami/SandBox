//
//  AbstractSensors.m
//  SensorThreadManager
//
//  Created by Set on 2012/12/16.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "AbstractSensors.h"


@implementation AbstractSensors


-(void)start{
    
}

-(void)start:(id)withInitOptions{
    if(withInitOptions == nil)[self start];
    else [self start:withInitOptions];
}

-(void)main{
    self.opQueue = [[NSOperationQueue alloc]init];
    [self.opQueue addOperation:[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(awake) object:nil]];
}

-(BOOL)canBeThread{
    //default YES
    return YES;
}

-(void)stop{
    
}

-(void)awake{
    
}

-(void)breakWorking{
    
}

@end
