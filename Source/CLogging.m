//
//  CLogging.m
//  TouchCode
//
//  Created by Jonathan Wight on 3/24/07.
//  Copyright 2009 Small Society. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CLogging.h"

#import "CFileHandleLoggingDestination.h"

static CLogging *gInstance = NULL;

@interface CLogging ()
- (void)startSession;
- (void)endSession;
@end

#pragma mark -

@implementation CLogging

@synthesize enabled;
@synthesize sender;
@synthesize facility;
@synthesize sessions;
@synthesize destinations;

+ (CLogging *)sharedInstance
    {
    NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

    @synchronized(@"CLogging.instance")
        {
        if (gInstance == NULL)
            {
            gInstance = [[CLogging alloc] init];
            }
        }

    [thePool release];

    return(gInstance);
    }

#pragma mark -

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        NSNumber *theEnabledFlag = [[[NSProcessInfo processInfo] environment] objectForKey:@"LOGGING"];
        if (theEnabledFlag)
            enabled = [theEnabledFlag boolValue];
        else
            enabled = YES;
            
        [self addDestination:[[[CFileHandleLoggingDestination alloc] init] autorelease]];
        }
    return(self);
    }

- (void)dealloc
    {
    [self endSession];

    [sender release];
    sender = NULL;
    [facility release];
    facility = NULL;
    [destinations release];
    destinations = NULL;
    //
    [super dealloc];
    }

#pragma mark -

- (NSMutableArray *)sessions
    {
    if (sessions == NULL)
        {
        sessions = [[NSMutableArray alloc] init];
        }
    return(sessions);
    }

#pragma mark -

- (void)addDestination:(id <CLoggingDestination>)inHandler
    {
    if (self.destinations == NULL)
        self.destinations = [NSMutableArray array];

    [self.destinations addObject:inHandler];

    if (self.sessions.count > 0)
        {
        if ([inHandler respondsToSelector:@selector(loggingDidStart:)])
            {
            [inHandler loggingDidStart:self];
            }
        }
    }

- (void)removeDestination:(id <CLoggingDestination>)inHandler
    {
    [self.destinations removeObject:inHandler];
    }

- (void)startSession
    {
    [self.sessions addObject:[[[CLogSession alloc] init] autorelease]];

    for (id <CLoggingDestination> theHandler in self.destinations)
        {
        if ([theHandler respondsToSelector:@selector(loggingDidStart:)])
            {
            [theHandler loggingDidStart:self];
            }
        }

    }

- (void)endSession
    {
    for (id <CLoggingDestination> theHandler in self.destinations)
        {
        if ([theHandler respondsToSelector:@selector(loggingDidEnd:)])
            {
            [theHandler loggingDidEnd:self];
            }
        }

    [self.sessions removeLastObject];
    }

#pragma mark -

- (void)logEvent:(CLogEvent *)inLogEvent;
    {
    if (self.enabled == NO)
        return;
        
    if (self.sessions.count == 0)
        {
        [self startSession];
        }

    inLogEvent.session = [self.sessions lastObject];
    inLogEvent.timestamp = [NSDate date];
    
    if (inLogEvent.sender == NULL)
        inLogEvent.sender = self.sender;
    if (inLogEvent.facility == NULL)
        inLogEvent.facility = self.facility;

    for (id <CLoggingDestination> theHandler in self.destinations)
        {
        [theHandler logging:self didLogEvent:inLogEvent];
        }
    }
    
#pragma mark -

- (void)logLevel:(int)inLevel format:(NSString *)inFormat, ...
    {
    NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

    va_list theArgList;
    va_start(theArgList, inFormat);
    NSString *theMessage = [[[NSString alloc] initWithFormat:inFormat arguments:theArgList] autorelease];
    va_end(theArgList);

    CLogEvent *theEvent = [[[CLogEvent alloc] init] autorelease];
    theEvent.level = inLevel;
    theEvent.message = theMessage;
    
    [self logEvent:theEvent];

    [thePool release];
    }

