//
//  SensorManager.h
//  SensorManager3
//
//  Created by Set on 2013/01/07.
//  Copyright (c) 2013年 Set Minami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"


#define FILE_SPLITTER @"/"
#define SUFF @"."
#define DAYTIME_TOKEN @"_"
#define _DAY_TOKEN @"-"
#define _TIME_TOKEN @"-"
#define DB_NAME @"PeekaBoo.db"

@interface SensorManager : NSObject{
    NSArray* paths;
    NSString* dir;
    FMDatabase* db;
}

@property (nonatomic,readwrite) NSArray* paths;
@property (nonatomic,readwrite) NSString* dir;
@property (strong,readwrite) FMDatabase* db;

-(SensorManager*)init;
-(void)createChildTable;
-(void)insertReactions:(NSString*)fileName;
@end
