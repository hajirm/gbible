//
//  PKDatabase.m
//  gbible
//
//  Created by Kerri Shotts on 3/16/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKDatabase.h"
#import "PKBible.h"
#import "PKNotes.h"
#import "PKHighlights.h"
#import "PKSettings.h"

@implementation PKDatabase

    @synthesize bible;
    @synthesize content;
    
    static id _instance;
    
/**
 *
 * Return the global instance of the database
 *
 */
    +(id) instance
    {
        @synchronized (self)
        {
            if (!_instance)
            {
                _instance = [[self alloc] init];
            }
        }
        return _instance;
    }
    
/**
 *
 * Open our databases:we have two. The first is the bible content database, located within
 * our application's bundle. The second is the user's content database, which may or may not
 * even exist, and is located in the documents folder. If we can't open them, we log the error
 * and return nil. [This means things are bound to crash.]
 *
 */
    -(id) init
    {
        if (self = [super init])
        {
            // open our databases
            // locate our database within the application bundle
            NSString *bibleDatabase = [ NSHomeDirectory() stringByAppendingPathComponent:@"gbible.app/bibleContent" ];
            
            // locate our user content database
            NSString *userContentDatabase = [ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"userContent" ];
            
            // does the bible database exist? If not, we have a problem...
            if (! [[NSFileManager defaultManager] fileExistsAtPath:bibleDatabase] )
            {
                NSLog(@"[CRITICAL] Bibles could not be found at %@.", bibleDatabase);
                return nil;
            }
            else 
            {
                bible = [FMDatabase databaseWithPath:bibleDatabase];
            }
            
            content = [FMDatabase databaseWithPath:userContentDatabase];
            
            
            if (![bible open])
            {
                NSLog(@"[CRITICAL] Could not open Bible Database!");
                return nil;
            }
            
            if (![content open])
            {
                NSLog(@"[CRITICAL] Could not open User Content Database!");
                return nil;
            }
        }
        return self;
    }


    -(void) importNotes    {
        // locate our import database
        NSString *importDatabaseName = [ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"import.dat" ];
        FMDatabase *imdb = [FMDatabase databaseWithPath:importDatabaseName];
        if (![imdb open])
        {
            NSLog (@"[CRITICAL] Could not open the import.dat database!");
            return;
        }
        
        // make sure that we have the notes schema created
        PKNotes *noteModel = [PKNotes instance];

        // now that we have an open database, let's copy data out
        FMResultSet *s = [imdb executeQuery:@"SELECT * FROM notes"];
        
        while ([s next])
        {
            int theBook = [s intForColumnIndex:0];
            int theChapter = [s intForColumnIndex:1];
            int theVerse = [s intForColumnIndex:2];
            NSString *theTitle = [s stringForColumnIndex:3];
            NSString *theNote = [s stringForColumnIndex:4];
            
            // use our model to add the note (we'll happily overwrite an existing note, of course)
            [noteModel setNote:theNote withTitle:theTitle forPassage:[PKBible stringFromBook:theBook forChapter:theChapter forVerse:theVerse]];
        }

        [imdb close];
    }
    -(void) importHighlights    {
        // locate our import database
        NSString *importDatabaseName = [ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"import.dat" ];
        FMDatabase *imdb = [FMDatabase databaseWithPath:importDatabaseName];
        if (![imdb open])
        {
            NSLog (@"[CRITICAL] Could not open the import.dat database!");
            return;
        }

        // make sure that we have the notes schema created
        PKHighlights *highlightModel = [PKHighlights instance];

        // now that we have an open database, let's copy data out
        FMResultSet *s = [imdb executeQuery:@"SELECT * FROM highlights"];
        
        while ([s next])
        {
            int theBook = [s intForColumnIndex:0];
            int theChapter = [s intForColumnIndex:1];
            int theVerse = [s intForColumnIndex:2];
            NSString *theValue = [s stringForColumnIndex:3];
            
            NSArray *theColorArray = [theValue componentsSeparatedByString:@","];
            // there will always be 3 values; R=0, G=1, B=2
            UIColor *theColor = [UIColor colorWithRed:[[theColorArray objectAtIndex:0] floatValue]
                                       green:[[theColorArray objectAtIndex:1] floatValue] 
                                        blue:[[theColorArray objectAtIndex:2] floatValue] alpha:1.0];

            // use our model to add the highlight
            [highlightModel setHighlight:theColor forPassage:[PKBible stringFromBook:theBook forChapter:theChapter forVerse:theVerse]];
            
        }

        [imdb close];
    }
    -(void) importSettings
    {
        // locate our import database
        NSString *importDatabaseName = [ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"import.dat" ];
        FMDatabase *imdb = [FMDatabase databaseWithPath:importDatabaseName];
        if (![imdb open])
        {
            NSLog (@"[CRITICAL] Could not open the import.dat database!");
            return;
        }

        // make sure that we have the notes schema created
        PKSettings *settingsModel = [PKSettings instance];

        // now that we have an open database, let's copy data out
        FMResultSet *s = [imdb executeQuery:@"SELECT * FROM settings"];
        
        while ([s next])
        {
            NSString *theSettingKey = [s stringForColumnIndex:0];
            NSString *theSettingValue = [s stringForColumnIndex:1];
            
            // use our model to add the note (we'll happily overwrite an existing note, of course)
            [settingsModel saveSetting:theSettingKey valueForSetting:theSettingValue];
        }
        [settingsModel reloadSettings];
        [imdb close];
    }
    -(void) exportAll    {
        [content close];    // close the database first...
        
        // our export will be of the form: exportMMDDYYY_HHMISS.dat
        NSDate *theDate = [NSDate date];
        NSDateFormatter* theFormatter = [[NSDateFormatter alloc] init];
        [theFormatter setDateFormat:@"yyyyMMddHHmmss"];
        
        NSString *theExportName = [NSString stringWithFormat:@"export%@.dat",
                                        [theFormatter stringFromDate:theDate ]];
        // get the export name
        NSString *exportDatabaseName = [ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:theExportName ];
        // locate our user content database
        NSString *userContentDatabase = [ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"userContent" ];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSLog(@"Source File for Copy: %@", userContentDatabase);
        NSLog(@"Target File for Copy: %@", exportDatabaseName);
        
        if ( [fileManager copyItemAtPath:userContentDatabase toPath:exportDatabaseName error:nil] == YES)
        {
            NSLog(@"Export successful.");
        }
        else
        {
            NSLog(@"Export unsuccessful.");
        }
        
        [content open];
    }




/**
 *
 * Release our databases and close them.
 *
 */
    -(void) dealloc
    {
        // close our databases
        [content close];
        [bible close];
        content = nil;
        bible = nil;
    }
    
@end
