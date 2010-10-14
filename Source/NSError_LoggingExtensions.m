//
//  NSError_LoggingExtensions.m
//  Logging
//
//  Created by Jonathan Wight on 10/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "NSError_LoggingExtensions.h"

#import "CLogging.h"

@implementation NSError (NSError_LoggingExtensions)

- (void)log
    {
    #if LOGGING == 1
    [[CLogging sharedInstance] logError:self];
    #endif /* LOGGING == 1 */
    }

@end
