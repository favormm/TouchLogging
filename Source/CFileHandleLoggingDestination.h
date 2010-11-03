//
//  CFileHandleLoggingDestination.h
//  Logging
//
//  Created by Jonathan Wight on 10/13/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLogging.h"

@interface CFileHandleLoggingDestination : NSObject <CLoggingDestination> {
    NSFileHandle *fileHandle;
    BOOL synchronizeOnWrite;
    NSValueTransformer *transformer;
#if NS_BLOCKS_AVAILABLE
    NSData *(^block)(CLogEvent *inEvent);
#endif /* NS_BLOCKS_AVAILABLE */
}

@property (readwrite, nonatomic, retain) NSFileHandle *fileHandle;
@property (readwrite, nonatomic, assign) BOOL synchronizeOnWrite;
@property (readwrite, nonatomic, retain) NSValueTransformer *transformer;
#if NS_BLOCKS_AVAILABLE
@property (readwrite, nonatomic, copy) NSData *(^block)(CLogEvent *inEvent);
#endif /* NS_BLOCKS_AVAILABLE */

- (id)initWithFileHandle:(NSFileHandle *)inFileHandle;

@end
