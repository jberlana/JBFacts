//
//  Fact.m
//  Facts
//
//  Created by Javier Berlana on 05/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "Fact.h"

#import "NumberFact.h"
#import "DateFact.h"
#import "RandomFact.h"

@interface Fact()
- (NSString *)invalidInputErrorMessage;
@end

@implementation Fact

#pragma mark - Abstract factory.

+ (Fact *)factWithRawText:(NSString *)text andType:(FactType)type
{
    Fact *fact;
    switch (type)
    {
        case FactTypeNumber:
            fact = [[NumberFact alloc] initWithString:text];
            break;

        case FactTypeDate:
            fact = [[DateFact alloc] initWithString:text];
            break;

        case FactTypeRandom:
            fact = nil;
            break;
    }
    
    return fact;
}


+ (Fact *)factWithNumber:(NSInteger)number;
{
    NumberFact *numberFact = [[NumberFact alloc] initWithNumber:number];
    return numberFact;
}


+ (Fact *)factWithDate:(NSDate *)date
{
    DateFact *dateFact = [[DateFact alloc] initWithDate:date];
    return dateFact;
}


+ (Fact *)factRandom
{
    RandomFact *randomFact = [RandomFact new];
    return randomFact;
}

#pragma mark -

- (NSURLSessionDataTask *)getFactWithSuccess:(void (^)(NSString *fact))success
                                 failure:(void (^)(NSError *error))failure
{
    NSAssert(YES, @"To be implemented by subclasses");
    return nil;
}


- (NSString *)invalidInputErrorMessage
{
    NSAssert(YES, @"To be implemented by subclasses");
    return nil;
}


+ (NSString *)invalidInputErrorMessageForType:(FactType)type;
{
    NSString *message;
    
    switch (type)
    {
        case FactTypeNumber:
            message = [[NumberFact alloc] invalidInputErrorMessage];
            break;
            
        case FactTypeDate:
            message = [[DateFact alloc] invalidInputErrorMessage];
            break;
            
        case FactTypeRandom:
            message = [[RandomFact alloc] invalidInputErrorMessage];
            break;
    }
    
    return message;
}

@end
