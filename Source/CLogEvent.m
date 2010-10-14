//
//  CLogEvent.m
//  Logging
//
//  Created by Jonathan Wight on 10/13/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CLogEvent.h"

#import "CLogSession.h"

@implementation CLogEvent

@synthesize session;
@synthesize level;
@synthesize timestamp;
@synthesize sender;
@synthesize facility;
@synthesize message;
@synthesize userInfo;

- (void)dealloc
    {
    [session release];
    session = NULL;
    
    [timestamp release];
    timestamp = NULL;

    [sender release];
    sender = NULL;

    [facility release];
    facility = NULL;

    [message release];
    message = NULL;

    [userInfo release];
    userInfo = NULL;
    //
    [super dealloc];
    }

+ (NSString *)stringForLevel:(NSInteger)inLevel;
    {
    switch (inLevel)
        {
        case LoggingLevel_EMERG:
            return(@"Emergency");
        case LoggingLevel_ALERT:
            return(@"Alert");
        case LoggingLevel_CRIT:
            return(@"Critcial");
        case LoggingLevel_ERR:
            return(@"Error");
        case LoggingLevel_WARNING:
            return(@"Warning");
        case LoggingLevel_NOTICE:
            return(@"Notice");
        case LoggingLevel_INFO:
            return(@"Info");
        case LoggingLevel_DEBUG:
            return(@"Debug");
        default:
            return([NSString stringWithFormat:@"%d", inLevel]);
        }
    }


@end
