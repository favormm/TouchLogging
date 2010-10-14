//
//  CLogEvent.h
//  Logging
//
//  Created by Jonathan Wight on 10/13/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	LoggingLevel_EMERG = 0,
	LoggingLevel_ALERT = 1,
	LoggingLevel_CRIT = 2,
	LoggingLevel_ERR = 3,
	LoggingLevel_WARNING = 4,
	LoggingLevel_NOTICE = 5,
	LoggingLevel_INFO = 6,
	LoggingLevel_DEBUG = 7,
} ELoggingLevel;

@class CLogSession;

@interface CLogEvent : NSObject {
    CLogSession *session;
    NSInteger level;
    NSDate *timestamp;
    NSString *sender;
    NSString *facility;
    NSString *message;
    NSDictionary *userInfo;
}

@property (readwrite, nonatomic, retain) CLogSession *session;
@property (readwrite, nonatomic, assign) NSInteger level;
@property (readwrite, nonatomic, retain) NSDate *timestamp;
@property (readwrite, nonatomic, retain) NSString *sender;
@property (readwrite, nonatomic, retain) NSString *facility;
@property (readwrite, nonatomic, retain) NSString *message;
@property (readwrite, nonatomic, retain) NSDictionary *userInfo;

+ (NSString *)stringForLevel:(NSInteger)inLevel;

@end
