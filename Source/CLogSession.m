//
//  CLogSession.m
//  Logging
//
//  Created by Jonathan Wight on 10/13/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CLogSession.h"

@implementation CLogSession

@synthesize started;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        started = [[NSDate date] retain];
        }
    return(self);
    }

- (void)dealloc
    {
    [started release];
    started = NULL;
    //
    [super dealloc];
    }

@end
