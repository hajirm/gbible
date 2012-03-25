//
//  PKBible.m
//  gbible
//
//  Created by Kerri Shotts on 3/19/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKBible.h"
#import "PKSettings.h"
#import "PKDatabase.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation PKBible

    +(NSString *) nameForBook: (int)theBook
    {
    //
    // Books of the bible and chapter count obtained from http://www.deafmissions.com/tally/bkchptrvrs.html
    //
        NSArray *bookList = [NSArray arrayWithObjects: 
                      @"Genesis", @"Exodus", @"Leviticus", @"Numbers", @"Deuteronomy", @"Joshua", @"Judges", @"Ruth",
                      @"1 Samuel", @"2 Samuel", @"1 Kings", @"2 Kings", @"1 Chronicles", @"2 Chronicles",
                      @"Ezra", @"Nehemia", @"Esther", @"Job", @"Psalms", @"Proverbs", @"Ecclesiastes",
                      @"Song of Solomon", @"Isaiah", @"Jeremiah", @"Lamentations", @"Ezekial", @"Daniel",
                      @"Hosea", @"Joel", @"Amos", @"Obadiah", @"Jonah", @"Micah", @"Nahum", @"Habakkuk",
                      @"Zephaniah", @"Haggai", @"Zechariah", @"Malachi",
                      // New Testament
                      @"Matthew", @"Mark", @"Luke", @"John", @"Acts", @"Romans", @"1 Corinthians",
                      @"2 Corinthians", @"Galations", @"Ephesians", @"Philippians", @"Colossians",
                      @"1 Thessalonians", @"2 Thessalonians", @"1 Timothy", @"2 Timothy", @"Titus",
                      @"Philemon", @"Hebrews", @"James", @"1 Peter", @"2 Peter", @"1 John", @"2 John",
                      @"3 John", @"Jude", @"Revelation", nil];
        return [bookList objectAtIndex:theBook-1];
    }
    
    +(NSString *) numericalThreeLetterCodeForBook:(int)theBook
    {
        NSArray *bookList = [NSArray arrayWithObjects:
                          @"01O", @"02O", @"03O", @"04O", @"05O", @"06O", @"07O", @"08O",
                          @"09O", @"10O", @"11O", @"12O", @"13O", @"14O",
                          @"15O", @"16O", @"17O", @"18O", @"19O", @"20O", @"21O",
                          @"22O", @"23O", @"24O", @"25O", @"26O", @"27O",
                          @"28O", @"29O", @"30O", @"31O", @"32O", @"33O", @"34O", @"35O",
                          @"36O", @"37O", @"38O", @"39O",
                          // New Testament
                          @"40N", @"41N", @"42N", @"43N", @"44N", @"45N", @"46N",
                          @"47N", @"48N", @"49N", @"50N", @"51N",
                          @"52N", @"53N", @"54N", @"55N", @"56N",
                          @"57N", @"58N", @"59N", @"60N", @"61N", @"62N", @"63N",
                          @"64N", @"65N", @"66N", nil];
        return [bookList objectAtIndex:theBook-1];
    }
    
    +(NSString *) abbreviationForBook:(int)theBook
    {
        NSArray *bookList = [NSArray arrayWithObjects:
                          @"Gen", @"Exo", @"Lev", @"Num", @"Deu", @"Jos", @"Jdg", @"Rut",
                          @"1Sa", @"2Sa", @"1Ki", @"2Ki", @"1Ch", @"2Ch",
                          @"Ezr", @"Neh", @"Est", @"Job", @"Psa", @"Pro", @"Ecc",
                          @"Sos", @"Isa", @"Jer", @"Lam", @"Eze", @"Dan",
                          @"Hos", @"Joe", @"Amo", @"Oba", @"Jon", @"Mic", @"Nah", @"Hab",
                          @"Zep", @"Hag", @"Zec", @"Mal",
                          // New Testament
                          @"Mat", @"Mar", @"Luk", @"Joh", @"Act", @"Rom", @"1Co",
                          @"2Co", @"Gal", @"Eph", @"Phi", @"Col",
                          @"1Th", @"2Th", @"1Ti", @"2Ti", @"Tit",
                          @"Phl", @"Heb", @"Jas", @"1Pe", @"2Pe", @"1Jo", @"2Jo",
                          @"3Jo", @"Jud", @"Rev", nil];
        return [bookList objectAtIndex:theBook-1];
    }
    
    +(int) countOfChaptersForBook:(int)theBook 
    {
        NSArray *chapterCountList = [NSArray arrayWithObjects:
                              [NSNumber numberWithInt:50], 
                              [NSNumber numberWithInt:40], 
                              [NSNumber numberWithInt:27], 
                              [NSNumber numberWithInt:36], 
                              [NSNumber numberWithInt:34], 
                              [NSNumber numberWithInt:24], 
                              [NSNumber numberWithInt:21], 
                              [NSNumber numberWithInt:4], 
                              [NSNumber numberWithInt:31], 
                              [NSNumber numberWithInt:24], 
                              [NSNumber numberWithInt:22], 
                              [NSNumber numberWithInt:25], 
                              [NSNumber numberWithInt:29], 
                              [NSNumber numberWithInt:36], 
                              [NSNumber numberWithInt:10], 
                              [NSNumber numberWithInt:13], 
                              [NSNumber numberWithInt:10], 
                              [NSNumber numberWithInt:42], 
                              [NSNumber numberWithInt:150],
                              [NSNumber numberWithInt:31], 
                              [NSNumber numberWithInt:12] ,
                              [NSNumber numberWithInt:8] ,
                              [NSNumber numberWithInt:66] ,
                              [NSNumber numberWithInt:52], 
                              [NSNumber numberWithInt:5], 
                              [NSNumber numberWithInt:48], 
                              [NSNumber numberWithInt:12], 
                              [NSNumber numberWithInt:14], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:9], 
                              [NSNumber numberWithInt:1], 
                              [NSNumber numberWithInt:4], 
                              [NSNumber numberWithInt:7], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:2], 
                              [NSNumber numberWithInt:14], 
                              [NSNumber numberWithInt:4],
                              // New Testament
                              [NSNumber numberWithInt:28], 
                              [NSNumber numberWithInt:16], 
                              [NSNumber numberWithInt:24], 
                              [NSNumber numberWithInt:21], 
                              [NSNumber numberWithInt:28], 
                              [NSNumber numberWithInt:16], 
                              [NSNumber numberWithInt:16], 
                              [NSNumber numberWithInt:12], 
                              [NSNumber numberWithInt:6], 
                              [NSNumber numberWithInt:6], 
                              [NSNumber numberWithInt:4], 
                              [NSNumber numberWithInt:4], 
                              [NSNumber numberWithInt:5], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:6], 
                              [NSNumber numberWithInt:4], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:1], 
                              [NSNumber numberWithInt:13], 
                              [NSNumber numberWithInt:5], 
                              [NSNumber numberWithInt:5], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:5], 
                              [NSNumber numberWithInt:1], 
                              [NSNumber numberWithInt:1], 
                              [NSNumber numberWithInt:1], 
                              [NSNumber numberWithInt:22]
                              , nil ];
        return [[chapterCountList objectAtIndex:theBook-1] intValue];
    }
    
    +(int) countOfVersesForBook:(int)theBook forChapter:(int)theChapter 
    {
        int totalGreekCount;
        int totalEnglishCount;
        int totalCount;
        NSString *theSQL = @"SELECT count(*) FROM content WHERE bibleID=? AND bibleBook = ? AND bibleChapter = ?";
    
        int currentGreekBible = [[PKSettings instance] greekText];
        int currentEnglishBible = [[PKSettings instance] englishText];
        FMDatabase *db = [[PKDatabase instance] bible];
        
        FMResultSet *s = [db executeQuery:theSQL, [NSNumber numberWithInt:currentGreekBible], 
                                                  [NSNumber numberWithInt:theBook],
                                                  [NSNumber numberWithInt:theChapter]];
        while ([s next])
        {
            totalGreekCount = [s intForColumnIndex:0];
        }

        s = [db executeQuery:theSQL, [NSNumber numberWithInt:currentEnglishBible], 
                                                  [NSNumber numberWithInt:theBook],
                                                  [NSNumber numberWithInt:theChapter]];
        while ([s next])
        {
            totalEnglishCount = [s intForColumnIndex:0];
        }
        
        totalCount = MAX(totalGreekCount, totalEnglishCount);
        
        return totalCount;
    }
    
    +(NSString *) getTextForBook:(int)theBook forChapter:(int)theChapter forVerse:(int)theVerse forSide:(int)theSide
    {
        int currentBible = (theSide==1 ? [[PKSettings instance] greekText] : [[PKSettings instance] englishText]);
        FMDatabase *db = [[PKDatabase instance] bible];
        NSString *theSQL = @"SELECT bibleText FROM content WHERE bibleID=? AND bibleBook=? AND bibleChapter=? AND bibleVerse=?";
        NSString *theText;
        NSString *theRef = [NSString stringWithFormat:@"%i ", theVerse];
        
        FMResultSet *s = [db executeQuery:theSQL, [NSNumber numberWithInt:currentBible] , 
                                                  [NSNumber numberWithInt:theBook],
                                                  [NSNumber numberWithInt:theChapter],
                                                  [NSNumber numberWithInt:theVerse]];
        while ([s next])
        {
            theText = [s stringForColumnIndex:0];
        }
        
        if (theSide == 2)
        {
            theText = [theRef stringByAppendingString:theText];
        }
        theText = [theText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return theText;
    }

    +(NSArray *) getTextForBook:(int)theBook forChapter:(int)theChapter forSide:(int)theSide
    {
        int currentBible = (theSide==1 ? [[PKSettings instance] greekText] : [[PKSettings instance] englishText]);
        FMDatabase *db = [[PKDatabase instance] bible];
        
        NSString *theSQL = @"SELECT bibleText FROM content WHERE bibleID=? AND bibleBook = ? AND bibleChapter = ?";
        //NSArray *theArray = [[NSArray alloc] init];
        NSMutableArray *theArray = [[NSMutableArray alloc] init];
        
        FMResultSet *s = [db executeQuery:theSQL, [NSNumber numberWithInt:currentBible], 
                                                  [NSNumber numberWithInt:theBook],
                                                  [NSNumber numberWithInt:theChapter]];
        int i=1;
        while ([s next])
        {
            NSString *theText = [s stringForColumnIndex:0];
            NSString *theRef = [NSString stringWithFormat:@"%i ", i];
            if (theSide == 2)
            {
                theText = [theRef stringByAppendingString:theText];
            }
            theText = [theText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [theArray addObject:theText];
            i++;
        }
        
        
        /*
        NSMutableArray *theArray = [[NSMutableArray alloc] init];
        NSString *theText;
        int i = 1;
        do 
        {
            theText = [self getTextForBook:theBook forChapter:theChapter forVerse:i forSide:theSide];
            if (theText != nil)
            {
                [theArray addObject: theText];
            }
            i++;
        } 
        while (theText != nil);
        */
        return theArray;
    }

    
    +(NSString *) stringFromBook:(int)theBook forChapter:(int)theChapter forVerse:(int)theVerse
    {
        NSString *theString;
        theString = [[[[[self numericalThreeLetterCodeForBook:theBook] stringByAppendingString:@"."]
                         stringByAppendingFormat:@"%i", theChapter] stringByAppendingString:@"."]
                         stringByAppendingFormat:@"%i", theVerse];
        return theString;
    }
    
    +(NSString *) stringFromBook:(int)theBook forChapter:(int)theChapter
    {
        NSString *theString;
        theString = [[[self numericalThreeLetterCodeForBook:theBook] stringByAppendingString:@"."] 
                       stringByAppendingFormat:@"%i", theChapter];
        return theString;
    }

    +(int) bookFromString:(NSString *)theString
    {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9]+[O|N])\\.([0-9]+)\\.([0-9]+)"
                                                          options: NSRegularExpressionCaseInsensitive
                                                          error: &error ];
        NSArray *matches = [regex matchesInString:theString options:0 range:NSMakeRange(0, [theString length])];
        if ([matches count]>0)
        {
            NSTextCheckingResult *match = [matches objectAtIndex:0];
            return [[theString substringWithRange:[match range]] intValue];
        }
        return 0;
    }
    
    +(int) chapterFromString:(NSString *)theString
    {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9]+[O|N])\\.([0-9]+)\\.([0-9]+)"
                                                          options: NSRegularExpressionCaseInsensitive
                                                          error: &error ];
        NSArray *matches = [regex matchesInString:theString options:0 range:NSMakeRange(0, [theString length])];
        if ([matches count]>1)
        {
            NSTextCheckingResult *match = [matches objectAtIndex:1];
            return [[theString substringWithRange:[match range]] intValue];
        }
        return 0;
    }
    
    +(int) verseFromString:(NSString *)theString
    {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9]+[O|N])\\.([0-9]+)\\.([0-9]+)"
                                                          options: NSRegularExpressionCaseInsensitive
                                                          error: &error ];
        NSArray *matches = [regex matchesInString:theString options:0 range:NSMakeRange(0, [theString length])];
        if ([matches count]>2)
        {
            NSTextCheckingResult *match = [matches objectAtIndex:2];
            return [[theString substringWithRange:[match range]] intValue];
        }
        return 0;
    }
    
    +(CGFloat)formattedTextHeight: (NSArray *)theWordArray withParsings:(BOOL)parsed
    {
        // this is our font
        UIFont *theFont = [UIFont fontWithName:[[PKSettings instance] textFontFace]
                                          size:[[PKSettings instance] textFontSize]];
        // we need to know the height of an M (* the setting...)
        CGFloat lineHeight = [@"M" sizeWithFont:theFont].height;
        lineHeight = lineHeight * ((float)[[PKSettings instance] textLineSpacing] / 100.0);
        // determine the maximum size of the column (1 line, 2 lines, 3 lines?)
        CGFloat columnHeight = lineHeight;
        columnHeight += (lineHeight * [[PKSettings instance] textVerseSpacing]);
        if (parsed)
        {
            // are we going to show morphology?
            if ([[PKSettings instance] showMorphology])
            {
                columnHeight += lineHeight;
            }
            columnHeight += lineHeight; // for G#s
        }
        
        CGFloat maxY = 0.0;
        for (int i=0; i<[theWordArray count];i++)
        {
            NSArray *theWordElement = [theWordArray objectAtIndex:i];
            //NSString *theWord = [theWordElement objectAtIndex:0];
            //int theWordType = [[theWordElement objectAtIndex:1] intValue];
            //CGFloat wordX = [[theWordElement objectAtIndex:2] floatValue];
            CGFloat wordY = [[theWordElement objectAtIndex:3] floatValue];
            
            if (wordY > maxY)
            {
                maxY = wordY;
            }
        }
        
        //maxY += columnHeight + lineHeight;
        maxY += lineHeight*2;
        
        return maxY;
    }
    
    +(CGFloat) columnWidth: (int) theColumn forBounds: (CGRect)theRect
    {
        // define our column (based on incoming rect)
        float columnMultiplier = 1;
        int columnSetting = [[PKSettings instance] layoutColumnWidths];
        if (columnSetting == 0) // 600930
        {
            if (theColumn == 1) {   columnMultiplier = 1.75;    }
            if (theColumn == 2) {   columnMultiplier = 1.25;    }
        }
        if (columnSetting == 1) // 300960
        {
            if (theColumn == 1) {   columnMultiplier = 1.25;    }
            if (theColumn == 2) {   columnMultiplier = 1.75;    }
        }
        if (columnSetting == 2) // 600930
        {
            columnMultiplier = 1.5;
        }
        if (theColumn == 3) { columnMultiplier = 0.25; }
        columnMultiplier = columnMultiplier / 3;
        
        CGFloat columnWidth = (theRect.size.width) * columnMultiplier;
        
        return columnWidth;
    }
    
    +(NSArray *)formatText: (NSString *)theText forColumn: (int)theColumn withBounds: (CGRect)theRect withParsings: (BOOL)parsed
    {
        // this array will contain the word elements
        NSMutableArray *theWordArray = [[NSMutableArray alloc]init];
        
        // this is our font
        UIFont *theFont = [UIFont fontWithName:[[PKSettings instance] textFontFace]
                                          size:[[PKSettings instance] textFontSize]];
        
        // set starting points
        CGFloat startX = theRect.origin.x + 5; // some margin
        CGFloat startY = 0; //theRect.origin.y;
        CGFloat curX = startX;
        CGFloat curY = startY;
        
        // maximum point
        CGFloat endX   = startX + theRect.size.width;
        
        CGFloat columnWidth = [self columnWidth:theColumn forBounds:theRect]; // (theRect.size.width) * columnMultiplier;
        
        // new maximum point
        endX = startX + columnWidth - 5; // some margin
                                                  
        // split by spaces
        NSArray *matches = [theText componentsSeparatedByString:@" "];
        
        // we need to know the width of a space
        CGFloat spaceWidth = [@" " sizeWithFont:theFont].width;
        // we need to know the height of an M (* the setting...)
        CGFloat lineHeight = [@"M" sizeWithFont:theFont].height;
        lineHeight = lineHeight * ((float)[[PKSettings instance] textLineSpacing] / 100.0);
        // determine the maximum size of the column (1 line, 2 lines, 3 lines?)
        CGFloat columnHeight = lineHeight;
        columnHeight += (lineHeight * [[PKSettings instance] textVerseSpacing]);
        if (parsed)
        {
            // are we going to show morphology?
            if ([[PKSettings instance] showMorphology])
            {
                columnHeight += lineHeight;
            }
            columnHeight += lineHeight; // for G#s
        }
        CGFloat yOffset = 0.0;
        
        // iterate through each word and wrap where necessary, building an
        // array of x, y points and words.
        
        int thePriorWordType = -1;
        int theWordType = -1;
        NSString *theWord;
        NSString *thePriorWord;
        
        CGFloat maxX = 0.0;
        
        for (int i=0; i<[matches count]; i++)
        {
            
            // move priors
            thePriorWordType = theWordType;
            thePriorWord = theWord;
            
            // got the current word
            theWord = [matches objectAtIndex:i];
            
            // and its size
            CGSize theSize = [theWord sizeWithFont:theFont];
            
            // determine the type of the word
            theWordType = 0;    // by default, we're a regular word
            yOffset = 0.0;
            
            
            if (theColumn == 1 && [theWord length]>2) // we only do this for greek text
            {
                // originally we used regular expressions, but they are SLOW
                // G#s are of the form G[0-9]+
                
                if ( [[theWord substringToIndex:1] isEqualToString:@"G"] &&
                     [[theWord substringFromIndex:1] intValue] > 0 )
                {
                    // we're a G#
                    theWordType = 10;
                    yOffset = lineHeight;
                }
                else 
                {
                    // are we a VARiant? (regex: VAR[0-9]
                    if ( [[theWord substringToIndex:2] isEqualToString:@"VAR"] )
                    {
                        theWordType = 0; // we're really just a regular word.
                        yOffset = 0.0;
                    }
                    else
                    {
                        // are we a morphology word? [A-Z]+[A-Z0-9\\-]+
                        if ( [[theWord uppercaseString] isEqualToString:theWord] 
                             && thePriorWordType >= 10)
                        {
                            // we are!
                            theWordType = 20;
                            yOffset = lineHeight *2;
                        }
                    }
                }
            }
            
            
            // determine this word's position, and if we should word-wrap or not.
            if (theWordType <= thePriorWordType || (theColumn == 2 && i>0))
            {
                // we're a new variation on the column. curX can move foward by maxX
                curX += maxX + spaceWidth;
                if (curX + theSize.width> endX-maxX-spaceWidth)
                {
                    curX = startX;
                    curY += columnHeight;
                }
                maxX = 0.0; // reset maximum width
            }
            
            if (theSize.width > maxX)
            {
                maxX = theSize.width;
            }
            
            // start creating our word element
            NSArray *theWordElement = [NSArray arrayWithObjects: theWord,
                                                                 [NSNumber numberWithInt:theWordType],
                                                                 [NSNumber numberWithFloat:curX],
                                                                 [NSNumber numberWithFloat:(curY + yOffset)], 
                                                                 [NSNumber numberWithFloat:theSize.width],
                                                                 [NSNumber numberWithFloat:theSize.height],
                                                                 nil];
            [theWordArray addObject:theWordElement]; 
            
            
        }
        
        return theWordArray;
    }
@end
