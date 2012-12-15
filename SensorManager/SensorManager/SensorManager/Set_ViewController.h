//
//  Set_ViewController.h
//  SensorManager
//
//  Created by Set on 2012/12/13.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Set_SensorPickersProtocol.h"

#define NUMOFSENSORS 10

@interface Set_ViewController : UIViewController
@property id<Set_SensorPickersProtocol> SSPP;
@property NSMutableArray *SSPPArray;
@end
