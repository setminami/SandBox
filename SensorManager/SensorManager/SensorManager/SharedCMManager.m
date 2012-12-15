//
//  SharedCMManager.m
//  SensorManager
//
//  Created by Set on 2012/12/13.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "SharedCMManager.h"

@implementation SharedCMManager

static SharedCMManager* sharedCM3 = nil;
static CMMotionManager* shared = nil;//[[CMMotionManager alloc]init];


+(SharedCMManager*)sharedManager{
    @synchronized(self){
        if(sharedCM3 == nil){
            sharedCM3 = [[SharedCMManager alloc]init];
            if(shared == nil){
                shared = [[CMMotionManager alloc]init];
            }
        }
    }
    return sharedCM3;
}

/*+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if(sharedCM3 == nil){
            sharedCM3 =  [self allocWithZone:zone];
            return sharedCM3;
        }
    }
    return nil;
}*/

-(CMMotionManager*)getSCMM{
    return shared;
}

-(id)copy{
    return self;
}


-(id)autoRelease{
    return self;
}
@end
