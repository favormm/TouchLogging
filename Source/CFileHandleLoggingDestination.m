//
//  CFileHandleLoggingDestination.m
//  Logging
//
//  Created by Jonathan Wight on 10/13/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CFileHandleLoggingDestination.h"

@implementation CFileHandleLoggingDestination

@synthesize fileHandle;
@synthesize synchronizeOnWrite;
@synthesize transformer;
#if NS_BLOCKS_AVAILABLE
@synthesize block;
#endif /* NS_BLOCKS_AVAILABLE */

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        fileHandle = [[NSFileHandle fileHandleWithStandardError] retain];
        synchronizeOnWrite = YES;
        #if NS_BLOCKS_AVAILABLE
        block = ^(CLogEvent *inEvent) {
            char *theLevelString = NULL;
            switch (inEvent.level)
                {
                case LoggingLevel_EMERG:
                    theLevelString = "EMERG";
                    break;
                case LoggingLevel_ALERT:
                    theLevelString = "ALERT";
                    break;
                case LoggingLevel_CRIT:
                    theLevelString = "CRIT";
                    break;
                case LoggingLevel_ERR:
                    theLevelString = "ERROR";
                    break;
                case LoggingLevel_WARNING:
                    theLevelString = "WARN";
                    break;
                case LoggingLevel_NOTICE:
                    theLevelString = "NOTICE";
                    break;
                case LoggingLevel_INFO:
                    theLevelString = "INFO";
                    break;
                case LoggingLevel_DEBUG:
                    theLevelString = "DEBUG";
                    break;
                }
                
            NSTimeInterval theInterval = [inEvent.timestamp timeIntervalSinceDate:inEvent.session.started];    
            
            NSString *theString = [NSString stringWithFormat:@"%-6s: %8.3f : %@\n", theLevelString, theInterval, inEvent.message];
            NSData *theData = [theString dataUsingEncoding:NSUTF8StringEncoding];
            return(theData);
            };
        #endif /* NS_BLOCKS_AVAILABLE */
        }
    return(self);
    }
    
- (void)dealloc
    {
    [fileHandle release];
    fileHandle = NULL;
    
    [transformer release];
    transformer = NULL;

    [block release];
    block = NULL;
    //
    [super dealloc];
    }


- (BOOL)logging:(CLogging *)inLogging didLogEvent:(CLogEvent *)inEvent;
    {
    NSData *theData = [self.transformer transformedValue:inEvent];
#if NS_BLOCKS_AVAILABLE
    if (theData == NULL)
        {
        if (self.block)
            {
            theData = self.block(inEvent);
            }
        }
#endif /* NS_BLOCKS_AVAILABLE */

    if (theData != NULL)
        {
        [self.fileHandle writeData:theData];
        if (self.synchronizeOnWrite)
            {
            [self.fileHandle synchronizeFile];
            }
        }
    
    return(YES);
    }

@end
