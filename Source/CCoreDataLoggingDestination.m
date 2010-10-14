//
//  CLoggingDestination.m
//  Logging
//
//  Created by Jonathan Wight on 10/07/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CCoreDataLoggingDestination.h"

#import <CoreData/CoreData.h>

#import "CBetterCoreDataManager.h"

@interface CCoreDataLoggingDestination () <CCoreDataManagerDelegate>
@property (readwrite, retain) CBetterCoreDataManager *coreDataManager;
@property (readwrite, copy) NSManagedObjectID *sessionID;
@end

#pragma mark -

@implementation CCoreDataLoggingDestination

@synthesize coreDataManager;
@synthesize sessionID;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        }
    return(self);
    }

- (void)dealloc
    {
    //
    [super dealloc];
    }

#pragma mark -

- (CBetterCoreDataManager *)coreDataManager
    {
    @synchronized(@"CLogging.coreDataManager")
        {
        if (coreDataManager == NULL)
            {
    //		NSLog(@"IS MAIN THREAD: %d", [NSThread isMainThread]);

            CBetterCoreDataManager *theCoreDataManager = [[[CBetterCoreDataManager alloc] init] autorelease];

            theCoreDataManager.name = @"Logging";

            theCoreDataManager.defaultMergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;

            NSManagedObject *theSession = [NSEntityDescription insertNewObjectForEntityForName:@"LoggingSession" inManagedObjectContext:theCoreDataManager.managedObjectContext];
            [theSession setValue:[NSDate date] forKey:@"created"];

            coreDataManager = [theCoreDataManager retain];
            coreDataManager.delegate = self;

            [theCoreDataManager save];

    //		NSLog(@"%@", theSession.objectID);
            self.sessionID = theSession.objectID;
            }
        }
    return(coreDataManager);
    }

- (void)setCoreDataManager:(CBetterCoreDataManager *)aCoreDataManager
    {
    if (coreDataManager != aCoreDataManager)
        {
        [coreDataManager release];
        coreDataManager = [aCoreDataManager retain];
        }
    }

- (NSManagedObject *)session
    {
    NSError *theError = NULL;
    NSManagedObject *theSession = [self.coreDataManager.managedObjectContext existingObjectWithID:self.sessionID error:&theError];
    if (theError)
        {
    //	NSLog(@"ERROR >>>> %@", theError);
        return(NULL);
        }

    return(theSession);
    }

- (BOOL)logging:(CLogging *)inLogging didLogEvent:(CLogEvent *)inEvent
    {
    return(NO);
    }

@end
