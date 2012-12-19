//
//  Set_AppDelegate.h
//  SensorManager3
//
//  Created by Set on 2012/12/19.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundPicker.h"
#import "AccelSensor.h"


#define NUMOFSENSORS 10
@interface Set_AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray* SSPPArray;
@end
