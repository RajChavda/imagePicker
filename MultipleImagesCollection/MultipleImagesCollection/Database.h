/********************************************************************************\
 *
 * File Name       Database.h
 * Version         $Revision:: 01             $: Revision of last commit
 * Modified        $Date:: 2011-12-15 16:01:19#$: Date of last commit
 * 
 * Copyright(c) 2011 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Database : NSObject {

	sqlite3 *databaseObj;

}
+(Database*) shareDatabase;

-(BOOL) createEditableCopyOfDatabaseIfNeeded;
-(NSString *) GetDatabasePath:(NSString *)dbName;
//-(BOOL) createDataBase:databaseName;

-(NSMutableArray *)SelectAllFromTable:(NSString *)query;
-(int)getCount:(NSString *)query;
-(BOOL)CheckForRecord:(NSString *)query;
- (void)Insert:(NSString *)query;
- (void)insertMultipleRecordsWithArray:(NSMutableArray *)arrayParameter inTable:(NSString *)tableName;
-(void)Delete:(NSString *)query;
-(void)Update:(NSString *)query;

- (NSMutableArray *)selectDetailsFromQuery:(NSString *)query;

@end
