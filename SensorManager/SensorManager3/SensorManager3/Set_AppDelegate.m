//
//  Set_AppDelegate.m
//  SensorManager3
//
//  Created by Set on 2012/12/19.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "Set_AppDelegate.h"

@implementation Set_AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    _SSPPArray = [[NSMutableArray alloc]initWithCapacity:NUMOFSENSORS];
	// Do any additional setup after loading the view, typically from a nib.
    
    _SSPPArray[0] = [[SoundPicker alloc]init];
    //_SSPPArray[1] = [[AccelSensor alloc]init];
    
    //[_SSPPArray[0] getThread]= [[NSThread alloc] initWithTarget:self selector:@selector(_SSPPArray[0].awake) object:nil];
    for(int i = 0 ; i < _SSPPArray.count ; i++){
        if([_SSPPArray[i] canBeThread]){[_SSPPArray[i] main];}
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
