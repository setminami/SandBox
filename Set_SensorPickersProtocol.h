//
//  Set_SensorPickersProtocol.h
//  SensorManager
//
//  Created by Set on 2012/12/13.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Set_SensorPickersProtocol <NSObject>

@required
-(BOOL)canBeThread;

@required
-(void)awake;

@optional
-(void) start:withInitOptions;

@required
-(void) start;

@optional
-(void) breakWorking;

@required
-(void) stop;

@end
