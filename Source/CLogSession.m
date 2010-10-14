//
//  CLogSession.m
//  Logging
//
//  Created by Jonathan Wight on 10/13/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CLogSession.h"

@implementation CLogSession

@synthesize parentSession;
@synthesize identifier;
@synthesize started;

- (id)initWithParentSession:(CLogSession *)inParentSession identifier:(NSString *)inIdentifier
    {
    if ((self = [super init]) != NULL)
        {
        parentSession = inParentSession;
        identifier = [inIdentifier retain];
        started = [[NSDate date] retain];
        }
    return(self);
    }

- (void)dealloc
    {
    parentSession = NULL;
    
    [identifier release];
    identifier = NULL;
    
    [started release];
    started = NULL;
    //
    [super dealloc];
    }

@end
