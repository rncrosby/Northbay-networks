//
//  jobObject.m
//  Northbay Networks
//
//  Created by Robert Crosby on 7/5/17.
//  Copyright © 2017 moop. All rights reserved.
//

#import "jobObject.h"

@implementation jobObject


-(instancetype)initWithType:(NSString*)type andPerson:(NSString*)person andAddress:(NSString*)address andCompany:(NSString*)company andDate:(NSString*)date andHour:(NSNumber*)hour andMinutes:(NSNumber*)minutes andDuration:(NSNumber*)duration andInfo:(NSString*)info andDateIndex:(NSString*)dateIndex andPlainTime:(NSString*)plainTime andIsComplete:(NSNumber*)isComplete andSignature:(NSString*)signature{
    self = [super init];
    if(self)
    {
        self.person = person;
        self.type = type;
        self.address = address;
        self.company = company;
        self.date = date;
        self.hour = hour;
        self.minutes = minutes;
        self.duration = duration;
        self.info = info;
        self.dateIndex = dateIndex;
        self.plainTime = plainTime;
        self.isComplete = isComplete;
        self.signature = signature;
        self.code = [References randomStringWithLength:4];
    }
    return self;
}

-(int)getRows {
    int rows = 0;
    if (self.minutes == [NSNumber numberWithInt:0]) {
        rows = 0;
    }
    if (self.minutes == [NSNumber numberWithInt:15]) {
        rows = 1;
    }
    if (self.minutes == [NSNumber numberWithInt:30]) {
        rows = 2;
    }
    if (self.minutes == [NSNumber numberWithInt:45]) {
        rows = 3;
    }
    return rows;
}

@end
