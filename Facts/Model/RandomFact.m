//
//  RandomFact.m
//  Facts
//
//  Created by Javier Berlana on 05/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "RandomFact.h"

#import "NumbersAPIClient.h"

@interface RandomFact ()
@property (nonatomic, strong, readwrite) NSString *fact;
@property (nonatomic, assign, readwrite) FactType type;
@end

@implementation RandomFact

@synthesize fact = _fact;
@synthesize type = _type;

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type = FactTypeRandom;
    return self;
}


- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"\nType: Random\nFact: %@",self.fact];
    return description;
}


- (NSURLSessionDataTask *)getFactWithSuccess:(void (^)(NSString *fact))success
                                 failure:(void (^)(NSError *error))failure
{
    if (self.fact) {
        success(self.fact);
        return nil;
    }
    
    return [[NumbersAPIClient sharedClient] factRandomSuccess:^(NSString *fact) {
        self.fact = fact;
        if (success) {
            success(fact);
        }
    } failure:failure];
}


- (NSString *)invalidInputErrorMessage
{
    return NSLocalizedString(@"The input should be empty.", @"Error message");
}

@end
