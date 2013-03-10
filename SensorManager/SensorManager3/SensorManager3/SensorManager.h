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


typedef enum dbSearch{
    HIT_ZERO_ELEMENT,
    HIT_ONE_ELEMENT,
    HIT_TWO_orMore_ELEMENT
}Search;

#define FILE_SPLITTER @"/"
#define SUFF @"."
#define DAYTIME_TOKEN @"_"
#define _DAY_TOKEN @"-"
#define _TIME_TOKEN @"-"
#define DB_NAME @"PeekaBoo.db"

@interface SensorManager :
    UIViewController{
    NSArray* paths;
    NSString* dir;
    FMDatabase* db;
        
    BOOL wasInitiate;
        
    BOOL isDbReady;
    NSCondition* _dbReady;
}

@property (nonatomic,readwrite) NSArray* paths;
@property (nonatomic,readwrite) NSString* dir;
@property (strong,readwrite) FMDatabase* db;
@property (nonatomic,readwrite) BOOL wasInitiate;

-(SensorManager*)init;
-(NSArray*)checkObjects;
-(void)insertObjects:(NSArray*)objs;
-(void)createChildTable;
-(void)insertReactions:(UInt8) userId :(NSString*) fileName;
-(Search)searchObject:(NSURL*)url;
-(NSURL*) changeObj:(NSInteger) userId ;
-(void) lock;
-(void) unlock;
-(void) setIsdbReady:(BOOL) YorN;
@end

@interface ObjectsData:NSObject{
    NSInteger userId;
    NSInteger objectId;
    NSDate* date;
    NSString* fileType;
    NSString* objectPath;
}
@property (nonatomic,readwrite) NSInteger userId;
@property (atomic,readwrite) NSInteger objectId;
@property (atomic,readwrite) NSString* fileType;
@property (atomic,readwrite) NSString* objectPath;
@property (atomic,readwrite) NSDate* date;
-(NSInteger) getUserId;
-(NSInteger) getObjectId;
-(NSDate*) getDate;
-(NSString*) getFileType;
-(NSString*) getObjectPath;

@end