- (void)logLevel:(int)inLevel userInfo:(NSDictionary *)inDictionary messageFormat:(NSString *)inFormat, ...;
    {
    NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

    va_list theArgList;
    va_start(theArgList, inFormat);
    NSString *theMessage = [[[NSString alloc] initWithFormat:inFormat arguments:theArgList] autorelease];
    va_end(theArgList);

    CLogEvent *theEvent = [[[CLogEvent alloc] init] autorelease];
    theEvent.level = inLevel;
    theEvent.message = theMessage;
    theEvent.userInfo = inDictionary;

    [self logEvent:theEvent];

    [thePool release];
    }

- (void)logLevel:(int)inLevel fileFunctionLine:(SFileFunctionLine)inFileFunctionLine userInfo:(NSDictionary *)inDictionary messageFormat:(NSString *)inFormat, ...;
    {
    NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

    va_list theArgList;
    va_start(theArgList, inFormat);
    NSString *theMessageString = [[[NSString alloc] initWithFormat:inFormat arguments:theArgList] autorelease];
    va_end(theArgList);

    CLogEvent *theEvent = [[[CLogEvent alloc] init] autorelease];
    theEvent.level = inLevel;
    theEvent.message = theMessageString;
    theEvent.userInfo = inDictionary;

    [self logEvent:theEvent];
    
    [thePool release];
    }

#pragma mark -

- (void)logError:(NSError *)inError
    {
    NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

    NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionaryWithDictionary:inError.userInfo];
    [theUserInfo setObject:[inError domain] forKey:@"domain"];
    [theUserInfo setObject:[NSNumber numberWithInteger:[inError code]] forKey:@"code"];
    if ([inError localizedDescription] != NULL)
        [theUserInfo setObject:[inError localizedDescription] forKey:@"localizedDescription"];
    if ([inError localizedFailureReason] != NULL)
        [theUserInfo setObject:[inError localizedFailureReason] forKey:@"localizedFailureReason"];
    if ([inError localizedRecoverySuggestion] != NULL)
        [theUserInfo setObject:[inError localizedRecoverySuggestion] forKey:@"localizedRecoverySuggestion"];

    CLogEvent *theEvent = [[[CLogEvent alloc] init] autorelease];

    theEvent.level = LoggingLevel_ERR;
    NSNumber *theLevelValue = [inError.userInfo objectForKey:@"level"];
    if (theLevelValue != NULL)
        {
        theEvent.level = [theLevelValue intValue];
        }
    theEvent.message = [inError localizedDescription];
    theEvent.userInfo = theUserInfo;

    [self logEvent:theEvent];

    [thePool release];
    }

- (void)logException:(NSException *)inException
    {
    NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

    if ([inException.userInfo objectForKey:@"error"] != NULL)
        [self logError:[inException.userInfo objectForKey:@"error"]];
    else
        {
        NSDictionary *theUserInfo = [inException userInfo];

        NSMutableDictionary *theDictionary = [NSMutableDictionary dictionaryWithDictionary:theUserInfo];
        [theDictionary setObject:[inException name] forKey:@"name"];
        [theDictionary setObject:[inException reason] forKey:@"reason"];

        int theLevel = LoggingLevel_ERR;
        NSNumber *theLevelValue = [theUserInfo objectForKey:@"level"];
        if (theLevelValue != NULL)
            theLevel = [theLevelValue intValue];

        [self logLevel:theLevel userInfo:theDictionary messageFormat:@"%@", [inException reason]];
        }

    [thePool release];
    }

@end

#pragma mark -

@implementation NSError (NSError_LogExtensions)

- (void)log
    {
    #if LOGGING == 1
    [[CLogging sharedInstance] logError:self];
    #endif /* LOGGING == 1 */
    }

@end

#pragma mark -

@implementation NSException (NSException_LogExtensions)

- (void)log
    {
    #if LOGGING == 1
    [[CLogging sharedInstance] logException:self];
    #endif /* LOGGING == 1 */
    }

@end
