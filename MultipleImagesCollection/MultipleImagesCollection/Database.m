
/********************************************************************************\
 *
 * File Name       Database.m
 * Version         $Revision:: 01             $: Revision of last commit
 * Modified        $Date:: 2011-12-15 16:24:59#$: Date of last commit
 * 
 * Copyright(c) 2011 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/

#import "Database.h"
static Database *shareDatabase =nil;

@implementation Database
#pragma mark -
#pragma mark Database


+(Database*) shareDatabase{
	
	if(!shareDatabase){
		shareDatabase = [[Database alloc] init];
	}
	return shareDatabase;
}

#pragma mark -
#pragma mark Get DataBase Path
NSString * const DataBaseName  = @"tempDB"; // Paas Your DataBase Name Over here

- (NSString *) GetDatabasePath:(NSString *)dbName{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:dbName];
}



-(BOOL) createEditableCopyOfDatabaseIfNeeded
{
    BOOL success; 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DataBaseName];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return success;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DataBaseName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iWant" message:@"Failed to create writable database" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
    return success;
}


#pragma mark -
#pragma mark Get All Record

- (NSMutableArray *)selectDetailsFromQuery:(NSString *)query {
   
    sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	NSMutableArray *alldata;
	alldata = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{
				                
				int count = sqlite3_column_count(statement);
				
                NSString *columnData;

				for (int i=0; i < count; i++) {
                    
					char *data = (char*) sqlite3_column_text(statement, i);
					
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
					}else {
						columnData = @"";
					}
                    
//					[currentRow setObject:columnData forKey:columnName];
                    [alldata addObject:columnData];
				}
                

			}
		}
        sqlite3_finalize(statement);
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return alldata ;

}



-(NSMutableArray *)SelectAllFromTable:(NSString *)query
{
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	NSMutableArray *alldata;
	alldata = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
        
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{	
				
				NSMutableDictionary *currentRow = [[NSMutableDictionary alloc] init];
                
				int count = sqlite3_column_count(statement);
				
				for (int i=0; i < count; i++) {
                    
					char *name = (char*) sqlite3_column_name(statement, i);
					char *data = (char*) sqlite3_column_text(statement, i);
					
					NSString *columnData;   
					NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
					}else {
						columnData = @"";
					}
                    
					[currentRow setObject:columnData forKey:columnName];
				}
                
				[alldata addObject:currentRow];
			}
		}
       sqlite3_finalize(statement); 
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return alldata;
    
}

#pragma mark -
#pragma mark Get Record Count

-(int)getCount:(NSString *)query
{
	int m_count=0;
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			if(sqlite3_step(statement) == SQLITE_ROW)
			{	
				m_count= sqlite3_column_int(statement,0);
			}
		}
		sqlite3_finalize(statement); 
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
	return m_count;
}

#pragma mark -
#pragma mark Check For Record Present

-(BOOL)CheckForRecord:(NSString *)query
{	
	sqlite3_stmt *statement = nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	int isRecordPresent = 0;
    
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL)) == SQLITE_OK)
		{
			if(sqlite3_step(statement) == SQLITE_ROW)
			{
				isRecordPresent = 1;
			}
			else {
				isRecordPresent = 0;
			}
		}
	}
	sqlite3_finalize(statement);	
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }	
	return isRecordPresent;
}

#pragma mark -
#pragma mark Insert

- (void)Insert:(NSString *)query 
{	
	sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement,NULL)) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
        else
        {
            printf(">>>>>>>>>>>>>>>>>>>>>>>>> >>>>>>>>>>>>>>>>>> Query is not Inserted");
        }
	}
    else
    {
        printf("Query is not Inserted");
    }
	sqlite3_finalize(statement);
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }
    else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}

//Add Multiple records in Array of Dictionaries format (There is limit of insertion of 500 records in one attempt but this method can insert more than 500 records)
- (void)insertMultipleRecordsWithArray:(NSMutableArray *)arrayParameter inTable:(NSString *)tableName {
    
	sqlite3_stmt *insertStmt = nil;
	
    NSString *path = [self GetDatabasePath:DataBaseName];
    
    NSArray *arrTotalField = [[arrayParameter objectAtIndex:0] allKeys];
    
    NSInteger intNumberOfTotalRecords = [arrayParameter count];
    NSInteger intCountOfInsertion = ceil((float)intNumberOfTotalRecords/500);
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    int count = 0;
    while (intCountOfInsertion > 0) {
        
        [tempArray removeAllObjects];
        
        int maximumLimit;
        
        if (intNumberOfTotalRecords > 500*(count+1)) {
            maximumLimit = 500*(count+1);
        }
        else {
            maximumLimit = (int)intNumberOfTotalRecords;
        }
        
        for (int i = 500*count ; i<maximumLimit; i++) {
            [tempArray addObject:[arrayParameter objectAtIndex:i]];
        }
        
        if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
        {
            
            NSString *strQuery = [NSString stringWithFormat:@"insert into %@ (%@) select ? as %@",tableName,[arrTotalField componentsJoinedByString:@","],[arrTotalField objectAtIndex:0]];
            
            //For second line of query SELECT 'data1' AS 'column1', 'data2' AS 'column2'
            for (int i = 1; i<[arrTotalField count]; i++) {
                strQuery = [strQuery stringByAppendingFormat:@" ,? as %@",[arrTotalField objectAtIndex:i]];
            }
            
            strQuery = [strQuery stringByAppendingFormat:@"\n"];
            
            //For another union statements
            for (int j = 1; j < [tempArray count]; j++) {
                
                strQuery = [strQuery stringByAppendingFormat:@"UNION SELECT ?"];
                
                for (int i = 1; i<[arrTotalField count]; i++) {
                    
                    strQuery = [strQuery stringByAppendingFormat:@" , ?"];
                }
                strQuery = [strQuery stringByAppendingFormat:@"\n"];
            }
            
//            NSLog(@"Query String :%@",strQuery);
            
            const char *sql =  [strQuery UTF8String];
            
            if(sqlite3_prepare_v2(databaseObj, sql, -1, &insertStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(databaseObj));
            
            //For data binding..
            int counter = 1;
            for (int j = 0; j < [tempArray  count]; j++) {
                for (int i = 0; i<[arrTotalField count]; i++) {
                    NSString *recordValue = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:j] valueForKey:[NSString stringWithFormat:@"%@",[arrTotalField objectAtIndex:i]]]];
                    
                    sqlite3_bind_text(insertStmt, counter, [recordValue UTF8String], -1, SQLITE_TRANSIENT);
                    counter++;
                    
                }
            }
            
            if(SQLITE_DONE != sqlite3_step(insertStmt))
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(databaseObj));
            
            //Reset the add statement.
            sqlite3_reset(insertStmt);
            
            sqlite3_finalize(insertStmt);
            sqlite3_close(databaseObj);
            
            intCountOfInsertion--;
            count++;
            
        }
    }
}

#pragma mark -
#pragma mark DeleteRecord

-(void)Delete:(NSString *)query
{
	sqlite3_stmt *statement = nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL)) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
	}
	sqlite3_finalize(statement);
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}

#pragma mark -
#pragma mark UpdateRecord

-(void)Update:(NSString *)query
{
	sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
		if(sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
		sqlite3_finalize(statement);
	}
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}

@end
