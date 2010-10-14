//
//  CLogSession.h
//  Logging
//
//  Created by Jonathan Wight on 10/13/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLogSession : NSObject {
    NSDate *started;
}

@property (readonly, nonatomic, retain) NSDate *started;

@end
