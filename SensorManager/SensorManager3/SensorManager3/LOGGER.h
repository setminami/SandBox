//
//  LOGGER.h
//  SensorManager3
//
//  Created by Set on 2013/01/09.
//  Copyright (c) 2013年 Set Minami. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __DEBUG__
#define LOG(A, ...) NSLog(@"DEBUG: %s:%d:%@", __PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:A, ## __VA_ARGS__]);
#else
#define LOG(A,...) //
#endif

