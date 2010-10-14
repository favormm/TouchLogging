//
//  CLogSession.h
//  Logging
//
//  Created by Jonathan Wight on 10/13/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLogSession : NSObject {
    CLogSession *parentSession;
    NSString *identifier;
    NSDate *started;
}

@property (readonly, nonatomic, assign) CLogSession *parentSession;
@property (readonly, nonatomic, retain) NSString *identifier;
@property (readonly, nonatomic, retain) NSDate *started;

- (id)initWithParentSession:(CLogSession *)inParentSession identifier:(NSString *)inIdentifier;

@end
