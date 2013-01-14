//
//  SensorManager.m
//  SensorManager3
//
//  Created by Set on 2013/01/07.
//  Copyright (c) 2013年 Set Minami. All rights reserved.
//

#import "SensorManager.h"


@implementation SensorManager
@synthesize paths = _paths,dir = _dir,db = _db;

-(SensorManager*)init{
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dir = [paths objectAtIndex:0];
    db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];
    
    return self;
}

-(void)createChildTable{
    
    NSString* createChildReaction
        = @"CREATE TABLE IF NOT EXISTS ChildReactions (dat TEXT);";
    [db open];
    [db executeUpdate:createChildReaction];
    [db close];
}

-(void)insertReactions:(NSString*)fileName_abs{
    NSArray* fileName = [fileName_abs componentsSeparatedByString:FILE_SPLITTER];
    NSArray* fileType = [fileName.lastObject componentsSeparatedByString:SUFF];
    
    NSString* insertReactionstoChildReactions
        = @"INSETR INTO ChildReactions(dat) values(?)";
    
    if([db open]){
        [db beginTransaction];
        NSString* date = fileType[0];
        NSString* filetype = fileType[1];
        NSString* objectpath = fileName_abs;
        [db executeUpdate:@"INSETR INTO ChildReactions(dat) values(?)",date];
        [db commit];
    }
    [db close];
}
@end
