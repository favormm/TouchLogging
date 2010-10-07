//
//  CLoggingDestination.h
//  Logging
//
//  Created by Jonathan Wight on 10/07/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBetterCoreDataManager;
@class NSManagedObject;
@class NSManagedObjectID;

@interface CLoggingDestination : NSObject {
	CBetterCoreDataManager *coreDataManager;
	NSManagedObjectID *sessionID;
}

@property (readonly, copy) NSManagedObjectID *sessionID;
@property (readonly, retain) NSManagedObject *session;

- (void)logDictionary:(NSDictionary *)inDictionary;

@end
