//
//  jobObject.h
//  Northbay Networks
//
//  Created by Robert Crosby on 7/5/17.
//  Copyright © 2017 moop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "References.h"

@interface jobObject : NSObject
@property (nonatomic,strong) NSString *person;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *company;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *info;
@property (nonatomic,strong) NSNumber *hour;
@property (nonatomic,strong) NSNumber *minutes;
@property (nonatomic,strong) NSNumber *duration;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *dateIndex;
@property (nonatomic, strong) NSString *plainTime;
@property (nonatomic, strong) NSNumber *isComplete;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *instructions;

-(instancetype)initWithType:(NSString*)type andPerson:(NSString*)person andAddress:(NSString*)address andCompany:(NSString*)company andDate:(NSString*)date andHour:(NSNumber*)hour andMinutes:(NSNumber*)minutes andDuration:(NSNumber*)duration andInfo:(NSString*)info andDateIndex:(NSString*)dateIndex andPlainTime:(NSString*)plainTime andIsComplete:(NSNumber*)isComplete andSignature:(NSString*)signature andItems:(NSArray*)items andInstructions:(NSString*)instructions;
-(int)getRows;

@end
