//
//  PKHighlights.m
//  gbible
//
//  Created by Kerri Shotts on 3/29/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKHighlights.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "PKDatabase.h"
#import "PKBible.h"

@implementation PKHighlights

    static id _instance;

    +(id) instance
    {
        @synchronized (self)
        {
            if (!_instance)
            {
                _instance = [[self alloc] init];
                
                //create our scheme, if not already done.
                [_instance createSchema];
            }
        }
        return _instance;
    }

    -(void) createSchema
    {
        BOOL returnVal = YES;
        // get local versions of our databases
        FMDatabase *content = ((PKDatabase*) [PKDatabase instance]).content;

        returnVal = [content executeUpdate:@"CREATE TABLE highlights ( \
                                                book INT NOT NULL, \
                                                chapter INT NOT NULL, \
                                                verse INT NOT NULL, \
                                                value VARCHAR(255), \
                                                PRIMARY KEY (book, chapter, verse) \
                                             )"];
        if (returnVal)
        {
            NSLog (@"Created schema for highlights.");
        }
    }
    
    -(int) countHighlights
    {
        FMDatabase *content = ((PKDatabase*) [PKDatabase instance]).content;
        FMResultSet *s = [content executeQuery:@"SELECT COUNT(*) FROM highlights"];
        int theCount;
        if ([s next])
        {
            theCount = [s intForColumnIndex:0];
        }
        return theCount;
    }
    
    -(NSMutableArray *)allHighlightedPassages
    {
        FMDatabase *content = ((PKDatabase*) [PKDatabase instance]).content;
        FMResultSet *s = [content executeQuery:@"SELECT book,chapter,verse FROM highlights ORDER BY 1,2,3"];
        NSMutableArray *theArray = [[NSMutableArray alloc] init];
        while ([s next])
        {
            int theBook = [s intForColumnIndex:0];
            int theChapter = [s intForColumnIndex:1];
            int theVerse = [s intForColumnIndex:2];
            
            NSString *thePassage = [PKBible stringFromBook:theBook forChapter:theChapter forVerse:theVerse];
            [theArray addObject:thePassage];
        }
        return theArray;
    }

    -(NSMutableDictionary *)allHighlightedPassagesForBook: (int)theBook andChapter: (int)theChapter
    {
        FMDatabase *content = ((PKDatabase*) [PKDatabase instance]).content;
        FMResultSet *s = [content executeQuery:@"SELECT book,chapter,verse, value FROM highlights \
                                                  WHERE book=? AND chapter=? ORDER BY 1,2,3",
                                                  [NSNumber numberWithInt:theBook],
                                                  [NSNumber numberWithInt:theChapter]];
        NSMutableDictionary *theArray = [[NSMutableDictionary alloc] init];
        while ([s next])
        {
            int theVerse = [s intForColumnIndex:2];
            NSString *theResult = [s stringForColumnIndex:3];
            // we need to split the results: the highlight will be RRR,GGG,BBB (from 0.0 to 1.0)
            NSArray *theColorArray = [theResult componentsSeparatedByString:@","];
            // there will always be 3 values; R=0, G=1, B=2
            UIColor *theColor = [UIColor colorWithRed:[[theColorArray objectAtIndex:0] floatValue]
                                       green:[[theColorArray objectAtIndex:1] floatValue] 
                                        blue:[[theColorArray objectAtIndex:2] floatValue] alpha:1.0];
            
            [theArray setValue:theColor forKey:[NSString stringWithFormat:@"%i", theVerse]];
        }
        return theArray;
    }

    
    -(UIColor *)highlightForPassage:(NSString *)thePassage
    {
        NSNumber * theBook = [NSNumber numberWithInt:[PKBible bookFromString:thePassage]];
        NSNumber * theChapter = [NSNumber numberWithInt:[PKBible chapterFromString:thePassage]];
        NSNumber * theVerse = [NSNumber numberWithInt:[PKBible verseFromString:thePassage]]; 
        
        NSString *theResult;
        FMDatabase *content = ((PKDatabase*) [PKDatabase instance]).content;
        FMResultSet *s = [content executeQuery:@"SELECT value FROM highlights \
                                                 WHERE book=? AND chapter=? AND verse=?", 
                                                 theBook, theChapter, theVerse];
                                                 
        // if there is no highlight, we return nil.
        UIColor *theColor = nil;
        if ([s next])
        {
            theResult = [s stringForColumnIndex:0];
            // we need to split the results: the highlight will be RRR,GGG,BBB (from 0.0 to 1.0)
            NSArray *theColorArray = [theResult componentsSeparatedByString:@","];
            // there will always be 3 values; R=0, G=1, B=2
            theColor = [UIColor colorWithRed:[[theColorArray objectAtIndex:0] floatValue]
                                       green:[[theColorArray objectAtIndex:1] floatValue] 
                                        blue:[[theColorArray objectAtIndex:2] floatValue] alpha:1.0];
        }
        
        return theColor;
    }

    -(void) setHighlight: (UIColor *)theColor forPassage: (NSString *)thePassage
    {
        NSNumber * theBook = [NSNumber numberWithInt:[PKBible bookFromString:thePassage]];
        NSNumber * theChapter = [NSNumber numberWithInt:[PKBible chapterFromString:thePassage]];
        NSNumber * theVerse = [NSNumber numberWithInt:[PKBible verseFromString:thePassage]]; 

        FMDatabase *content = ((PKDatabase*) [PKDatabase instance]).content;
        BOOL theResult = YES;
        FMResultSet *resultSet;
        int rowCount = 0;
        
        float red=0.0; float green=0.0; float blue=0.0; float alpha=0.0;
        [theColor getRed:&red green:&green blue:&blue alpha:&alpha];
        
        NSString *theValue = [NSString  stringWithFormat:@"%f,%f,%f", red, green, blue];
        
        theResult = [content executeUpdate:@"UPDATE highlights SET value=? WHERE book=? AND chapter=? AND verse=?", 
                                                 theValue, theBook, theChapter, theVerse];
                             
        // check to see if it really did just set the value
        resultSet = [content executeQuery:@"SELECT * FROM highlights WHERE book=? AND chapter=? AND verse=?", 
                                                 theBook, theChapter, theVerse];
        if ([resultSet next])
        {
            rowCount++;
        }
        if (rowCount <1)
        {
            // nope; do an insert instead.
            theResult = [content executeUpdate:@"INSERT INTO highlights VALUES (?,?,?,?)",
                         theBook, theChapter, theVerse, theValue];
        }
        if (!theResult)
        {
            NSLog ( @"Couldn't save highlight for %@", thePassage);
        }
    }
    -(void) removeHighlightFromPassage: (NSString *)thePassage
    {
        NSNumber * theBook = [NSNumber numberWithInt:[PKBible bookFromString:thePassage]];
        NSNumber * theChapter = [NSNumber numberWithInt:[PKBible chapterFromString:thePassage]];
        NSNumber * theVerse = [NSNumber numberWithInt:[PKBible verseFromString:thePassage]]; 

        FMDatabase *content = ((PKDatabase*) [PKDatabase instance]).content;
        
        BOOL theResult = [content executeUpdate:@"DELETE FROM highlights WHERE book=? AND chapter=? AND verse=?",
                                                  theBook, theChapter, theVerse];
        if (!theResult)
        {
            NSLog(@"Could not remove highlight for %@", thePassage);
        }
    }

@end
