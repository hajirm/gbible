//
//  PKDatabase.m
//  gbible
//
//  Created by Kerri Shotts on 3/16/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKDatabase.h"

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
