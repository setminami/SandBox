//
//  SharedCMManager.h
//  SensorManager
//
//  Created by Set on 2012/12/13.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>


@interface SharedCMManager : NSObject
+(SharedCMManager*)sharedManager;
//+(id)allocWithZone:(NSZone *)zone;

-(CMMotionManager*)getSCMM;
-(id)copy;
-(id)autoRelease;
@end
