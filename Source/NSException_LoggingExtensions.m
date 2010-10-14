//
//  NSException_LoggingExtensions.m
//  Logging
//
//  Created by Jonathan Wight on 10/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "NSException_LoggingExtensions.h"

#import "CLogging.h"

@implementation NSException (NSException_LoggingExtensions)

- (void)log
    {
    #if LOGGING == 1
    [[CLogging sharedInstance] logException:self];
    #endif /* LOGGING == 1 */
    }

@end
