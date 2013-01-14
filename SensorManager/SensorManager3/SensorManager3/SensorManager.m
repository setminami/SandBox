//
//  SensorManager.m
//  SensorManager3
//
//  Created by Set on 2013/01/07.
//  Copyright (c) 2013年 Set Minami. All rights reserved.
//

#import "SensorManager.h"


@implementation ObjectsData
@synthesize userId = _userId,objectId = _objectId,fileType = _fileType,objectPath = _objectPath,date = _date;

-(NSInteger) getUserId{return _userId;}
-(NSInteger) getObjectId{return _objectId;}
-(NSDate*) getDate{return _date;}
-(NSString*) getFileType{return _fileType;}
-(NSString*) getObjectPath{return _objectPath;}

@end

@implementation SensorManager
@synthesize paths = _paths,dir = _dir,db = _db,wasInitiate = _wasInitiate;

-(SensorManager*)init{
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dir = [paths objectAtIndex:0];
    db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];
    wasInitiate = YES;
    return self;
}

//
-(void)createObjectsTable{
    NSString* createObjects =
            @"CREATE TABLE IF NOT EXISTS Objects (ObjectId integer,userid integer,filetype text,objectpath text(256));";
    [db open];
    [db executeUpdate:createObjects];
    [db close];
}

-(NSArray*)checkObjects{
    [self createObjectsTable];
    NSString* selectObjects =
        @"select objectpath from objects";
    [db open];
    
    FMResultSet* result = [db executeQuery:selectObjects];
    NSMutableArray* array = [NSMutableArray array];
    
    while ([result next]) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[NSString stringWithString:[result stringForColumn:@"objectpath"]] forKey:@"objectpath"];
        [array addObject:dic];
    }
    
    [db close];
    return [NSMutableArray arrayWithArray:array];
}

-(Search)searchObject:(NSURL*)url{
    NSString* searchURL = @"select * from Objects where objectpath=?";
    [db open];
    NSString* test = [url absoluteString];
    FMResultSet* result = [db executeQuery:searchURL,[NSString stringWithString:test]];
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    while ([result next]) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[NSString stringWithString:[result stringForColumn:@"objectpath"]] forKey:@"objectpath"];
        [array addObject:dic];
    }
    [result close];
    [db close];
    
    int count = [array count];
    if(count == 1){
        return HIT_ONE_ELEMENT;
    }else if(count > 1){
        return HIT_TWO_orMore_ELEMENT;
    }else{
        return HIT_ZERO_ELEMENT;
    }
    
}

-(void)insertObjects:(NSArray*)objs{
    NSString* insertObjects = @"insert into Objects (ObjectId,userid,filetype,objectpath) values (?,?,?,?)";
    if([db open]){
        [db beginTransaction];
        db.traceExecution = YES;
        for(int i=0;i < objs.count;i++){
            ObjectsData* o = [objs objectAtIndex:i];
            NSString* url = [o getObjectPath];

            [db executeUpdate:insertObjects,
             [NSNumber numberWithInteger:[o getObjectId]],
             [NSNumber numberWithInteger:[o getUserId]],
             [NSString stringWithString:[o getFileType]],
             [NSString stringWithString:url]];
        }
        db.traceExecution = NO;
        [db commit];
        [db close];
    }
}

-(void)createChildTable{
    
    NSString* createChildReaction
        = @"CREATE TABLE IF NOT EXISTS ChildReactions (userid integer,date text,filetype text,object text);";
    [db open];
    [db executeUpdate:createChildReaction];
    [db close];
}

-(void)insertReactions:(UInt8)userId:(NSString*)fileName_abs{

    NSArray* fileName = [fileName_abs componentsSeparatedByString:FILE_SPLITTER];
    NSArray* fileType = [fileName.lastObject componentsSeparatedByString:SUFF];
    
    NSString* insertReactionstoChildReactions
        = @"insert into ChildReactions (userid,date,filetype,object) values (?,?,?,?)";
    
    if([db open]){
        [db beginTransaction];
        db.traceExecution = YES;
        NSString* dateString = fileType[0];
        NSString* filetype = fileType[1];
        NSString* objectpath = fileName_abs;
        [db executeUpdate:insertReactionstoChildReactions,[NSNumber numberWithInt:userId],[NSString stringWithString:dateString],[NSString stringWithString:filetype],[NSString stringWithString:objectpath]];
        db.traceExecution = NO;
    }
    [db commit];
    [db close];
}
@end

