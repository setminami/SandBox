//
//  SoundPickerViewController.h
//  Hello World
//
//  Created by Set on 2012/12/07.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Set_ViewController.h"
#import "AbstractSensors.h"

@interface SoundPicker : AbstractSensors{
     AudioQueueRef queue;
}

@property float Volume;
@property float Interval;

-(BOOL) canBeThread;
-(void) start;
-(void) main;
-(void) stop;

@end
